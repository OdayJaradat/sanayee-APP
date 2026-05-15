# Sanayee App - Smart Dual Run
# This script builds once, then runs on both devices

Write-Host "=====================================" -ForegroundColor Green
Write-Host "  Sanayee - Smart Dual Launch       " -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""

# Supabase Configuration
$SUPABASE_URL = "hENTER YOUR SUPABASE URL HERE"
$SUPABASE_ANON_KEY = "ENTER YOUR SUPABASE ANON KEY HERE"

# Get running devices
Write-Host "[*] Detecting running emulators..." -ForegroundColor Cyan
$devicesOutput = flutter devices | Out-String

# Extract emulator IDs using Select-String
# Note: PSScriptAnalyzer warning about $matches is a false positive here
# We're not using the automatic $matches variable
$deviceIds = @()
$emulatorPattern = "emulator-\d+"
$foundDevices = Select-String -InputObject $devicesOutput -Pattern $emulatorPattern -AllMatches
if ($null -ne $foundDevices) {
    foreach ($match in $foundDevices.Matches) {
        if ($deviceIds -notcontains $match.Value) {
            $deviceIds += $match.Value
        }
    }
}

if ($deviceIds.Count -lt 2) {
    Write-Host ""
    Write-Host "[ERROR] Need 2 running emulators!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Current running devices: $($deviceIds.Count)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please start 2 Android emulators first!" -ForegroundColor Yellow
    exit 1
}

$device1 = $deviceIds[0]
$device2 = $deviceIds[1]

Write-Host "[OK] Found 2 emulators!" -ForegroundColor Green
Write-Host ""
Write-Host "[CLIENT]       Device 1: $device1" -ForegroundColor Blue
Write-Host "[PROFESSIONAL] Device 2: $device2" -ForegroundColor Magenta
Write-Host ""

# Pre-build to avoid conflicts
Write-Host "[*] Building APK (one-time build)..." -ForegroundColor Yellow
Write-Host "    This will take about 2-3 minutes..." -ForegroundColor Gray

flutter build apk --debug `
    --dart-define=BACKEND=supabase `
    --dart-define=SUPABASE_URL=$SUPABASE_URL `
    --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY `
    --dart-define=USE_AUTH=true

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[ERROR] Build failed! Please check the error above." -ForegroundColor Red
    exit 1
}

$apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
Write-Host ""
Write-Host "[OK] Build complete!" -ForegroundColor Green
Write-Host "[APK] $apkPath" -ForegroundColor Gray
Write-Host ""
Write-Host "[*] Installing and launching apps..." -ForegroundColor Green
Write-Host ""

# Launch on Device 1 (Client)
$clientCommand = @"
`$Host.UI.RawUI.WindowTitle = 'CLIENT - $device1'
`$Host.UI.RawUI.BackgroundColor = 'DarkBlue'
`$Host.UI.RawUI.ForegroundColor = 'White'
Clear-Host
Write-Host '======================================' -ForegroundColor Cyan
Write-Host '     CLIENT Instance - Device 1      ' -ForegroundColor Cyan
Write-Host '     Device: $device1                ' -ForegroundColor Cyan
Write-Host '======================================' -ForegroundColor Cyan
Write-Host ''
cd '$PWD'
flutter run -d $device1 --use-application-binary='$apkPath' --dart-define=BACKEND=supabase --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY --dart-define=USE_AUTH=true
"@

Start-Process powershell -ArgumentList @("-NoExit", "-Command", $clientCommand)

Write-Host "[*] Waiting 5 seconds before launching second instance..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Launch on Device 2 (Professional)
$professionalCommand = @"
`$Host.UI.RawUI.WindowTitle = 'PROFESSIONAL - $device2'
`$Host.UI.RawUI.BackgroundColor = 'DarkMagenta'
`$Host.UI.RawUI.ForegroundColor = 'White'
Clear-Host
Write-Host '======================================' -ForegroundColor Yellow
Write-Host '  PROFESSIONAL Instance - Device 2   ' -ForegroundColor Yellow
Write-Host '     Device: $device2                ' -ForegroundColor Yellow
Write-Host '======================================' -ForegroundColor Yellow
Write-Host ''
cd '$PWD'
flutter run -d $device2 --use-application-binary='$apkPath' --dart-define=BACKEND=supabase --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY --dart-define=USE_AUTH=true
"@

Start-Process powershell -ArgumentList @("-NoExit", "-Command", $professionalCommand)

Write-Host ""
Write-Host "[OK] Both apps launching!" -ForegroundColor Green
Write-Host ""
Write-Host "Usage:" -ForegroundColor Yellow
Write-Host "   - BLUE window   = CLIENT (create requests, accept offers)" -ForegroundColor Cyan
Write-Host "   - MAGENTA window = PROFESSIONAL (send offers, mark complete)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Commands in each window:" -ForegroundColor Yellow
Write-Host "   r  = Hot reload" -ForegroundColor White
Write-Host "   R  = Hot restart" -ForegroundColor White
Write-Host "   q  = Quit app" -ForegroundColor White
Write-Host ""
Write-Host "Press any key to close this window..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
