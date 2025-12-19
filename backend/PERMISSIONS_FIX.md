# 🔴 IAM Permissions Fix Required

## Problem
Your IAM user `studx-dev` lacks S3 permissions required for SAM deployment.

## Error Details
```
User: arn:aws:iam::396082224376:user/studx-dev is not authorized to perform: s3:CreateBucket
```

---

## ✅ Solution 1: Add S3 Permissions (Recommended)

### Option A: Attach AWS Managed Policy
Ask your AWS administrator to attach this managed policy to `studx-dev`:
```
AmazonS3FullAccess
```

### Option B: Create Custom Policy (More Secure)
Ask your AWS administrator to create and attach this custom policy:

**Policy Name:** `SAM-Deployment-S3-Access`

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:CreateBucket",
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:PutBucketVersioning",
        "s3:PutBucketPolicy",
        "s3:GetBucketPolicy"
      ],
      "Resource": [
        "arn:aws:s3:::aws-sam-cli-managed-default-*",
        "arn:aws:s3:::aws-sam-cli-managed-default-*/*"
      ]
    }
  ]
}
```

### After Permissions Are Added:
```powershell
cd D:\studx-backend\backend
.\deploy.ps1
```

---

## ✅ Solution 2: Use Existing S3 Bucket

If you already have an S3 bucket in `ap-south-2` region:

### Step 1: Check if you have a bucket
```powershell
aws s3 ls --region ap-south-2
```

### Step 2: Deploy using that bucket
```powershell
cd D:\studx-backend\backend
.\deploy_with_bucket.ps1 -BucketName your-bucket-name
```

**Example:**
```powershell
.\deploy_with_bucket.ps1 -BucketName studx-deployment-bucket
```

---

## ✅ Solution 3: Manual Bucket Creation

If you have `s3:CreateBucket` permission but deployment fails:

### Step 1: Create bucket manually
```powershell
aws s3 mb s3://studx-sam-deployment-$(date +%s) --region ap-south-2
```

### Step 2: Note the bucket name and deploy
```powershell
.\deploy_with_bucket.ps1 -BucketName studx-sam-deployment-XXXXXXXXX
```

---

## Required Permissions Summary

For full SAM deployment, `studx-dev` needs:

1. **S3 Permissions** (bucket creation & object management)
2. **CloudFormation Permissions** (stack create/update)
3. **Lambda Permissions** (function create/update)
4. **IAM Permissions** (role creation for Lambda)
5. **DynamoDB Permissions** (table creation)
6. **API Gateway Permissions** (API creation)

### Quick Check: Test Permissions
```powershell
# Test S3
aws s3 ls --region ap-south-2

# Test CloudFormation
aws cloudformation list-stacks --region ap-south-2

# Test Lambda
aws lambda list-functions --region ap-south-2

# Test DynamoDB
aws dynamodb list-tables --region ap-south-2
```

---

## Contact Your AWS Administrator

Send this message:

> **Subject:** Request S3 Permissions for SAM Deployment
> 
> Hi,
> 
> I need S3 permissions added to my IAM user `studx-dev` (Account: 396082224376) to deploy AWS SAM applications.
> 
> Could you please attach the `AmazonS3FullAccess` managed policy or the custom policy provided in the attached `PERMISSIONS_FIX.md` file?
> 
> This is required for SAM to create/manage deployment artifact buckets in the `ap-south-2` region.
> 
> Thank you!

---

## After Permissions Are Fixed

Run the automated deployment:
```powershell
cd D:\studx-backend\backend
.\deploy.ps1
```

Expected output:
```
✅ Deployment complete!
Stack Status: CREATE_COMPLETE
Table Status: StudX_StudentMaster ACTIVE
```

Then seed the data:
```powershell
python scripts/seed_students.py
```

---

## Still Having Issues?

Check these common problems:

1. **Region mismatch**: Ensure all commands use `--region ap-south-2`
2. **Stale credentials**: Run `aws configure` and re-enter credentials
3. **Failed stack still exists**: Delete it with:
   ```powershell
   aws cloudformation delete-stack --stack-name aws-sam-cli-managed-default --region ap-south-2
   ```
4. **Multiple AWS profiles**: Ensure correct profile is active:
   ```powershell
   $env:AWS_PROFILE="default"
   ```

