@echo off
:: Sanayee - Smart Dual Launch (Recommended Method)
echo =====================================
echo   Sanayee - Smart Dual Launcher
echo   (Build once, run twice - No conflicts!)
echo =====================================
echo.

:: Check if PowerShell script exists
if not exist "run_dual_smart.ps1" (
    echo Error: run_dual_smart.ps1 not found!
    pause
    exit /b 1
)

:: Run PowerShell script
echo Starting smart dual instance mode...
echo This will build the APK once, then run it on both devices.
echo.
powershell -ExecutionPolicy Bypass -File "run_dual_smart.ps1"

pause

