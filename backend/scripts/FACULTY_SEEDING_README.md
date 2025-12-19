# Faculty Master Data Seeding - StudX Backend

## Overview
This script populates the `StudX_FacultyMaster` DynamoDB table with faculty data for the StudX ERP system.

## Files
```
backend/scripts/
├── seed_faculties.py           # Main seeding script
└── data/
    └── faculty_master.json     # Faculty data source
```

## DynamoDB Table Details
- **Table Name:** `StudX_FacultyMaster`
- **Region:** `ap-south-2` (Hyderabad)
- **Primary Key:** `faculty_id` (String)
- **Billing Mode:** PAY_PER_REQUEST (AWS Free Tier friendly)

## Faculty Data Structure
Each faculty record contains:
- `faculty_id` (required) - Unique identifier (e.g., FAC001)
- `name` (required) - Full name with designation
- `email` (required) - Official email address
- `department` (required) - CSE, ECE, or AIDS
- `designation` (optional) - Professor, Associate Professor, etc.
- `specialization` (optional) - Area of expertise

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
python scripts/seed_faculties.py
```

### Expected Output:
```
======================================================================
🚀 StudX Faculty Master Data Seeding
======================================================================
📍 Region: ap-south-2
📊 Table: StudX_FacultyMaster

✅ Table 'StudX_FacultyMaster' already exists

📥 Loaded 15 faculty records from file

🔍 Validating records...
✅ Valid records: 15
⚠️  Skipped (invalid): 0

💾 Inserting faculty records...

======================================================================
🎉 Faculty Seeding Completed
======================================================================
📊 Total records processed: 15
✅ Successfully inserted: 15
⏭️  Already existed (skipped): 0
⚠️  Invalid (skipped): 0
======================================================================
```

## Key Features

### 1. **Automatic Table Creation**
- Script checks if table exists
- Creates table if missing
- Uses correct schema (faculty_id as primary key)

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
aws dynamodb describe-table --table-name StudX_FacultyMaster --region ap-south-2
```

### Count total faculty records:
```bash
aws dynamodb scan --table-name StudX_FacultyMaster --region ap-south-2 --select COUNT
```

### Get a specific faculty record:
```bash
aws dynamodb get-item --table-name StudX_FacultyMaster --region ap-south-2 --key '{"faculty_id":{"S":"FAC001"}}'
```

### List all faculties (simple query):
```bash
aws dynamodb scan --table-name StudX_FacultyMaster --region ap-south-2 --output table
```

## Current Data
- **Total Faculty:** 15
- **Departments:**
  - CSE: 5 faculty
  - ECE: 5 faculty
  - AIDS: 5 faculty

## Adding More Faculty

### Option 1: Edit JSON file
1. Open `data/faculty_master.json`
2. Add new faculty records to the `faculties` array
3. Ensure all required fields are present
4. Run `python scripts/seed_faculties.py`

### Option 2: Manual insertion (testing)
```python
import boto3
dynamodb = boto3.resource('dynamodb', region_name='ap-south-2')
table = dynamodb.Table('StudX_FacultyMaster')

table.put_item(Item={
    'faculty_id': 'FAC016',
    'name': 'Dr. New Faculty',
    'email': 'new.faculty@faculty.com',
    'department': 'CSE',
    'designation': 'Assistant Professor',
    'specialization': 'Blockchain'
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
- ⚠️  Does NOT affect student data or tables

