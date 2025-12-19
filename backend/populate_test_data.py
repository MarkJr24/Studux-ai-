"""
Populate StudX_StudentMaster with Test Data

This script adds sample students to the DynamoDB table for testing SeatingAgentX.
"""

import boto3
from botocore.exceptions import ClientError

# Configuration
REGION = "ap-south-2"
TABLE_NAME = "StudX_StudentMaster"

def populate_test_students():
    """Add test students to DynamoDB"""
    
    print("="*70)
    print("Populating StudX_StudentMaster with Test Data")
    print("="*70)
    
    # Initialize DynamoDB
    dynamodb = boto3.resource('dynamodb', region_name=REGION)
    table = dynamodb.Table(TABLE_NAME)
    
    # Test students data
    # Schema: pk=STUDENT#<DEPARTMENT>, sk=YEAR#<YEAR>#ROLL#<ROLL_NO>
    test_students = [
        # CSE Year 3
        {'pk': 'STUDENT#CSE', 'sk': 'YEAR#3#ROLL#CSE301', 'roll_no': 'CSE301', 'department': 'CSE', 'year': 3, 'name': 'Alice Johnson'},
        {'pk': 'STUDENT#CSE', 'sk': 'YEAR#3#ROLL#CSE302', 'roll_no': 'CSE302', 'department': 'CSE', 'year': 3, 'name': 'Bob Smith'},
        {'pk': 'STUDENT#CSE', 'sk': 'YEAR#3#ROLL#CSE303', 'roll_no': 'CSE303', 'department': 'CSE', 'year': 3, 'name': 'Charlie Brown'},
        {'pk': 'STUDENT#CSE', 'sk': 'YEAR#3#ROLL#CSE304', 'roll_no': 'CSE304', 'department': 'CSE', 'year': 3, 'name': 'Diana Prince'},
        {'pk': 'STUDENT#CSE', 'sk': 'YEAR#3#ROLL#CSE305', 'roll_no': 'CSE305', 'department': 'CSE', 'year': 3, 'name': 'Ethan Hunt'},
        
        # ECE Year 3
        {'pk': 'STUDENT#ECE', 'sk': 'YEAR#3#ROLL#ECE301', 'roll_no': 'ECE301', 'department': 'ECE', 'year': 3, 'name': 'Fiona Green'},
        {'pk': 'STUDENT#ECE', 'sk': 'YEAR#3#ROLL#ECE302', 'roll_no': 'ECE302', 'department': 'ECE', 'year': 3, 'name': 'George Wilson'},
        {'pk': 'STUDENT#ECE', 'sk': 'YEAR#3#ROLL#ECE303', 'roll_no': 'ECE303', 'department': 'ECE', 'year': 3, 'name': 'Hannah Lee'},
        {'pk': 'STUDENT#ECE', 'sk': 'YEAR#3#ROLL#ECE304', 'roll_no': 'ECE304', 'department': 'ECE', 'year': 3, 'name': 'Ian Malcolm'},
        
        # AI&DS Year 3
        {'pk': 'STUDENT#AI&DS', 'sk': 'YEAR#3#ROLL#AI301', 'roll_no': 'AI301', 'department': 'AI&DS', 'year': 3, 'name': 'Julia Roberts'},
        {'pk': 'STUDENT#AI&DS', 'sk': 'YEAR#3#ROLL#AI302', 'roll_no': 'AI302', 'department': 'AI&DS', 'year': 3, 'name': 'Kevin Hart'},
        {'pk': 'STUDENT#AI&DS', 'sk': 'YEAR#3#ROLL#AI303', 'roll_no': 'AI303', 'department': 'AI&DS', 'year': 3, 'name': 'Laura Palmer'},
        
        # CSE Year 1 (for additional testing)
        {'pk': 'STUDENT#CSE', 'sk': 'YEAR#1#ROLL#CSE101', 'roll_no': 'CSE101', 'department': 'CSE', 'year': 1, 'name': 'Mike Ross'},
        {'pk': 'STUDENT#CSE', 'sk': 'YEAR#1#ROLL#CSE102', 'roll_no': 'CSE102', 'department': 'CSE', 'year': 1, 'name': 'Nancy Drew'},
        
        # ECE Year 1
        {'pk': 'STUDENT#ECE', 'sk': 'YEAR#1#ROLL#ECE101', 'roll_no': 'ECE101', 'department': 'ECE', 'year': 1, 'name': 'Oscar Wilde'},
        {'pk': 'STUDENT#ECE', 'sk': 'YEAR#1#ROLL#ECE102', 'roll_no': 'ECE102', 'department': 'ECE', 'year': 1, 'name': 'Penny Lane'},
    ]
    
    print(f"\nAdding {len(test_students)} test students to {TABLE_NAME}...")
    print("-"*70)
    
    success_count = 0
    error_count = 0
    
    for student in test_students:
        try:
            table.put_item(Item=student)
            print(f"✓ Added: {student['roll_no']} - {student['name']} ({student['department']} Year {student['year']})")
            success_count += 1
        except ClientError as e:
            print(f"✗ Error adding {student['roll_no']}: {e}")
            error_count += 1
    
    print("\n" + "="*70)
    print(f"✅ Successfully added {success_count} students")
    if error_count > 0:
        print(f"❌ Failed to add {error_count} students")
    print("="*70)
    
    print("\nTest Data Summary:")
    print("  CSE Year 3: 5 students")
    print("  ECE Year 3: 4 students")
    print("  AI&DS Year 3: 3 students")
    print("  CSE Year 1: 2 students")
    print("  ECE Year 1: 2 students")
    print("  Total: 16 students")
    
    print("\nNow you can test seating allocation with:")
    print("  Departments: CSE, ECE, AI&DS")
    print("  Year: 3")
    print("  Expected: 12 students allocated")

if __name__ == '__main__':
    try:
        populate_test_students()
    except Exception as e:
        print(f"\n❌ ERROR: {e}")
        import traceback
        traceback.print_exc()
