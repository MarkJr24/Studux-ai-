# Deployment Guide - DynamoDB Table Configuration Fix

## Quick Deployment

```bash
cd d:/studx-backend
sam build
sam deploy
```

## Post-Deployment Verification

### Step 1: Check Lambda Environment Variables

```bash
# Get your function name from the stack
aws cloudformation describe-stacks \
  --stack-name studx-backend \
  --region ap-south-2 \
  --query 'Stacks[0].Outputs[?OutputKey==`ApiUrl`].OutputValue' \
  --output text

# Check environment variables
aws lambda get-function-configuration \
  --function-name <your-function-name> \
  --region ap-south-2 \
  --query 'Environment.Variables'
```

**Expected:**
```json
{
  "STUDENT_TABLE": "StudX_StudentMaster",
  "SEATING_TABLE": "StudX_SeatingAllocations",
  "AWS_REGION_NAME": "ap-south-2"
}
```

### Step 2: Test Allocation

```powershell
# Set your API URL
$BASE_URL = "https://<your-api-id>.execute-api.ap-south-2.amazonaws.com/Prod"

# Create test payload
$body = @{
    exam_id        = "DEPLOY_TEST_001"
    exam_type      = "SEM"
    subject        = "Deployment Test"
    time_slot      = 1
    departments    = @("CSE", "ECE")
    years          = @(3)
    halls          = @(
        @{ hall_id = "TEST_HALL"; benches = 5 }
    )
    bench_capacity = 2
} | ConvertTo-Json -Depth 5

# Send request
Invoke-RestMethod `
  -Uri "$BASE_URL/seating/generate" `
  -Method POST `
  -Body $body `
  -ContentType "application/json"
```

**Expected Response:**
```json
{
  "exam_id": "DEPLOY_TEST_001",
  "exam_type": "SEM",
  "time_slot": 1,
  "total_students": <number>,
  "allocated_students": <number>,
  "total_benches": 5,
  "allocations": [...],
  "message": "Successfully allocated..."
}
```

### Step 3: Verify DynamoDB Persistence

```bash
# Check item count
aws dynamodb describe-table \
  --table-name StudX_SeatingAllocations \
  --region ap-south-2 \
  --query 'Table.ItemCount'
```

**Expected:** Number > 0

```bash
# Query the records
aws dynamodb query \
  --table-name StudX_SeatingAllocations \
  --key-condition-expression "exam_id = :exam_id" \
  --expression-attribute-values '{":exam_id":{"S":"DEPLOY_TEST_001"}}' \
  --region ap-south-2 \
  --max-items 1
```

**Expected:** Items with exam_id, seat_key, subject, time_slot, hall_id, bench_no, student data

## Troubleshooting

### Issue: ItemCount still 0

**Check Lambda logs:**
```bash
aws logs tail /aws/lambda/<function-name> --follow --region ap-south-2
```

Look for errors like:
- "AccessDeniedException" → IAM permissions issue
- "ResourceNotFoundException" → Table doesn't exist
- "SEATING_TABLE environment variable is required" → Env var not set

**Fix:**
1. Verify SAM template has both env vars
2. Redeploy: `sam build && sam deploy`
3. Check IAM role has DynamoDB permissions

### Issue: AccessDeniedException

**Check IAM policies:**
```bash
# Get role name
aws lambda get-function \
  --function-name <function-name> \
  --region ap-south-2 \
  --query 'Configuration.Role'

# List attached policies
aws iam list-attached-role-policies \
  --role-name <role-name>
```

**Expected policies:**
- AWSLambdaBasicExecutionRole
- DynamoDB permissions for both tables

**Fix:**
Ensure SAM template has both DynamoDBCrudPolicy entries.

### Issue: Table doesn't exist

**Create table manually:**
```bash
aws dynamodb create-table \
  --table-name StudX_SeatingAllocations \
  --attribute-definitions \
    AttributeName=exam_id,AttributeType=S \
    AttributeName=seat_key,AttributeType=S \
  --key-schema \
    AttributeName=exam_id,KeyType=HASH \
    AttributeName=seat_key,KeyType=RANGE \
  --billing-mode PAY_PER_REQUEST \
  --region ap-south-2
```

## Success Criteria

✅ Lambda has correct environment variables
✅ Lambda has DynamoDB permissions for both tables
✅ POST /seating/generate returns 200 OK
✅ StudX_SeatingAllocations ItemCount > 0
✅ Records contain all required fields

## Rollback (if needed)

If something goes wrong:

```bash
# Rollback to previous version
aws cloudformation rollback-stack \
  --stack-name studx-backend \
  --region ap-south-2
```

Or redeploy the previous version from git.

## Next Steps

After successful deployment:

1. **Test all endpoints:**
   - POST /seating/generate
   - GET /seating/{exam_id}
   - GET /seating/{exam_id}/csv
   - GET /seating/{exam_id}/hall/{hall_id}
   - GET /seating/{exam_id}/student/{roll_no}

2. **Monitor CloudWatch logs:**
   ```bash
   aws logs tail /aws/lambda/<function-name> --follow
   ```

3. **Check DynamoDB metrics:**
   - Go to AWS Console → DynamoDB → StudX_SeatingAllocations
   - Check "Metrics" tab for read/write activity

4. **Re-enable authentication** (if needed for production):
   - Add back `dependencies=[Depends(verify_admin_role)]` to routes
   - Redeploy

---

**Ready to deploy!** Run `sam build && sam deploy` and follow the verification steps above.
