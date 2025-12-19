"""
Core Seating Allocation Algorithm for SeatingAgentX
Deterministic department-interleaved seat assignment
"""

from typing import List, Dict, Any, Tuple
from .models import SeatingRequest, SeatingResponse, SeatAssignment, StudentInfo
from .repository import SeatingRepository


class SeatingAllocator:
    """
    Deterministic seating allocation engine.
    Implements department-interleaved seating to ensure no two students
    from the same department sit on the same bench.
    """

    def __init__(self):
        self.repository = SeatingRepository()

    def generate_allocation(self, request: SeatingRequest) -> SeatingResponse:
        """
        Main method to generate seating allocation.
        
        Process:
        1. Check if exam_id already exists (idempotency)
        2. Fetch students for the year (auto-detect departments)
        3. Create interleaved student queue based on exam type
        4. Allocate seats bench-by-bench
        5. Persist to DynamoDB
        6. Return response
        """
        
        # Step 1: Idempotency check
        if self.repository.check_exam_exists(request.exam_id):
            raise ValueError(f"Seating allocation already exists for exam_id: {request.exam_id}")
        
        # Step 2: Fetch students based on explicit criteria
        print(f"Fetching students for departments: {request.departments}, years: {request.years}")
        students_by_dept = self.repository.fetch_students_by_criteria(
            departments=request.departments,
            years=request.years
        )
        
        if not students_by_dept:
            raise ValueError(f"No students found for criteria {request.departments} {request.years}")
        
        # Step 3: Create interleaved student list based on exam type
        if request.exam_type == "SEM":
            all_students = self._interleave_students_sem(students_by_dept)
        else:  # CIA
            all_students = self._interleave_students_cia(
                students_by_dept, 
                request.years
            )
        
        total_students = len(all_students)
        
        if total_students == 0:
            raise ValueError("No students to allocate after processing")
        
        print(f"Total students to allocate: {total_students}")
        
        # Step 4: Calculate total available seats
        total_benches = sum(hall.benches for hall in request.halls)
        total_seats = total_benches * request.bench_capacity
        
        if total_students > total_seats:
            raise ValueError(
                f"Insufficient benches: {total_students} students, but only {total_seats} seats available"
            )
        
        # Step 5: Allocate seats
        allocations = self._allocate_seats(
            students=all_students,
            halls=request.halls,
            exam_id=request.exam_id,
            subject=request.subject,
            time_slot=request.time_slot,
            bench_capacity=request.bench_capacity
        )
        
        # Step 6: Persist to DynamoDB
        success = self.repository.save_allocation(allocations)
        
        if not success:
            raise RuntimeError("Failed to save seating allocation to database")
        
        # Step 7: Convert to response model
        seat_assignments = [
            SeatAssignment(
                exam_id=alloc['exam_id'],
                hall_id=alloc['hall_id'],
                bench_no=alloc['bench_no'],
                left_student=StudentInfo(**alloc['left_student']) if alloc.get('left_student') else None,
                right_student=StudentInfo(**alloc['right_student']) if alloc.get('right_student') else None
            )
            for alloc in allocations
        ]
        
        detected_depts = list(students_by_dept.keys())
        return SeatingResponse(
            exam_id=request.exam_id,
            exam_type=request.exam_type,
            time_slot=request.time_slot,
            total_students=total_students,
            total_benches=total_benches,
            allocated_students=total_students,
            allocations=seat_assignments,
            message=f"Successfully allocated {total_students} students from {len(detected_depts)} departments to {len(allocations)} benches"
        )

    def _interleave_students_sem(
        self, 
        students_by_dept: Dict[str, List[Dict[str, Any]]]
    ) -> List[Dict[str, Any]]:
        """
        Creates a deterministic interleaved list for SEMESTER exams.
        Uses STRICT round-robin across departments to ensure no same department on bench.
        """
        
        if not students_by_dept:
            return []
        
        # Department names sorted for deterministic order
        dept_names = sorted(students_by_dept.keys())
        
        # Interleave using strict round-robin
        interleaved = []
        dept_indices = {dept: 0 for dept in dept_names}
        
        # Keep going until all students from all departments are processed
        while any(dept_indices[dept] < len(students_by_dept[dept]) for dept in dept_names):
            for dept in dept_names:
                if dept_indices[dept] < len(students_by_dept[dept]):
                    student = students_by_dept[dept][dept_indices[dept]]
                    interleaved.append(student)
                    dept_indices[dept] += 1
        
        print(f"[SEM] Strict interleaved {len(interleaved)} students across {len(dept_names)} departments")
        return interleaved
    
    def _interleave_students_cia(
        self, 
        students_by_dept: Dict[str, List[Dict[str, Any]]],
        years: List[int]
    ) -> List[Dict[str, Any]]:
        """
        Creates a deterministic list for CIA exams.
        PREFERS department separation but ALLOWS same department if unavoidable.
        Strictly groups by YEAR.
        """
        
        if not students_by_dept:
            return []
            
        interleaved_final = []
        
        # Process each year separately for CIA
        for year in sorted(years):
            # Filter students for this year from all departments
            year_students_by_dept = {}
            for dept, students in students_by_dept.items():
                year_students = [s for s in students if s.get('year') == year]
                if year_students:
                    year_students_by_dept[dept] = year_students
            
            if not year_students_by_dept:
                continue
                
            # Interleave this year's students
            dept_names = sorted(year_students_by_dept.keys())
            dept_indices = {dept: 0 for dept in dept_names}
            
            while any(dept_indices[dept] < len(year_students_by_dept[dept]) for dept in dept_names):
                for dept in dept_names:
                    if dept_indices[dept] < len(year_students_by_dept[dept]):
                        student = year_students_by_dept[dept][dept_indices[dept]]
                        interleaved_final.append(student)
                        dept_indices[dept] += 1
                        
        print(f"[CIA] Interleaved {len(interleaved_final)} students across {len(years)} years")
        return interleaved_final

    def _allocate_seats(
        self,
        students: List[Dict[str, Any]],
        halls: List[Any],
        exam_id: str,
        subject: str,
        time_slot: int,
        bench_capacity: int
    ) -> List[Dict[str, Any]]:
        """
        Allocates students to benches sequentially.
        """
        allocations = []
        student_index = 0
        total_students = len(students)
        
        for hall in halls:
            hall_id = hall.hall_id
            num_benches = hall.benches
            
            for bench_no in range(1, num_benches + 1):
                if student_index >= total_students:
                    # All students allocated, create empty bench entry
                    allocations.append({
                        'exam_id': exam_id,
                        'subject': subject,
                        'time_slot': time_slot,
                        'hall_id': hall_id,
                        'bench_no': bench_no,
                        'left_student': None,
                        'right_student': None
                    })
                    continue
                
                # Allocate left student
                left_student = None
                if student_index < total_students:
                    s = students[student_index]
                    left_student = {
                        'roll_no': s.get('roll_no'),
                        'department': s.get('department'),
                        'year': s.get('year'),
                        'name': s.get('name')
                    }
                    student_index += 1
                
                # Allocate right student
                right_student = None
                if student_index < total_students and bench_capacity == 2:
                    s = students[student_index]
                    right_student = {
                        'roll_no': s.get('roll_no'),
                        'department': s.get('department'),
                        'year': s.get('year'),
                        'name': s.get('name')
                    }
                    student_index += 1
                
                allocations.append({
                    'exam_id': exam_id,
                    'subject': subject,
                    'time_slot': time_slot,
                    'hall_id': hall_id,
                    'bench_no': bench_no,
                    'left_student': left_student,
                    'right_student': right_student
                })
        
        print(f"Created {len(allocations)} bench allocations")
        return allocations

    def get_allocation(self, exam_id: str) -> List[Dict[str, Any]]:
        """Retrieves existing seating allocation"""
        return self.repository.get_allocation_by_exam(exam_id)

    def get_hall_allocation(self, exam_id: str, hall_id: str) -> List[Dict[str, Any]]:
        """Retrieves seating allocation for a specific hall"""
        return self.repository.get_allocation_by_hall(exam_id, hall_id)

    def get_student_allocation(self, exam_id: str, roll_no: str) -> Dict[str, Any]:
        """Retrieves seat assignment for a specific student"""
        result = self.repository.get_allocation_by_student(exam_id, roll_no)
        if not result:
            raise ValueError(f"No seat allocation found for student {roll_no} in exam {exam_id}")
        return result

