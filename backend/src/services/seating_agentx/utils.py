"""
Utility Functions for SeatingAgentX
CSV generation and helper functions
"""

import io
from typing import List, Dict, Any


def generate_csv(allocations: List[Dict[str, Any]]) -> str:
    """
    Generates CSV content from seating allocations.
    
    CSV Format:
    Hall ID, Bench No, Left Roll, Left Department, Right Roll, Right Department
    
    Args:
        allocations: List of seat assignment dictionaries
    
    Returns:
        CSV content as string
    """
    output = io.StringIO()
    
    # Write header
    output.write("Hall ID,Bench No,Left Roll,Left Department,Right Roll,Right Department\n")
    
    # Sort allocations by hall_id and bench_no for consistent output
    sorted_allocations = sorted(allocations, key=lambda x: (x['hall_id'], x['bench_no']))
    
    # Write data rows
    for alloc in sorted_allocations:
        hall_id = alloc['hall_id']
        bench_no = alloc['bench_no']
        
        # Left student details
        left_roll = ""
        left_dept = ""
        if alloc.get('left_student'):
            left_roll = alloc['left_student'].get('roll_no', '')
            left_dept = alloc['left_student'].get('department', '')
        
        # Right student details
        right_roll = ""
        right_dept = ""
        if alloc.get('right_student'):
            right_roll = alloc['right_student'].get('roll_no', '')
            right_dept = alloc['right_student'].get('department', '')
        
        # Write row
        output.write(f"{hall_id},{bench_no},{left_roll},{left_dept},{right_roll},{right_dept}\n")
    
    csv_content = output.getvalue()
    output.close()
    
    return csv_content


def validate_allocation_constraints(allocations: List[Dict[str, Any]]) -> Dict[str, Any]:
    """
    Validates seating allocation constraints.
    Checks if any bench has two students from the same department.
    
    Returns:
        {
            'valid': bool,
            'violations': List[Dict],
            'message': str
        }
    """
    violations = []
    
    for alloc in allocations:
        left = alloc.get('left_student')
        right = alloc.get('right_student')
        
        # Check if both seats are occupied
        if left and right:
            # Check if same department
            if left.get('department') == right.get('department'):
                violations.append({
                    'hall_id': alloc['hall_id'],
                    'bench_no': alloc['bench_no'],
                    'issue': 'Same department on bench',
                    'left_dept': left['department'],
                    'right_dept': right['department']
                })
    
    valid = len(violations) == 0
    message = "All constraints satisfied" if valid else f"Found {len(violations)} constraint violations"
    
    return {
        'valid': valid,
        'violations': violations,
        'message': message
    }


def get_allocation_statistics(allocations: List[Dict[str, Any]]) -> Dict[str, Any]:
    """
    Generates statistics about seating allocation.
    
    Returns:
        {
            'total_benches': int,
            'occupied_benches': int,
            'total_students': int,
            'department_distribution': Dict[str, int]
        }
    """
    total_benches = len(allocations)
    occupied_benches = 0
    total_students = 0
    dept_count = {}
    
    for alloc in allocations:
        has_student = False
        
        left = alloc.get('left_student')
        if left:
            has_student = True
            total_students += 1
            dept = left.get('department', 'Unknown')
            dept_count[dept] = dept_count.get(dept, 0) + 1
        
        right = alloc.get('right_student')
        if right:
            has_student = True
            total_students += 1
            dept = right.get('department', 'Unknown')
            dept_count[dept] = dept_count.get(dept, 0) + 1
        
        if has_student:
            occupied_benches += 1
    
    return {
        'total_benches': total_benches,
        'occupied_benches': occupied_benches,
        'empty_benches': total_benches - occupied_benches,
        'total_students': total_students,
        'department_distribution': dept_count
    }

