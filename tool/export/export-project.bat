@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Export Project - Interactive Batch Script
:: Lists source folders and allows selection for export

echo.
echo ==========================================================
echo    Smart Call Block - Project Export Tool
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
    echo Please run this script from the correct location:
    echo development-rules\tool\export\
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

:: List all folders in Source directory (excluding development-rules and test-app)
echo Available Projects in Source:
echo -----------------------------------------------
set /a count=0
set "target_project="
for /d %%d in ("%SOURCE_DIR%\*") do (
    set "folder_name=%%~nxd"
    if /i not "!folder_name!"=="development-rules" (
        if /i not "!folder_name!"=="test-app" (
            set /a count+=1
            set "folder[!count!]=!folder_name!"
            echo    [!count!] !folder_name!
            if /i "!folder_name!"=="smart-call-block" set "target_project=!folder_name!"
        )
    )
)

echo -----------------------------------------------
echo.

:: Auto-select if only one project available
if !count! equ 1 (
    call set "selected_project=%%folder[1]%%"
    echo Auto-selected project: !selected_project!
    echo.
    goto project_selected
)

:: Auto-select smart-call-block if available
if not "!target_project!"=="" (
    echo Auto-selected project: !target_project!
    set "selected_project=!target_project!"
    echo.
    goto project_selected
)

:: Check if no projects found
if !count! equ 0 (
    echo No exportable projects found in Source directory!
    echo.
    echo Available folders were filtered out (development-rules, test-app)
    echo Check if you have a valid project in the Source directory.
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

:: Manual selection for multiple projects
echo Which project do you want to export?
set /p "project_choice=Enter project number (1-!count!): "

if "!project_choice!"=="" (
    echo No selection made!
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

if !project_choice! lss 1 (
    echo Invalid selection!
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

if !project_choice! gtr !count! (
    echo Invalid selection!
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

call set "selected_project=%%folder[!project_choice!]%%"
echo Selected project: !selected_project!
echo.

:project_selected
:: Show current project detection based on selection
echo Auto-detected project structure for "!selected_project!":
if exist "%SOURCE_DIR%\!selected_project!\ANDROID" (
    echo    [OK] Android Project: !selected_project!\ANDROID\
    set "has_android=1"
) else (
    echo    [--] Android Project: Not found
    set "has_android=0"
)

if exist "%SOURCE_DIR%\!selected_project!\IOS" (
    echo    [OK] iOS Project: !selected_project!\IOS\
    set "has_ios=1"
) else (
    echo    [--] iOS Project: Not found  
    set "has_ios=0"
)

if exist "%SOURCE_DIR%\!selected_project!\DOCs" (
    echo    [OK] Documentation: !selected_project!\DOCs\
) else (
    echo    [--] Documentation: Not found
)

echo.
echo NOTE: development-rules will be automatically excluded from export
echo.

:: Platform selection (simplified - auto-select based on available content)
if "!has_android!"=="1" if "!has_ios!"=="1" (
    echo Both Android and iOS detected - exporting both platforms
    set "platform_param=-Platform both"
    set "platform_choice=3"
) else if "!has_android!"=="1" (
    echo Android project detected - exporting Android only
    set "platform_param=-Platform android"
    set "platform_choice=1"
) else if "!has_ios!"=="1" (
    echo iOS project detected - exporting iOS only
    set "platform_param=-Platform ios"
    set "platform_choice=2"
) else (
    echo No specific platform detected - exporting all content
    set "platform_param=-Platform both"
    set "platform_choice=3"
)

:: Use default project name
set "project_name=SmartCallBlock"

:: Use default options
set "zip_param=-CreateZipFile"
set "keep_param="
set "gradle_param="

:: Ask about Gradle exclusion
echo.
echo ==========================================================
echo    Gradle Configuration
echo ==========================================================
echo Android Studio đôi khi gặp lỗi với Gradle files khi import.
echo Bạn có muốn bỏ qua tất cả Gradle files không? (khuyến nghị)
echo.
echo 1. Bỏ qua Gradle files (khuyến nghị cho Android Studio)
echo 2. Giữ Gradle files (build từ command line)
echo.
set /p "gradle_choice=Lựa chọn (1 hoặc 2, default=1): "

if "!gradle_choice!"=="" set "gradle_choice=1"
if "!gradle_choice!"=="1" (
    set "gradle_param=-SkipGradle"
    echo Selected: Bỏ qua Gradle files
) else (
    set "gradle_param="
    echo Selected: Giữ Gradle files
)
:: Show export summary
echo.
echo ==========================================================
echo    Export Configuration Summary
echo ==========================================================
echo Platform: !platform_choice! 
if "!platform_choice!"=="1" echo    (Android only)
if "!platform_choice!"=="2" echo    (iOS only)
if "!platform_choice!"=="3" echo    (Both platforms)
echo Project Name: !project_name!
if "!gradle_param!"=="-SkipGradle" (
    echo Gradle Files: Excluded ^(bỏ qua để tránh lỗi Android Studio^)
) else (
    echo Gradle Files: Included
)
echo Output Location: Source\Export\!project_name!_Export_[timestamp]\
echo.

:: Execute PowerShell export script
echo ==========================================================
echo    Starting Export Process...
echo ==========================================================
echo.

:: Build PowerShell command
set "ps_script=%SCRIPT_DIR%export-full-project.ps1"
set "ps_command=powershell.exe -ExecutionPolicy Bypass -File "!ps_script!" !platform_param! -ProjectName "!project_name!" !zip_param! !keep_param! !gradle_param! -ShowVerbose"

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
    echo Export completed successfully!
    echo.
)

:: Ask to open output folder
set /p "open_folder=Open export folder? (Y/n): "
if /i not "!open_folder!"=="n" (
    echo Opening export folder...
    :: Create Export directory path correctly
    set "EXPORT_DIR=!SOURCE_DIR!\Export"
    echo Debug: Export path is !EXPORT_DIR!
    if exist "!EXPORT_DIR!" (
        start "" "!EXPORT_DIR!"
    ) else (
        echo Export directory not found: !EXPORT_DIR!
        echo Creating Export directory...
        mkdir "!EXPORT_DIR!" 2>nul
        start "" "!EXPORT_DIR!"
    )
)

echo.
echo Export process completed!
echo.
echo Press any key to exit...
pause >nul