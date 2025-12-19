"""
Repository Layer for SeatingAgentX
Handles all DynamoDB read/write operations
"""

import boto3
import os
from typing import List, Dict, Any, Optional
from botocore.exceptions import ClientError

# DynamoDB Configuration from Environment Variables
REGION = os.getenv("AWS_REGION_NAME", "ap-south-2")
STUDENT_TABLE = os.getenv("STUDENT_TABLE", "StudX_StudentMaster")
SEATING_TABLE = os.getenv("SEATING_TABLE", "StudX_SeatingAllocations")

# Defensive checks
assert STUDENT_TABLE, "STUDENT_TABLE environment variable is required"
assert SEATING_TABLE, "SEATING_TABLE environment variable is required"


class SeatingRepository:
    """Handles DynamoDB operations for seating allocation"""

    def __init__(self):
        self.dynamodb = boto3.resource('dynamodb', region_name=REGION)
        self.student_table = self.dynamodb.Table(STUDENT_TABLE)
        self.seating_table = self._ensure_seating_table_exists()

    def _ensure_seating_table_exists(self):
        """Ensures the seating allocations table exists, creates if not"""
        dynamodb_client = boto3.client('dynamodb', region_name=REGION)
        
        try:
            # Check if table exists
            dynamodb_client.describe_table(TableName=SEATING_TABLE)
            print(f"✅ Table '{SEATING_TABLE}' exists")
        except ClientError as e:
            if e.response['Error']['Code'] == 'ResourceNotFoundException':
                print(f"⚠️  Table '{SEATING_TABLE}' not found. Creating...")
                try:
                    dynamodb_client.create_table(
                        TableName=SEATING_TABLE,
                        KeySchema=[
                            {'AttributeName': 'exam_id', 'KeyType': 'HASH'},
                            {'AttributeName': 'seat_key', 'KeyType': 'RANGE'}
                        ],
                        AttributeDefinitions=[
                            {'AttributeName': 'exam_id', 'AttributeType': 'S'},
                            {'AttributeName': 'seat_key', 'AttributeType': 'S'}
                        ],
                        BillingMode='PAY_PER_REQUEST',
                        Tags=[
                            {'Key': 'Environment', 'Value': 'Production'},
                            {'Key': 'Application', 'Value': 'StudX'}
                        ]
                    )
                    
                    # Wait for table to be created
                    waiter = dynamodb_client.get_waiter('table_exists')
                    waiter.wait(TableName=SEATING_TABLE)
                    
                    print(f"✅ Table '{SEATING_TABLE}' created successfully")
                except ClientError as create_error:
                    print(f"❌ Failed to create table: {create_error}")
                    raise
        
        return self.dynamodb.Table(SEATING_TABLE)

    def fetch_students_by_criteria(
        self, 
        departments: List[str],
        years: List[int]
    ) -> Dict[str, List[Dict[str, Any]]]:
        """
        Fetches students from StudX_StudentMaster for given departments and years.
        Returns deterministic ordering (sorted by roll_no within each department).
        
        Schema:
            pk: STUDENT#<DEPARTMENT>
            sk: YEAR#<YEAR>#ROLL#<ROLL_NO>
        
        Args:
            departments: List of department codes (e.g., ['CSE', 'ECE', 'AI&DS'])
            years: List of academic years (e.g., [1, 2, 3, 4])
        
        Returns:
            {
                "CSE": [student1, student2, ...],
                "ECE": [...],
                ...
            }
        """
        students_by_dept = {}
        
        for dept in departments:
            dept_students = []
            for year in years:
                # Query using correct schema pattern
                # pk = "STUDENT#<DEPARTMENT>"
                # sk begins_with "YEAR#<YEAR>#"
                try:
                    pk_value = f"STUDENT#{dept}"
                    sk_prefix = f"YEAR#{year}#"
                    
                    response = self.student_table.query(
                        KeyConditionExpression=boto3.dynamodb.conditions.Key('pk').eq(pk_value) &
                                              boto3.dynamodb.conditions.Key('sk').begins_with(sk_prefix)
                    )
                    
                    batch = response.get('Items', [])
                    if batch:
                        dept_students.extend(batch)
                        print(f"✓ Fetched {len(batch)} students for {dept} Year {year}")
                    else:
                        print(f"  No students found for {dept} Year {year}")
                
                except ClientError as e:
                    print(f"❌ Error fetching students for {dept} Year {year}: {e}")
                    continue
            
            if dept_students:
                # Sort deterministically by roll_no
                dept_students.sort(key=lambda s: s.get('roll_no', ''))
                students_by_dept[dept] = dept_students
        
        if not students_by_dept:
            print(f"⚠️  No students found for criteria: departments={departments}, years={years}")
        else:
            total = sum(len(students) for students in students_by_dept.values())
            print(f"✓ Total students fetched: {total} across {len(students_by_dept)} departments")
        
        return students_by_dept

    def check_exam_exists(self, exam_id: str) -> bool:
        """Checks if seating allocation already exists for the given exam_id"""
        try:
            response = self.seating_table.query(
                KeyConditionExpression=boto3.dynamodb.conditions.Key('exam_id').eq(exam_id),
                Limit=1
            )
            return response.get('Count', 0) > 0
        except ClientError as e:
            print(f"Error checking exam existence: {e}")
            return False

    def save_allocation(self, allocations: List[Dict[str, Any]]) -> bool:
        """
        Saves seating allocations to DynamoDB using batch_writer.
        
        Args:
            allocations: List of seat assignment dictionaries
        
        Returns:
            True if successful, False otherwise
        """
        if not allocations:
            print("⚠️  No allocations to save")
            return False
        
        try:
            with self.seating_table.batch_writer() as batch:
                for allocation in allocations:
                    # Create seat_key as "hall_id#bench_no"
                    seat_key = f"{allocation['hall_id']}#{allocation['bench_no']}"
                    
                    item = {
                        'exam_id': allocation['exam_id'],
                        'seat_key': seat_key,
                        'hall_id': allocation['hall_id'],
                        'bench_no': allocation['bench_no'],
                        'subject': allocation['subject'],
                        'time_slot': allocation['time_slot']
                    }
                    
                    # Add left student if present
                    if allocation.get('left_student'):
                        item['left_roll'] = allocation['left_student']['roll_no']
                        item['left_dept'] = allocation['left_student']['department']
                        item['left_year'] = allocation['left_student']['year']
                        if allocation['left_student'].get('name'):
                            item['left_name'] = allocation['left_student']['name']
                    
                    # Add right student if present
                    if allocation.get('right_student'):
                        item['right_roll'] = allocation['right_student']['roll_no']
                        item['right_dept'] = allocation['right_student']['department']
                        item['right_year'] = allocation['right_student']['year']
                        if allocation['right_student'].get('name'):
                            item['right_name'] = allocation['right_student']['name']
                    
                    batch.put_item(Item=item)
            
            print(f"✅ Saved {len(allocations)} seat allocations")
            return True
        
        except ClientError as e:
            print(f"❌ Error saving allocations: {e}")
            return False

    def get_allocation_by_exam(self, exam_id: str) -> List[Dict[str, Any]]:
        """Retrieves all seat allocations for a given exam_id"""
        try:
            response = self.seating_table.query(
                KeyConditionExpression=boto3.dynamodb.conditions.Key('exam_id').eq(exam_id)
            )
            
            items = response.get('Items', [])
            
            # Convert DynamoDB items to structured format
            allocations = []
            for item in items:
                allocation = {
                    'exam_id': item['exam_id'],
                    'hall_id': item['hall_id'],
                    'bench_no': int(item['bench_no'])
                }
                
                # Add left student if present
                if 'left_roll' in item:
                    allocation['left_student'] = {
                        'roll_no': item['left_roll'],
                        'department': item['left_dept'],
                        'year': int(item['left_year'])
                    }
                    if 'left_name' in item:
                        allocation['left_student']['name'] = item['left_name']
                
                # Add right student if present
                if 'right_roll' in item:
                    allocation['right_student'] = {
                        'roll_no': item['right_roll'],
                        'department': item['right_dept'],
                        'year': int(item['right_year'])
                    }
                    if 'right_name' in item:
                        allocation['right_student']['name'] = item['right_name']
                
                allocations.append(allocation)
            
            # Sort by hall_id and bench_no for consistent ordering
            allocations.sort(key=lambda x: (x['hall_id'], x['bench_no']))
            
            return allocations
        
        except ClientError as e:
            print(f"Error retrieving allocation: {e}")
            return []

    def get_allocation_by_hall(self, exam_id: str, hall_id: str) -> List[Dict[str, Any]]:
        """Retrieves seat allocations for a specific hall"""
        all_allocations = self.get_allocation_by_exam(exam_id)
        return [a for a in all_allocations if a['hall_id'] == hall_id]

    def get_allocation_by_student(self, exam_id: str, roll_no: str) -> Optional[Dict[str, Any]]:
        """Retrieves seat allocation for a specific student"""
        all_allocations = self.get_allocation_by_exam(exam_id)
        
        for allocation in all_allocations:
            left = allocation.get('left_student')
            right = allocation.get('right_student')
            
            if left and left['roll_no'] == roll_no:
                return {
                    **allocation,
                    'seat_position': 'left'
                }
            
            if right and right['roll_no'] == roll_no:
                return {
                    **allocation,
                    'seat_position': 'right'
                }
        
        return None

