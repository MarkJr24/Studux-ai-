# Test SeatingAgentX with Sample Data
# Run this after populating the database with test students

Write-Host "=" * 70
Write-Host "SeatingAgentX - Complete Test Flow"
Write-Host "=" * 70

# Configuration
$BASE_URL = "https://your-api-id.execute-api.ap-south-2.amazonaws.com/Prod"
# Or for local testing: $BASE_URL = "http://localhost:3000"

Write-Host "`nStep 1: Populate Test Data"
Write-Host "-" * 70
Write-Host "Run: python populate_test_data.py"
Write-Host "This will add 16 test students to the database"
Write-Host ""
Read-Host "Press Enter after running the populate script"

Write-Host "`nStep 2: Test Seating Allocation"
Write-Host "-" * 70

# Create request body
$body = @{
    exam_id        = "SEM_VERIFY_001"
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

Write-Host "Request Payload:"
Write-Host $body
Write-Host ""

try {
    Write-Host "Sending POST request to $BASE_URL/seating/generate..."
    Write-Host "(No Authorization header - auth is disabled!)"
    Write-Host ""
    
    $response = Invoke-RestMethod `
        -Uri "$BASE_URL/seating/generate" `
        -Method POST `
        -Body $body `
        -ContentType "application/json"
    
    Write-Host "✅ SUCCESS!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Response:"
    Write-Host "  Exam ID: $($response.exam_id)"
    Write-Host "  Exam Type: $($response.exam_type)"
    Write-Host "  Time Slot: $($response.time_slot)"
    Write-Host "  Total Students: $($response.total_students)"
    Write-Host "  Allocated Students: $($response.allocated_students)"
    Write-Host "  Total Benches: $($response.total_benches)"
    Write-Host "  Message: $($response.message)"
    Write-Host ""
    
    # Show first few allocations
    Write-Host "Sample Allocations:"
    $response.allocations | Select-Object -First 3 | ForEach-Object {
        $left = if ($_.left_student) { "$($_.left_student.roll_no) ($($_.left_student.department))" } else { "Empty" }
        $right = if ($_.right_student) { "$($_.right_student.roll_no) ($($_.right_student.department))" } else { "Empty" }
        Write-Host "  Bench $($_.bench_no): $left | $right"
    }
    
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $errorBody = $_.ErrorDetails.Message
    
    Write-Host "❌ Request Failed" -ForegroundColor Red
    Write-Host "Status Code: $statusCode"
    Write-Host "Error: $errorBody"
    Write-Host ""
    
    if ($errorBody -like "*No students found*") {
        Write-Host "⚠️  This means the database is empty or doesn't have students for the criteria." -ForegroundColor Yellow
        Write-Host "   Run: python populate_test_data.py" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=" * 70
Write-Host "Step 3: Verify in DynamoDB"
Write-Host "-" * 70
Write-Host "Check the StudX_SeatingAllocations table in AWS Console"
Write-Host "You should see new items with exam_id = SEM_VERIFY_001"
Write-Host ""

Write-Host "=" * 70
Write-Host "Test Complete!"
Write-Host "=" * 70
