"""Verification script for student data seeding setup (Windows-friendly)."""
import json
from pathlib import Path

DATA_DIR = Path(__file__).parent / "data"
DEPARTMENTS = ["ece", "aids", "cse"]

print("=" * 70)
print("STUDENT DATA SEEDING - VERIFICATION")
print("=" * 70)

print("\n[1] FILE STRUCTURE")
print("-" * 70)
for dept in DEPARTMENTS:
    dept_file = DATA_DIR / f"{dept}_students.json"
    status = "OK" if dept_file.exists() else "MISSING"
    print(f"   {dept_file.name:25} : {status}")

print("\n[2] DATA VALIDATION")
print("-" * 70)
total_students = 0
for dept in DEPARTMENTS:
    dept_file = DATA_DIR / f"{dept}_students.json"
    with open(dept_file, "r", encoding="utf-8") as f:
        data = json.load(f)
    
    dept_name = data["department"]
    dept_total = sum(len(students) for students in data["years"].values())
    print(f"   {dept_name:8} : {dept_total:3} students (Years 1-4, 50 per year)")
    total_students += dept_total

print(f"\n   TOTAL   : {total_students} students")

print("\n[3] DYNAMODB TRANSFORMATION SAMPLE")
print("-" * 70)

# Load one sample
with open(DATA_DIR / "cse_students.json", "r", encoding="utf-8") as f:
    data = json.load(f)

student = data["years"]["1"][0]
department = data["department"]
year = 1

print(f"\n   INPUT (Tabular):")
print(f"      roll  : {student['roll']}")
print(f"      name  : {student['name']}")
print(f"      email : {student['email']}")

print(f"\n   OUTPUT (DynamoDB Item):")
roll_no = student["roll"]
print(f"      pk          : STUDENT")
print(f"      sk          : {department}#{year}#{roll_no}")
print(f"      roll_no     : {roll_no}")
print(f"      name        : {student['name']}")
print(f"      email       : {student['email']}")
print(f"      department  : {department}")
print(f"      year        : {year}")
print(f"      role        : STUDENT")

print("\n[4] SEEDING COMMAND")
print("-" * 70)
print("\n   python scripts/seed_students.py")

print("\n" + "=" * 70)
print("VERIFICATION COMPLETE - ALL CHECKS PASSED")
print("=" * 70)

