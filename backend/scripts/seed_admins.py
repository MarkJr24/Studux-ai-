"""
Admin Master Data Seeding Script for StudX Backend
Inserts admin data into DynamoDB table: StudX_AdminMaster
Region: ap-south-2
Runtime: Python 3.11

USAGE:
    python seed_admins.py
"""

import boto3
import json
import os
from botocore.exceptions import ClientError

# ============================================================================
# CONFIGURATION
# ============================================================================
TABLE_NAME = "StudX_AdminMaster"
REGION = "ap-south-2"
DATA_FILE = os.path.join(os.path.dirname(__file__), "data", "admin_master.json")

# Required fields for validation
REQUIRED_FIELDS = ["admin_id", "name", "email", "designation"]


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
                        {'AttributeName': 'admin_id', 'KeyType': 'HASH'}
                    ],
                    AttributeDefinitions=[
                        {'AttributeName': 'admin_id', 'AttributeType': 'S'}
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
def load_admin_data():
    """
    Loads admin data from JSON file.
    Returns list of admin records or empty list on error.
    """
    if not os.path.exists(DATA_FILE):
        print(f"❌ Data file not found: {DATA_FILE}")
        return []
    
    try:
        with open(DATA_FILE, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        admins = data.get("admins", [])
        print(f"📥 Loaded {len(admins)} admin records from file")
        return admins
    except json.JSONDecodeError as e:
        print(f"❌ Invalid JSON in data file: {e}")
        return []
    except Exception as e:
        print(f"❌ Error loading data file: {e}")
        return []


def validate_admin_record(record, index):
    """
    Validates a single admin record.
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
        print(f"⚠️  Record {index} ({record.get('admin_id', 'UNKNOWN')}): Invalid email format")
        return False
    
    return True


# ============================================================================
# IDEMPOTENT INSERTION
# ============================================================================
def check_admin_exists(table, admin_id):
    """
    Checks if an admin record already exists in DynamoDB.
    Returns True if exists, False otherwise.
    """
    try:
        response = table.get_item(Key={'admin_id': admin_id})
        return 'Item' in response
    except ClientError:
        return False


def seed_admins():
    """
    Main function to seed admin data into DynamoDB.
    - Validates table existence (creates if needed)
    - Loads and validates data
    - Inserts records using batch_writer (idempotent)
    - Logs detailed summary
    """
    print("=" * 70)
    print("🚀 StudX Admin Master Data Seeding")
    print("=" * 70)
    print(f"📍 Region: {REGION}")
    print(f"📊 Table: {TABLE_NAME}")
    print()
    
    # Step 1: Ensure table exists
    if not ensure_table_exists():
        print("\n❌ Cannot proceed without a valid table")
        return
    
    print()
    
    # Step 2: Load admin data
    admins = load_admin_data()
    if not admins:
        print("❌ No admin data to insert")
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
    total_records = len(admins)
    valid_records = []
    skipped_records = 0
    
    print("🔍 Validating records...")
    for index, admin in enumerate(admins, start=1):
        if validate_admin_record(admin, index):
            valid_records.append(admin)
        else:
            skipped_records += 1
    
    print(f"✅ Valid records: {len(valid_records)}")
    print(f"⚠️  Skipped (invalid): {skipped_records}")
    print()
    
    if not valid_records:
        print("❌ No valid records to insert")
        return
    
    # Step 5: Insert using batch_writer (idempotent approach)
    print("💾 Inserting admin records...")
    inserted_count = 0
    already_exists_count = 0
    
    with table.batch_writer() as batch:
        for admin in valid_records:
            admin_id = admin['admin_id']
            
            # Check if admin already exists (idempotency)
            if check_admin_exists(table, admin_id):
                print(f"⏭️  Skipped (already exists): {admin_id} - {admin['name']}")
                already_exists_count += 1
                continue
            
            # Insert the admin record
            batch.put_item(Item=admin)
            inserted_count += 1
    
    # Step 6: Summary
    print()
    print("=" * 70)
    print("🎉 Admin Seeding Completed")
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
    seed_admins()

