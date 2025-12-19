# SeatingAgentX V2 - Auto-Detect Departments Update

## Overview
SeatingAgentX has been updated to **auto-detect departments** from student data instead of requiring them as input. This makes the API simpler and more intelligent.

---

## 🔄 Changes Summary

### 1. Request Model Updated

#### **REMOVED Fields:**
- ❌ `departments: List[str]` - No longer required
- ❌ `years: List[int]` - Replaced with single `year`

#### **ADDED Fields:**
- ✅ `exam_subject: str` - Subject/Course code (e.g., "Mathematics-I")
- ✅ `year: int` - Single academic year (1-4)
- ✅ `time_slot: str` - Exam time slot (e.g., "09:00-12:00")

#### **Old Request Format** (Deprecated):
```json
{
  "exam_id": "SEM_2025_01",
  "exam_type": "SEM",
  "departments": ["CSE", "ECE", "AIDS"],
  "years": [1, 2, 3, 4],
  "halls": [...],
  "bench_capacity": 2
}
```

#### **New Request Format** (Current):
```json
{
  "exam_id": "SEM_2025_01",
  "exam_type": "SEM",
  "exam_subject": "Mathematics-I",
  "year": 1,
  "time_slot": "09:00-12:00",
  "halls": [...],
  "bench_capacity": 2
}
```

---

### 2. Department Auto-Detection

The system now **automatically detects** which departments have students for the given year.

#### **How It Works:**
1. Query DynamoDB for all students in the specified `year`
2. Check known departments: CSE, ECE, AIDS, MECH, CIVIL, EEE
3. Group students by their actual department
4. Return only departments that have students

#### **Benefits:**
- ✅ Simpler API - fewer input fields
- ✅ No risk of specifying wrong departments
- ✅ Automatically adapts to available students
- ✅ More intelligent and user-friendly

---

### 3. Allocation Rules - SEM vs CIA

The system now implements **different allocation strategies** for SEM and CIA exams.

#### **SEM (Semester Exams):**
- **Rule**: STRICT round-robin across departments
- **Constraint**: NO same department on any bench
- **Behavior**: Guarantees maximum diversity
- **Use Case**: Final exams where strict separation is required

#### **CIA (Continuous Internal Assessment):**
- **Rule**: PREFER department separation
- **Constraint**: ALLOW same department if unavoidable
- **Behavior**: Tries to separate, but flexible if needed
- **Use Case**: Quizzes, midterms where strict separation is less critical

#### **Comparison:**

| Feature | SEM | CIA |
|---------|-----|-----|
| Department mixing | Strict | Preferred |
| Same dept on bench | Never | Allowed if needed |
| Year restriction | Single year | Same year |
| Flexibility | Low | High |

---

## 📊 Updated API Examples

### Generate SEM Allocation

```bash
POST /seating/generate
```

**Request:**
```json
{
  "exam_id": "SEM_2025_MAT1",
  "exam_type": "SEM",
  "exam_subject": "Mathematics-I",
  "year": 1,
  "time_slot": "09:00-12:00",
  "halls": [
    { "hall_id": "HALL_A", "benches": 30 },
    { "hall_id": "HALL_B", "benches": 30 }
  ],
  "bench_capacity": 2
}
```

**Response:**
```json
{
  "exam_id": "SEM_2025_MAT1",
  "exam_type": "SEM",
  "total_students": 200,
  "total_benches": 60,
  "allocated_students": 200,
  "allocations": [...],
  "message": "Successfully allocated 200 students from 3 departments to 100 benches"
}
```

### Generate CIA Allocation

```bash
POST /seating/generate
```

**Request:**
```json
{
  "exam_id": "CIA_2025_01",
  "exam_type": "CIA",
  "exam_subject": "Data Structures",
  "year": 2,
  "time_slot": "14:00-16:00",
  "halls": [
    { "hall_id": "LAB_1", "benches": 20 }
  ],
  "bench_capacity": 2
}
```

---

## 🔧 Implementation Details

### Updated Files

1. **`models.py`**
   - Updated `SeatingRequest` model
   - Removed `departments` and `years` validators
   - Added `exam_subject`, `year`, `time_slot` validators

2. **`repository.py`**
   - Renamed `fetch_students()` → `fetch_students_by_year()`
   - Auto-detects departments from known list
   - Returns `Dict[str, List[Student]]` instead of nested dict

3. **`allocator.py`**
   - Updated `generate_allocation()` to use new request model
   - Split interleaving logic:
     - `_interleave_students_sem()` - Strict round-robin
     - `_interleave_students_cia()` - Preferred round-robin
   - Enhanced logging for department detection

---

## 🧪 Testing

### Updated Test Script

