"""
Faculty Master Data Seeding Script for StudX Backend
Inserts faculty data into DynamoDB table: StudX_FacultyMaster
Region: ap-south-2
Runtime: Python 3.11

USAGE:
    python seed_faculties.py
"""

import boto3
import json
import os
from botocore.exceptions import ClientError

# ============================================================================
# CONFIGURATION
# ============================================================================
TABLE_NAME = "StudX_FacultyMaster"
REGION = "ap-south-2"
DATA_FILE = os.path.join(os.path.dirname(__file__), "data", "faculty_master.json")

# Required fields for validation
REQUIRED_FIELDS = ["faculty_id", "name", "email", "department"]


# ============================================================================
# TABLE VERIFICATION / CREATION
# ============================================================================
def ensure_table_exists():
    """
    Verifies that the DynamoDB table exists.
    If it does NOT exist, creates it with the correct schema.
    """
    dynamodb = boto3.client('dynamodb', region_name=REGION)
    
    try:
        # Check if table exists
        response = dynamodb.describe_table(TableName=TABLE_NAME)
        print(f"✅ Table '{TABLE_NAME}' already exists")
        return True
    except ClientError as e:
        if e.response['Error']['Code'] == 'ResourceNotFoundException':
            print(f"⚠️  Table '{TABLE_NAME}' not found. Creating...")
            try:
                dynamodb.create_table(
                    TableName=TABLE_NAME,
                    KeySchema=[
                        {'AttributeName': 'faculty_id', 'KeyType': 'HASH'}
                    ],
                    AttributeDefinitions=[
                        {'AttributeName': 'faculty_id', 'AttributeType': 'S'}
                    ],
                    BillingMode='PAY_PER_REQUEST',
                    Tags=[
                        {'Key': 'Environment', 'Value': 'Production'},
                        {'Key': 'Application', 'Value': 'StudX'}
                    ]
                )
                
                # Wait for table to be created
                waiter = dynamodb.get_waiter('table_exists')
                waiter.wait(TableName=TABLE_NAME)
                
                print(f"✅ Table '{TABLE_NAME}' created successfully")
                return True
            except ClientError as create_error:
                print(f"❌ Failed to create table: {create_error}")
                return False
        else:
            print(f"❌ Error checking table: {e}")
            return False


# ============================================================================
# DATA LOADING & VALIDATION
# ============================================================================
def load_faculty_data():
    """
    Loads faculty data from JSON file.
    Returns list of faculty records or empty list on error.
    """
    if not os.path.exists(DATA_FILE):
        print(f"❌ Data file not found: {DATA_FILE}")
        return []
    
    try:
        with open(DATA_FILE, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        faculties = data.get("faculties", [])
        print(f"📥 Loaded {len(faculties)} faculty records from file")
        return faculties
    except json.JSONDecodeError as e:
        print(f"❌ Invalid JSON in data file: {e}")
        return []
    except Exception as e:
        print(f"❌ Error loading data file: {e}")
        return []


def validate_faculty_record(record, index):
    """
    Validates a single faculty record.
    Returns True if valid, False otherwise.
    Logs specific validation errors.
    """
    # Check if record is a dictionary
    if not isinstance(record, dict):
        print(f"⚠️  Record {index}: Invalid format (not a dictionary)")
        return False
    
    # Check required fields
    missing_fields = [field for field in REQUIRED_FIELDS if field not in record or not record[field]]
    if missing_fields:
        print(f"⚠️  Record {index}: Missing required fields: {', '.join(missing_fields)}")
        return False
    
    # Basic email validation
    if '@' not in record['email']:
        print(f"⚠️  Record {index} ({record.get('faculty_id', 'UNKNOWN')}): Invalid email format")
        return False
    
    return True


# ============================================================================
# IDEMPOTENT INSERTION
# ============================================================================
def check_faculty_exists(table, faculty_id):
    """
    Checks if a faculty record already exists in DynamoDB.
    Returns True if exists, False otherwise.
    """
    try:
        response = table.get_item(Key={'faculty_id': faculty_id})
        return 'Item' in response
    except ClientError:
        return False


def seed_faculties():
    """
    Main function to seed faculty data into DynamoDB.
    - Validates table existence (creates if needed)
    - Loads and validates data
    - Inserts records using batch_writer (idempotent)
    - Logs detailed summary
    """
    print("=" * 70)
    print("🚀 StudX Faculty Master Data Seeding")
    print("=" * 70)
    print(f"📍 Region: {REGION}")
    print(f"📊 Table: {TABLE_NAME}")
    print()
    
    # Step 1: Ensure table exists
    if not ensure_table_exists():
        print("\n❌ Cannot proceed without a valid table")
        return
    
    print()
    
    # Step 2: Load faculty data
    faculties = load_faculty_data()
    if not faculties:
        print("❌ No faculty data to insert")
        return
    
    print()
    
    # Step 3: Connect to DynamoDB resource
    try:
        dynamodb = boto3.resource('dynamodb', region_name=REGION)
        table = dynamodb.Table(TABLE_NAME)
    except ClientError as e:
        print(f"❌ Failed to connect to DynamoDB: {e}")
        return
    
    # Step 4: Validate and insert records
    total_records = len(faculties)
    valid_records = []
    skipped_records = 0
    
    print("🔍 Validating records...")
    for index, faculty in enumerate(faculties, start=1):
        if validate_faculty_record(faculty, index):
            valid_records.append(faculty)
        else:
            skipped_records += 1
    
    print(f"✅ Valid records: {len(valid_records)}")
    print(f"⚠️  Skipped (invalid): {skipped_records}")
    print()
    
    if not valid_records:
        print("❌ No valid records to insert")
        return
    
    # Step 5: Insert using batch_writer (idempotent approach)
    print("💾 Inserting faculty records...")
    inserted_count = 0
    already_exists_count = 0
    
    with table.batch_writer() as batch:
        for faculty in valid_records:
            faculty_id = faculty['faculty_id']
            
            # Check if faculty already exists (idempotency)
            if check_faculty_exists(table, faculty_id):
                print(f"⏭️  Skipped (already exists): {faculty_id} - {faculty['name']}")
                already_exists_count += 1
                continue
            
            # Insert the faculty record
            batch.put_item(Item=faculty)
            inserted_count += 1
    
    # Step 6: Summary
    print()
    print("=" * 70)
    print("🎉 Faculty Seeding Completed")
    print("=" * 70)
    print(f"📊 Total records processed: {total_records}")
    print(f"✅ Successfully inserted: {inserted_count}")
    print(f"⏭️  Already existed (skipped): {already_exists_count}")
    print(f"⚠️  Invalid (skipped): {skipped_records}")
    print("=" * 70)


# ============================================================================
# ENTRY POINT
# ============================================================================
if __name__ == "__main__":
    seed_faculties()

