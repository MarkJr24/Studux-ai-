# PowerShell script for deployment with existing S3 bucket
# Usage: .\deploy_with_bucket.ps1 -BucketName your-bucket-name

param(
    [Parameter(Mandatory=$true)]
    [string]$BucketName
)

Write-Host "==================================="
Write-Host "StudX Backend - Deployment"
Write-Host "Using S3 Bucket: $BucketName"
Write-Host "==================================="
Write-Host ""

# Step 1: Verify bucket exists
Write-Host "Step 1: Verifying S3 bucket..."
$bucketExists = aws s3 ls s3://$BucketName --region ap-south-2 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Bucket $BucketName not found or not accessible!"
    Write-Host "Please create the bucket first or use a different bucket name."
    exit 1
}
Write-Host "✅ Bucket found"

# Step 2: Build
Write-Host ""
Write-Host "Step 2: Building SAM application..."
sam build
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed!"
    exit 1
}

# Step 3: Deploy with specific S3 bucket
Write-Host ""
Write-Host "Step 3: Deploying to AWS..."
sam deploy `
    --stack-name studx-backend `
    --region ap-south-2 `
    --capabilities CAPABILITY_IAM `
    --s3-bucket $BucketName `
    --s3-prefix studx-backend `
    --no-confirm-changeset

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Deployment failed!"
    exit 1
}

# Step 4: Verify
Write-Host ""
Write-Host "Step 4: Verifying deployment..."
aws cloudformation describe-stacks --stack-name studx-backend --region ap-south-2 --query 'Stacks[0].StackStatus' --output text
aws dynamodb describe-table --table-name StudX_StudentMaster --region ap-south-2 --query 'Table.[TableName,TableStatus]' --output text

Write-Host ""
Write-Host "✅ Deployment complete!"
Write-Host ""
Write-Host "Next step: python scripts/seed_students.py"

