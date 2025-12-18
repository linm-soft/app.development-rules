@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Quick Export (No Gradle) - Fast export for Android Studio import
:: Automatically excludes all Gradle files to prevent import issues

echo.
echo ==========================================================
echo    Quick Export Tool (No Gradle Files)
echo ==========================================================
echo Công cụ export nhanh, tự động loại bỏ Gradle files
echo để tránh lỗi khi import vào Android Studio
echo ==========================================================
echo.

:: Get the Source directory path
set "SCRIPT_DIR=%~dp0"
for %%i in ("%SCRIPT_DIR%..\..\..\") do set "SOURCE_DIR=%%~fi"

echo Source Directory: %SOURCE_DIR%
echo.

:: Check if Source directory exists
if not exist "%SOURCE_DIR%" (
    echo ERROR: Source directory not found!
    echo Expected: %SOURCE_DIR%
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

:: Auto-detect project
set "selected_project=smart-call-block"
if not exist "%SOURCE_DIR%\!selected_project!" (
    echo ERROR: Project not found: !selected_project!
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

echo Auto-selected project: !selected_project!
echo.

:: Show project structure
echo Detected project structure:
if exist "%SOURCE_DIR%\!selected_project!\ANDROID" (
    echo    [OK] Android Project: !selected_project!\ANDROID\
) else (
    echo    [--] Android Project: Not found
)

if exist "%SOURCE_DIR%\!selected_project!\IOS" (
    echo    [OK] iOS Project: !selected_project!\IOS\
) else (
    echo    [--] iOS Project: Not found  
)

if exist "%SOURCE_DIR%\!selected_project!\DOCs" (
    echo    [OK] Documentation: !selected_project!\DOCs\
) else (
    echo    [--] Documentation: Not found
)

echo.
echo ==========================================================
echo    Export Configuration
echo ==========================================================
echo Gradle Files: Excluded (tự động bỏ qua)
echo Platform: Both (Android + iOS + Docs)
echo Project Name: SmartCallBlock
echo.

:: Execute PowerShell export script with SkipGradle
echo ==========================================================
echo    Starting Quick Export...
echo ==========================================================
echo.

:: Build PowerShell command
set "ps_script=%SCRIPT_DIR%export-full-project.ps1"
set "ps_command=powershell.exe -ExecutionPolicy Bypass -File "!ps_script!" -Platform both -ProjectName "SmartCallBlock" -CreateZipFile -SkipGradle -ShowVerbose"

echo Executing: !ps_command!
echo.

:: Run the PowerShell script
!ps_command!

:: Check exit code
if errorlevel 1 (
    echo.
    echo Export failed! Check the error messages above.
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
) else (
    echo.
    echo Quick export completed successfully!
    echo All Gradle files have been excluded to avoid Android Studio import issues.
    echo.
)

:: Auto-open output folder
echo Opening export folder...
set "EXPORT_DIR=!SOURCE_DIR!\Export"
if exist "!EXPORT_DIR!" (
    start "" "!EXPORT_DIR!"
) else (
    echo Export directory not found: !EXPORT_DIR!
    mkdir "!EXPORT_DIR!" 2>nul
    start "" "!EXPORT_DIR!"
)

echo.
echo ==========================================================
echo    Quick Export Completed!
echo ==========================================================
echo Project exported successfully without Gradle files.
echo Ready for Android Studio import.
echo.
echo Press any key to exit...
pause >nul