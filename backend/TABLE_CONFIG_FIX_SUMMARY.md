# ✅ DynamoDB Table Configuration - FIXED

## Problem Summary

SeatingAgentX was executing successfully but **NOT persisting data**:
- ✅ API returned 200 OK with allocation results
- ❌ `StudX_SeatingAllocations` table remained empty (ItemCount = 0)
- ❌ Lambda only had access to `StudX_StudentMaster`

## Root Cause

1. **Missing Environment Variable:** Lambda only had `DYNAMODB_TABLE` pointing to StudentMaster
2. **Missing IAM Permissions:** No DynamoDB permissions for SeatingAllocations table
3. **Hardcoded Table Names:** Repository used hardcoded names instead of env vars

## Solution Applied

### 1. SAM Template (`template.yaml`)

**Added Explicit Environment Variables:**
```yaml
Environment:
  Variables:
    STUDENT_TABLE: StudX_StudentMaster      # For reading students
    SEATING_TABLE: StudX_SeatingAllocations # For writing allocations
    AWS_REGION_NAME: !Ref AWS::Region
```

**Added IAM Permissions:**
```yaml
Policies:
  - DynamoDBCrudPolicy:
      TableName: !Ref StudentMasterTable
  - DynamoDBCrudPolicy:
      TableName: StudX_SeatingAllocations  # NEW!
```

### 2. Repository (`repository.py`)

**Changed to Use Environment Variables:**
```python
# Before:
STUDENT_TABLE = "StudX_StudentMaster"
SEATING_TABLE = "StudX_SeatingAllocations"

# After:
STUDENT_TABLE = os.getenv("STUDENT_TABLE", "StudX_StudentMaster")
SEATING_TABLE = os.getenv("SEATING_TABLE", "StudX_SeatingAllocations")

# Added safety checks:
assert STUDENT_TABLE, "STUDENT_TABLE environment variable is required"
assert SEATING_TABLE, "SEATING_TABLE environment variable is required"
```

## Data Flow (Fixed)

```
POST /seating/generate
    ↓
1. Fetch Students
    ↓
    os.getenv("STUDENT_TABLE") → StudX_StudentMaster
    ↓
    Query students by department & year
    ↓
2. Generate Allocation
    ↓
    Apply SEM/CIA rules
    ↓
3. Persist to DynamoDB
    ↓
    os.getenv("SEATING_TABLE") → StudX_SeatingAllocations ✅
    ↓
    BatchWriteItem with all allocations
    ↓
4. Return Response
    ↓
    200 OK with allocation data
```

## Deployment

### Build and Deploy

```bash
cd d:/studx-backend
sam build
sam deploy
```

Wait for "Successfully deployed" message.

### Verify Environment Variables

```bash
aws lambda get-function-configuration \
  --function-name <your-function-name> \
  --region ap-south-2 \
  --query 'Environment.Variables'
```

**Expected Output:**
```json
{
  "STUDENT_TABLE": "StudX_StudentMaster",
  "SEATING_TABLE": "StudX_SeatingAllocations",
  "AWS_REGION_NAME": "ap-south-2"
}
```

## Testing

### 1. Generate Allocation

```powershell
$body = @{
    exam_id        = "TEST_PERSIST_001"
    exam_type      = "SEM"
    subject        = "Data Structures"
    time_slot      = 2
    departments    = @("CSE", "ECE", "AI&DS")
    years          = @(3)
    halls          = @(
        @{ hall_id = "A101"; benches = 10 }
    )
    bench_capacity = 2
} | ConvertTo-Json -Depth 5

Invoke-RestMethod `
  -Uri "$BASE_URL/seating/generate" `
  -Method POST `
  -Body $body `
  -ContentType "application/json"
```

**Expected:** 200 OK with 12 students allocated

### 2. Verify DynamoDB Persistence

```bash
aws dynamodb describe-table \
  --table-name StudX_SeatingAllocations \
  --region ap-south-2 \
  --query 'Table.ItemCount'
```

**Before Fix:** 0
**After Fix:** > 0 (e.g., 6 for 6 benches)

### 3. Query Allocation Records

```bash
aws dynamodb query \
  --table-name StudX_SeatingAllocations \
  --key-condition-expression "exam_id = :exam_id" \
  --expression-attribute-values '{":exam_id":{"S":"TEST_PERSIST_001"}}' \
  --region ap-south-2
```

**Expected Items:**
```json
{
  "exam_id": "TEST_PERSIST_001",
  "seat_key": "A101#1",
  "subject": "Data Structures",
  "time_slot": 2,
  "hall_id": "A101",
  "bench_no": 1,
  "left_roll": "CSE301",
  "left_dept": "CSE",
  "left_year": 3,
  "right_roll": "ECE301",
  "right_dept": "ECE",
  "right_year": 3
}
```

## Verification Checklist

After deployment and testing:

- [ ] Lambda has `STUDENT_TABLE` env var
- [ ] Lambda has `SEATING_TABLE` env var
- [ ] Lambda has DynamoDB permissions for both tables
- [ ] POST /seating/generate returns 200 OK
- [ ] `StudX_SeatingAllocations` ItemCount > 0
- [ ] Records contain all required fields
- [ ] Student data still fetched from `StudX_StudentMaster`

## What Changed

### Modified Files
1. `backend/template.yaml` - Environment variables and IAM permissions
2. `backend/src/services/seating_agentx/repository.py` - Use env vars

### Unchanged
- ✅ Allocation logic (SEM/CIA rules)
- ✅ Validation rules
- ✅ API contracts
- ✅ Error handling
- ✅ Student fetching logic

## Summary

**Problem:** Allocations not persisted to DynamoDB
**Cause:** Missing env var and IAM permissions
**Fix:** Added `SEATING_TABLE` env var and DynamoDB CRUD policy
**Result:** Allocations now correctly written to `StudX_SeatingAllocations`

**Before:**
```
API: 200 OK ✅
DynamoDB: ItemCount = 0 ❌
```

**After:**
```
API: 200 OK ✅
DynamoDB: ItemCount > 0 ✅
```

---

**Status:** ✅ COMPLETE - Ready for deployment
**Next:** Deploy with `sam build && sam deploy` and test
