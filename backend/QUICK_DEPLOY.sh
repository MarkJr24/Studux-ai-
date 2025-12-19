#!/bin/bash
# Quick deployment script after permissions are fixed

echo "==================================="
echo "StudX Backend - Quick Deployment"
echo "==================================="
echo ""

# Step 1: Clean up any previous failed attempts
echo "Step 1: Cleaning up..."
aws cloudformation delete-stack --stack-name aws-sam-cli-managed-default --region ap-south-2 2>/dev/null
sleep 5

# Step 2: Build
echo ""
echo "Step 2: Building SAM application..."
sam build

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

# Step 3: Deploy
echo ""
echo "Step 3: Deploying to AWS..."
sam deploy --no-confirm-changeset --region ap-south-2

if [ $? -ne 0 ]; then
    echo "❌ Deployment failed!"
    exit 1
fi

# Step 4: Verify
echo ""
echo "Step 4: Verifying deployment..."
aws dynamodb describe-table --table-name StudX_StudentMaster --region ap-south-2 --query 'Table.[TableName,TableStatus]' --output text

echo ""
echo "✅ Deployment complete!"
echo ""
echo "Next step: python scripts/seed_students.py"

