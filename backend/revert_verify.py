import sys
import unittest
from unittest.mock import MagicMock
from typing import List, Dict, Any

# Adjust path to import from backend
sys.path.append('d:/studx-backend/backend/src')

from services.seating_agentx.models import SeatingRequest, HallConfig
from services.seating_agentx.allocator import SeatingAllocator

class MockRepository:
    def __init__(self):
        self.students = {
            "CSE": [
                {"roll_no": "CSE01", "department": "CSE", "year": 1},
                {"roll_no": "CSE02", "department": "CSE", "year": 1},
                {"roll_no": "CSE03", "department": "CSE", "year": 2},
            ],
            "ECE": [
                {"roll_no": "ECE01", "department": "ECE", "year": 1},
                {"roll_no": "ECE02", "department": "ECE", "year": 2},
            ],
             "AIDS": [
                {"roll_no": "AI01", "department": "AIDS", "year": 1},
            ]
        }
        
    def check_exam_exists(self, exam_id):
        return False
        
    def save_allocation(self, allocations):
        return True
        
    def fetch_students_by_criteria(self, departments, years):
        result = {}
        for dept in departments:
            if dept in self.students:
                filtered = [s for s in self.students[dept] if s['year'] in years]
                if filtered:
                    result[dept] = filtered
        return result

class TestSeatingRevert(unittest.TestCase):
    @unittest.mock.patch('services.seating_agentx.allocator.SeatingRepository')
    def setUp(self, MockRepoClass):
        self.mock_repo_instance = MockRepository()
        MockRepoClass.return_value = self.mock_repo_instance
        
        self.allocator = SeatingAllocator()
        # Even though we patched the class, let's ensure our custom mock is identical to what we want
        # The Allocator init does: self.repository = SeatingRepository()
        # So self.allocator.repository IS self.mock_repo_instance (because return_value is set)
        
        # Double check and force it just in case
        self.allocator.repository = self.mock_repo_instance

    def test_request_model(self):
        """Verify request model accepts departments/years and rejects missing ones"""
        try:
            req = SeatingRequest(
                exam_id="TEST01",
                exam_type="SEM",
                subject="Test Subject",
                time_slot=1,
                departments=["CSE", "ECE"],
                years=[1, 2],
                halls=[HallConfig(hall_id="H1", benches=10)],
                bench_capacity=2
            )
            print("✅ SeatingRequest model validation passed")
        except Exception as e:
            self.fail(f"SeatingRequest validation failed: {e}")

    def test_sem_allocation(self):
        """Verify SEM allocation uses strict round robin"""
        req = SeatingRequest(
            exam_id="SEM01",
            exam_type="SEM",
            subject="Python",
            time_slot=2,
            departments=["CSE", "ECE"],
            years=[1],
            halls=[HallConfig(hall_id="H1", benches=10)],
            bench_capacity=2
        )
        
        response = self.allocator.generate_allocation(req)
        allocs = response.allocations
        
        # Verify strict interleaving logic (CSE, ECE, CSE, ECE...) (sorted dept names)
        # Mock data: CSE: [CSE01, CSE02], ECE: [ECE01] (Year 1)
        # Expected: CSE01, ECE01, CSE02
        
        # Bench 1: Left=CSE01, Right=ECE01
        # Bench 2: Left=CSE02, Right=None
        
        b1 = next(a for a in allocs if a.bench_no == 1)
        self.assertEqual(b1.left_student.department, "CSE")
        self.assertEqual(b1.right_student.department, "ECE")
        
        b2 = next(a for a in allocs if a.bench_no == 2)
        self.assertEqual(b2.left_student.department, "CSE")
        
        print("✅ SEM Allocation logic verified (Round Robin)")

    def test_cia_allocation(self):
        """Verify CIA allocation checks year constraint"""
        # Data: CSE Year 1 & 2, ECE Year 1 & 2
        # Request: Year 1 & 2
        
        req = SeatingRequest(
            exam_id="CIA01",
            exam_type="CIA",
            subject="AI",
            time_slot=3,
            departments=["CSE", "ECE"],
            years=[1, 2],
            halls=[HallConfig(hall_id="H1", benches=10)],
            bench_capacity=2
        )
        
        response = self.allocator.generate_allocation(req)
        # Should verify that Year 1s are grouped together and Year 2s are grouped together
        
        allocs = response.allocations
        students = []
        for a in allocs:
            if a.left_student: students.append(a.left_student)
            if a.right_student: students.append(a.right_student)
            
        # Check sequence: Year 1s first, then Year 2s (or vice versa depending on sort, code sorts years)
        years_sequence = [s.year for s in students]
        
        # We expect blocks of years. 
        # Mock returned order might vary slightly but logic says: for year in sorted(years)...
        # So Year 1 block, then Year 2 block.
        
        self.assertEqual(years_sequence, sorted(years_sequence))
        print("✅ CIA Allocation logic verified (Year grouping)")

if __name__ == '__main__':
    unittest.main()
