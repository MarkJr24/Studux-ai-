# Student Master Data Seeding

Production-ready seeding system for StudX student master data.

## 📁 Structure

```
scripts/
├── data/
│   ├── ece_students.json    # 200 ECE students (50 per year)
│   ├── aids_students.json   # 200 AIDS students (50 per year)
│   └── cse_students.json    # 200 CSE students (50 per year)
├── seed_students.py         # Main seeding script
├── validate_data.py         # Data validation script
└── test_transformation.py   # Transformation test script
```

## 🎯 Data Format

### Input JSON Structure

Each department JSON file follows this structure:

```json
{
  "department": "ECE | AIDS | CSE",
  "years": {
    "1": [
      {
        "roll": "23ECE001",
        "name": "Aarav Sharma",
        "email": "aarav.sharma@studentms.com"
      }
    ],
    "2": [...],
    "3": [...],
    "4": [...]
  }
}
```

### DynamoDB Item Format

Transformation produces:

```python
{
    "pk": "STUDENT",
    "sk": "CSE#1#23CSE001",
    "roll_no": "23CSE001",
    "name": "Nitya Singh",
    "email": "nitya.singh@studentms.com",
    "department": "CSE",
    "year": 1,
    "role": "STUDENT"
}
```

**Key Design:**
- `pk` = `"STUDENT"` (partition key)
- `sk` = `"<DEPT>#<YEAR>#<ROLL_NO>"` (sort key)

## 🚀 Usage

### Prerequisites

1. AWS credentials configured
2. DynamoDB table `StudX_StudentMaster` exists in `ap-south-2`
3. Table created via SAM deployment

### Validate Data (Optional)

```bash
cd D:\studx-backend\backend
python scripts/validate_data.py
```

**Expected Output:**
```
==================================================
Student Data Validation
==================================================

ECE:
  Years: 1, 2, 3, 4
  Total students: 200
  Sample: Aarav Sharma (23ECE001)

AIDS:
  Years: 1, 2, 3, 4
  Total students: 200
  Sample: Prisha Bose (23AIDS001)

CSE:
  Years: 1, 2, 3, 4
  Total students: 200
  Sample: Nitya Singh (23CSE001)

==================================================
TOTAL STUDENTS: 600
==================================================
```

### Test Transformation (Optional)

```bash
python scripts/test_transformation.py
```

Shows how tabular data is transformed to DynamoDB items.

### Run Seeding

```bash
python scripts/seed_students.py
```

**Expected Output:**
```
🚀 Starting Student Master Seeding

📥 Seeding department: ECE
✅ Inserted 200 students for ECE

📥 Seeding department: AIDS
✅ Inserted 200 students for AIDS

📥 Seeding department: CSE
✅ Inserted 200 students for CSE

🎉 All student data seeded successfully
📊 Total records inserted: 600
```

## ✅ Features

- **Idempotent**: Safe to re-run (uses `put_item` semantics)
- **Batch Operations**: Uses `batch_writer` for efficiency
- **Error Handling**: Fails fast with clear error messages
- **Scalable**: Handles 1000+ records without issues
- **Production-Ready**: Clean logging, type hints, docstrings

## 🔍 Verification

After seeding, verify in AWS:

```bash
# Check item count
aws dynamodb describe-table \
  --table-name StudX_StudentMaster \
  --region ap-south-2 \
  --query 'Table.ItemCount'

# Sample query: Get all Year 1 CSE students
aws dynamodb query \
  --table-name StudX_StudentMaster \
  --region ap-south-2 \
  --key-condition-expression "pk = :pk AND begins_with(sk, :sk_prefix)" \
  --expression-attribute-values '{":pk":{"S":"STUDENT"},":sk_prefix":{"S":"CSE#1#"}}'
```

## 📊 Data Summary

| Department | Years | Students/Year | Total |
|------------|-------|---------------|-------|
| ECE        | 1-4   | 50            | 200   |
| AIDS       | 1-4   | 50            | 200   |
| CSE        | 1-4   | 50            | 200   |
| **TOTAL**  |       |               | **600** |

## 🛠️ Adding More Departments

1. Create `backend/scripts/data/<dept>_students.json`
2. Follow existing JSON structure
3. Add department code to `DEPARTMENTS` list in `seed_students.py`
4. Run seeding script

## 🔒 Security

- No hardcoded AWS credentials
- Uses boto3 default credential chain
- Region explicitly set to `ap-south-2`
- No sensitive data in JSON files

## 📝 Notes

- Script validates table existence before insertion
- Uses `batch_writer` context manager for automatic batching
- Processes all departments sequentially
- Logs progress for each department
- No silent error swallowing

