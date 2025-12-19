# PowerShell script for SAM deployment
# Run this after S3 permissions are added

Write-Host "==================================="
Write-Host "StudX Backend - Quick Deployment"
Write-Host "==================================="
Write-Host ""

# Step 1: Clean up any previous failed attempts
Write-Host "Step 1: Cleaning up previous failed stacks..."
aws cloudformation delete-stack --stack-name aws-sam-cli-managed-default --region ap-south-2 2>$null
Start-Sleep -Seconds 5

# Step 2: Build
Write-Host ""
Write-Host "Step 2: Building SAM application..."
sam build

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed!"
    exit 1
}

# Step 3: Deploy (SAM will create S3 bucket automatically)
Write-Host ""
Write-Host "Step 3: Deploying to AWS (this will create S3 bucket)..."
sam deploy --no-confirm-changeset --region ap-south-2

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Deployment failed!"
    Write-Host ""
    Write-Host "If you see S3 permission errors:"
    Write-Host "1. Ask admin to add S3 permissions (see DEPLOYMENT_GUIDE.md)"
    Write-Host "2. Or use: .\deploy_with_bucket.ps1 -BucketName your-existing-bucket"
    exit 1
}

# Step 4: Verify
Write-Host ""
Write-Host "Step 4: Verifying deployment..."
$stackStatus = aws cloudformation describe-stacks --stack-name studx-backend --region ap-south-2 --query 'Stacks[0].StackStatus' --output text
$tableInfo = aws dynamodb describe-table --table-name StudX_StudentMaster --region ap-south-2 --query 'Table.[TableName,TableStatus]' --output text

Write-Host "Stack Status: $stackStatus"
Write-Host "Table Status: $tableInfo"

Write-Host ""
Write-Host "✅ Deployment complete!"
Write-Host ""
Write-Host "Next step: python scripts/seed_students.py"

