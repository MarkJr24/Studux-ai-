# Admin Master Data Seeding - StudX Backend

## Overview
This script populates the `StudX_AdminMaster` DynamoDB table with admin data for the StudX ERP system.

## Files
```
backend/scripts/
├── seed_admins.py              # Main seeding script
└── data/
    └── admin_master.json       # Admin data source
```

## DynamoDB Table Details
- **Table Name:** `StudX_AdminMaster`
- **Region:** `ap-south-2` (Hyderabad)
- **Primary Key:** `admin_id` (String)
- **Billing Mode:** PAY_PER_REQUEST (AWS Free Tier friendly)

## Admin Data Structure
Each admin record contains:
- `admin_id` (required) - Unique identifier (e.g., ADM001)
- `name` (required) - Full name with title
- `email` (required) - Official email address
- `designation` (required) - Position/Role (e.g., Principal, Dean, HOD)
- `department` (optional) - Department/Section
- `phone` (optional) - Contact number

## Prerequisites
```bash
# Install boto3 if not already installed
pip install boto3

# Ensure AWS credentials are configured
aws configure
```

## Usage

### Run the seeding script:
```bash
# From backend directory
python scripts/seed_admins.py
```

### Expected Output:
```
======================================================================
🚀 StudX Admin Master Data Seeding
======================================================================
📍 Region: ap-south-2
📊 Table: StudX_AdminMaster

✅ Table 'StudX_AdminMaster' already exists

📥 Loaded 10 admin records from file

🔍 Validating records...
✅ Valid records: 10
⚠️  Skipped (invalid): 0

💾 Inserting admin records...

======================================================================
🎉 Admin Seeding Completed
======================================================================
📊 Total records processed: 10
✅ Successfully inserted: 10
⏭️  Already existed (skipped): 0
⚠️  Invalid (skipped): 0
======================================================================
```

## Key Features

### 1. **Automatic Table Creation**
- Script checks if table exists
- Creates table if missing
- Uses correct schema (admin_id as primary key)

### 2. **Idempotency**
- Safe to re-run multiple times
- Skips records that already exist
- Does NOT overwrite existing data

### 3. **Data Validation**
- Validates required fields
- Checks email format
- Logs invalid records (does not crash)

### 4. **Batch Operations**
- Uses DynamoDB `batch_writer` for efficiency
- Handles batch size limits automatically
- Free Tier friendly

## Verification Commands

### Check table exists:
```bash
aws dynamodb describe-table --table-name StudX_AdminMaster --region ap-south-2
```

### Count total admin records:
```bash
aws dynamodb scan --table-name StudX_AdminMaster --region ap-south-2 --select COUNT
```

### Get a specific admin record:
```bash
aws dynamodb get-item --table-name StudX_AdminMaster --region ap-south-2 --key '{"admin_id":{"S":"ADM001"}}'
```

### List all admins (simple query):
```bash
aws dynamodb scan --table-name StudX_AdminMaster --region ap-south-2 --output table
```

## Current Data
- **Total Admins:** 10
- **Roles:**
  - Principal: 1
  - Vice Principal: 1
  - Deans: 2
  - HODs: 3 (CSE, ECE, AIDS)
  - Registrar: 1
  - Controller of Examinations: 1
  - Director - Admissions: 1

## Admin Hierarchy
1. **ADM001** - Principal
2. **ADM002** - Vice Principal
3. **ADM003** - Dean - Academics
4. **ADM004** - Dean - Student Affairs
5. **ADM005** - HOD - CSE
6. **ADM006** - HOD - ECE
7. **ADM007** - HOD - AIDS
8. **ADM008** - Registrar
9. **ADM009** - Controller of Examinations
10. **ADM010** - Director - Admissions

## Adding More Admins

### Option 1: Edit JSON file
1. Open `data/admin_master.json`
2. Add new admin records to the `admins` array
3. Ensure all required fields are present
4. Run `python scripts/seed_admins.py`

### Option 2: Manual insertion (testing)
```python
import boto3
dynamodb = boto3.resource('dynamodb', region_name='ap-south-2')
table = dynamodb.Table('StudX_AdminMaster')

table.put_item(Item={
    'admin_id': 'ADM011',
    'name': 'Dr. New Admin',
    'email': 'new.admin@admin.studx.com',
    'designation': 'Deputy Dean',
    'department': 'Administration',
    'phone': '+91-9876543220'
})
```

## Troubleshooting

### Error: "ModuleNotFoundError: No module named 'boto3'"
```bash
pip install boto3
```

### Error: "Unable to locate credentials"
```bash
aws configure
# Enter your AWS Access Key ID, Secret Access Key, and region (ap-south-2)
```

### Error: "Table already exists" (during creation)
- This is expected if table was created previously
- Script will continue normally

### Records not inserting
- Check AWS credentials have DynamoDB permissions
- Verify region is set to `ap-south-2`
- Check JSON file format is valid

## Important Notes
- ✅ Script is **idempotent** (safe to re-run)
- ✅ Uses **PAY_PER_REQUEST** billing (Free Tier friendly)
- ✅ No API endpoints exposed (standalone utility)
- ✅ Validates data before insertion
- ⚠️  Does NOT modify existing API routes
- ⚠️  Does NOT affect student or faculty data
- ⚠️  Does NOT alter authentication/authorization code

