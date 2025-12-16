# Flutter/ADB Connection Fix Script
# Run this script when experiencing VM service or DevFS connection errors

Write-Host "`n=== Flutter/ADB Connection Fix ===" -ForegroundColor Cyan
Write-Host "`nThis script will resolve common Flutter VM service and ADB connection issues.`n" -ForegroundColor Gray

# Set ADB path from local.properties
$sdkPath = "C:\Users\harsh\AppData\Local\Android\sdk"
$adb = "$sdkPath\platform-tools\adb.exe"

# Step 1: Check current devices
Write-Host "Step 1: Checking connected devices..." -ForegroundColor Yellow
& $adb devices
Write-Host ""

# Step 2: Restart ADB server
Write-Host "Step 2: Restarting ADB server..." -ForegroundColor Yellow
& $adb kill-server
Start-Sleep -Seconds 2
& $adb start-server
Start-Sleep -Seconds 2
Write-Host "ADB server restarted" -ForegroundColor Green
Write-Host ""

# Step 3: Kill stuck Flutter/Dart processes
Write-Host "Step 3: Terminating stuck Flutter/Dart processes..." -ForegroundColor Yellow
$processes = Get-Process | Where-Object { $_.ProcessName -match "flutter|dart" }
if ($processes) {
    $processes | ForEach-Object {
        Write-Host "  Killing: $($_.ProcessName) (PID: $($_.Id))" -ForegroundColor Gray
        Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
    }
    Write-Host "Processes terminated" -ForegroundColor Green
} else {
    Write-Host "No stuck processes found" -ForegroundColor Green
}
Write-Host ""

# Step 4: Verify connection
Write-Host "Step 4: Verifying Flutter device connection..." -ForegroundColor Yellow
flutter devices
Write-Host ""

# Step 5: Provide next steps
Write-Host "=== Fix Complete ===" -ForegroundColor Green
Write-Host "`nNext steps to run your app:" -ForegroundColor Cyan
Write-Host "  1. Make sure Developer Mode is enabled in Windows Settings" -ForegroundColor White
Write-Host "  2. In Android Studio, click the 'Run' button (green play icon)" -ForegroundColor White
Write-Host "  3. Or run from terminal: flutter run -d emulator-5554" -ForegroundColor White
Write-Host "`nIf issues persist:" -ForegroundColor Cyan
Write-Host "  • Run: flutter doctor -v" -ForegroundColor White
Write-Host "  • Restart Android Studio" -ForegroundColor White
Write-Host "  • Cold boot your emulator" -ForegroundColor White
Write-Host ""