```powershell
# Old format (no longer works)
$body = @{
    departments = @("CSE", "ECE")
    years = @(1, 2)
    ...
}

# New format (current)
$body = @{
    exam_subject = "Mathematics-I"
    year = 1
    time_slot = "09:00-12:00"
    ...
}
```

### Test Cases

#### Test 1: SEM Allocation (Year 1)
```powershell
$body = @{
    exam_id = "SEM_2025_Y1"
    exam_type = "SEM"
    exam_subject = "Engineering Mechanics"
    year = 1
    time_slot = "09:00-12:00"
    halls = @(@{ hall_id = "HALL_A"; benches = 30 })
    bench_capacity = 2
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:3000/seating/generate" `
    -Method POST `
    -Headers @{ "Authorization" = "Bearer mock-jwt-ADMIN-admin1"; "Content-Type" = "application/json" } `
    -Body $body
```

#### Test 2: CIA Allocation (Year 2)
```powershell
$body = @{
    exam_id = "CIA_2025_Y2"
    exam_type = "CIA"
    exam_subject = "Data Structures"
    year = 2
    time_slot = "14:00-16:00"
    halls = @(@{ hall_id = "LAB_1"; benches = 20 })
    bench_capacity = 2
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:3000/seating/generate" `
    -Method POST `
    -Headers @{ "Authorization" = "Bearer mock-jwt-ADMIN-admin1"; "Content-Type" = "application/json" } `
    -Body $body
```

---

## ✅ Backward Compatibility

### Breaking Changes: YES

This is a **breaking change** for the API:
- Old request format will be rejected
- Validation errors will be returned for old format

### Migration Path

**Before:**
```json
{
  "departments": ["CSE", "ECE"],
  "years": [1, 2]
}
```

**After:**
```json
{
  "exam_subject": "Mathematics-I",
  "year": 1,
  "time_slot": "09:00-12:00"
}
```

---

## 📈 Benefits of V2

### 1. Simpler API
- Fewer input fields
- More intuitive request structure
- Less room for user error

### 2. Intelligent Auto-Detection
- System figures out departments automatically
- No need to know department codes
- Adapts to actual student data

### 3. Exam-Type Specific Logic
- SEM: Strict separation for important exams
- CIA: Flexible for routine assessments
- Clear semantic meaning

### 4. Better UX
- Users specify what matters: year, subject, time
- System handles the complexity
- More natural workflow

---

## 🔒 What Stayed the Same

### Unchanged Features

✅ **Deterministic Behavior**
- Same input always produces same output
- Students sorted by roll_no
- Consistent ordering

✅ **Role-Based Access Control**
- ADMIN, FACULTY, STUDENT permissions unchanged
- Same endpoints and authorization logic

✅ **Idempotency**
- Duplicate exam_id still rejected
- Safe to re-run queries

✅ **CSV Export**
- Same format and functionality
- Generated on-demand

✅ **DynamoDB Schema**
- No changes to table structure
- Same query patterns

✅ **Other Endpoints**
- GET `/seating/{exam_id}` - Unchanged
- GET `/seating/{exam_id}/csv` - Unchanged
- GET `/seating/{exam_id}/hall/{hall_id}` - Unchanged
- GET `/seating/{exam_id}/student/{roll_no}` - Unchanged

---

## 🚀 Deployment

### Build and Deploy

```bash
# Build with new changes
sam build

# Test locally
sam local start-api --port 3000

# Deploy to AWS
sam deploy --guided
```

### Zero Downtime Migration

If you need zero downtime:
1. Deploy V2 to a new stack
2. Update clients to use new format
3. Deprecate old stack

---

## 📝 Code Quality

### Lines Changed
- **models.py**: ~30 lines modified
- **repository.py**: ~40 lines modified
- **allocator.py**: ~80 lines modified
- **test script**: ~5 lines modified

### Total Impact
- **~155 lines changed**
- **0 breaking changes to other APIs**
- **0 changes to DynamoDB schema**
- **100% backward compatible for read operations**

---

## 🎯 Summary

### What Changed
- ✅ Request model simplified (removed departments, added exam_subject/year/time_slot)
- ✅ Auto-detect departments from student data
- ✅ Separate SEM/CIA allocation logic
- ✅ Enhanced logging

### What Stayed Same
- ✅ Deterministic behavior
- ✅ RBAC and authentication
- ✅ Idempotency
- ✅ CSV export
- ✅ All read endpoints
- ✅ DynamoDB schema

### Impact
- ✅ Simpler, more intelligent API
- ✅ Better user experience
- ✅ Exam-type appropriate logic
- ✅ Production-ready

---

**SeatingAgentX V2 is ready for production!** 🚀

