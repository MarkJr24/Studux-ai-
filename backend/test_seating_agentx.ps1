# SeatingAgentX Test Script
# Tests all seating allocation endpoints with role-based access control

$BASE_URL = "http://127.0.0.1:3000"

# Test tokens (mock JWT format)
$ADMIN_TOKEN = "Bearer mock-jwt-ADMIN-admin1"
$TEACHER_TOKEN = "Bearer mock-jwt-TEACHER-teacher1"
$STUDENT_TOKEN = "Bearer mock-jwt-STUDENT-student1"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SeatingAgentX E2E Test Suite" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Generate Seating Allocation (ADMIN ONLY)
Write-Host "Test 1: Generate Seating Allocation (ADMIN)" -ForegroundColor Yellow
Write-Host "--------------------------------------"

$seatingRequest = @{
    exam_id = "SEM_2025_01"
    exam_type = "SEM"
    exam_subject = "Mathematics-I"
    year = 1
    time_slot = "09:00-12:00"
    halls = @(
        @{ hall_id = "HALL_A"; benches = 30 },
        @{ hall_id = "HALL_B"; benches = 30 }
    )
    bench_capacity = 2
} | ConvertTo-Json -Depth 10

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/seating/generate" `
        -Method POST `
        -Headers @{ "Authorization" = $ADMIN_TOKEN; "Content-Type" = "application/json" } `
        -Body $seatingRequest
    
    Write-Host "✅ SUCCESS: Seating allocation generated" -ForegroundColor Green
    Write-Host "Total Students: $($response.total_students)" -ForegroundColor Green
    Write-Host "Total Benches: $($response.total_benches)" -ForegroundColor Green
    Write-Host "Allocated Students: $($response.allocated_students)" -ForegroundColor Green
    Write-Host "Message: $($response.message)" -ForegroundColor Green
} catch {
    Write-Host "❌ ERROR: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 2: Retrieve Seating Allocation (ADMIN)
Write-Host "Test 2: Retrieve Seating Allocation (ADMIN)" -ForegroundColor Yellow
Write-Host "--------------------------------------"

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/seating/SEM_2025_01" `
        -Method GET `
        -Headers @{ "Authorization" = $ADMIN_TOKEN }
    
    Write-Host "✅ SUCCESS: Retrieved seating allocation" -ForegroundColor Green
    Write-Host "Exam ID: $($response.exam_id)" -ForegroundColor Green
    Write-Host "Total Allocations: $($response.allocations.Count)" -ForegroundColor Green
    Write-Host "Total Students: $($response.statistics.total_students)" -ForegroundColor Green
} catch {
    Write-Host "❌ ERROR: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 3: Download CSV (ADMIN)
Write-Host "Test 3: Download Seating CSV (ADMIN)" -ForegroundColor Yellow
Write-Host "--------------------------------------"

try {
    $csvPath = "seating_SEM_2025_01.csv"
    Invoke-WebRequest -Uri "$BASE_URL/seating/SEM_2025_01/csv" `
        -Method GET `
        -Headers @{ "Authorization" = $ADMIN_TOKEN } `
        -OutFile $csvPath
    
    Write-Host "✅ SUCCESS: CSV downloaded to $csvPath" -ForegroundColor Green
    
    # Show first 5 lines of CSV
    Write-Host "First 5 lines of CSV:" -ForegroundColor Cyan
    Get-Content $csvPath -Head 5 | ForEach-Object { Write-Host $_ -ForegroundColor White }
} catch {
    Write-Host "❌ ERROR: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 4: Get Hall Seating (FACULTY)
Write-Host "Test 4: Get Hall Seating (FACULTY)" -ForegroundColor Yellow
Write-Host "--------------------------------------"

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/seating/SEM_2025_01/hall/HALL_A" `
        -Method GET `
        -Headers @{ "Authorization" = $TEACHER_TOKEN }
    
    Write-Host "✅ SUCCESS: Retrieved hall seating" -ForegroundColor Green
    Write-Host "Hall ID: $($response.hall_id)" -ForegroundColor Green
    Write-Host "Total Benches: $($response.total_benches)" -ForegroundColor Green
} catch {
    Write-Host "❌ ERROR: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 5: Get Student Seating (STUDENT)
Write-Host "Test 5: Get Student Seating (STUDENT)" -ForegroundColor Yellow
Write-Host "--------------------------------------"

try {
    # Try with a student roll number (example: CSE2401001)
    $response = Invoke-RestMethod -Uri "$BASE_URL/seating/SEM_2025_01/student/CSE2401001" `
        -Method GET `
        -Headers @{ "Authorization" = $STUDENT_TOKEN }
    
    Write-Host "✅ SUCCESS: Retrieved student seating" -ForegroundColor Green
    Write-Host "Hall ID: $($response.hall_id)" -ForegroundColor Green
    Write-Host "Bench No: $($response.bench_no)" -ForegroundColor Green
    Write-Host "Seat Position: $($response.seat_position)" -ForegroundColor Green
} catch {
    Write-Host "⚠️  NOTE: This might fail if student CSE2401001 doesn't exist in database" -ForegroundColor Yellow
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 6: Role-Based Access Control (Negative Tests)
Write-Host "Test 6: Role-Based Access Control Tests" -ForegroundColor Yellow
Write-Host "--------------------------------------"

# Try to generate seating with STUDENT token (should fail)
Write-Host "6a. Student tries to generate seating (should fail):" -ForegroundColor Cyan
try {
    Invoke-RestMethod -Uri "$BASE_URL/seating/generate" `
        -Method POST `
        -Headers @{ "Authorization" = $STUDENT_TOKEN; "Content-Type" = "application/json" } `
        -Body $seatingRequest
    Write-Host "❌ UNEXPECTED: Student was allowed to generate seating!" -ForegroundColor Red
} catch {
    Write-Host "✅ EXPECTED: Access denied (403)" -ForegroundColor Green
}

Write-Host ""

# Try to access hall seating with STUDENT token (should fail)
Write-Host "6b. Student tries to access hall seating (should fail):" -ForegroundColor Cyan
try {
    Invoke-RestMethod -Uri "$BASE_URL/seating/SEM_2025_01/hall/HALL_A" `
        -Method GET `
        -Headers @{ "Authorization" = $STUDENT_TOKEN }
    Write-Host "❌ UNEXPECTED: Student was allowed to access hall seating!" -ForegroundColor Red
} catch {
    Write-Host "✅ EXPECTED: Access denied (403)" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Test Suite Completed" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

