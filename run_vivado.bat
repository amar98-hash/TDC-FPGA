@echo off
cd /d "%~dp0"

echo ========================================
echo Creating Vivado project...
echo ========================================

vivado -mode batch -source build_scripts/create_project.tcl

echo.
echo Vivado batch finished with ERRORLEVEL=%ERRORLEVEL%
echo.

IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: Project generation failed.
    pause
    exit /b %ERRORLEVEL%
)

if not exist "build_scripts\project_info.bat" (
    echo ERROR: Missing build_scripts\project_info.bat
    echo The TCL script did not export project info.
    pause
    exit /b 1
)

call build_scripts\project_info.bat

echo ========================================
echo Opening Vivado project...
echo ========================================
echo Project name: %PROJECT_NAME%
echo Project dir:  %PROJECT_DIR%
echo XPR path:     %XPR_PATH%
echo ========================================

if not exist "%XPR_PATH%" (
    echo ERROR: Project file not found:
    echo %XPR_PATH%
    pause
    exit /b 1
)

start "" vivado "%XPR_PATH%"

echo.
echo Vivado GUI launch command sent.
pause