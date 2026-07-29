@echo off
setlocal

set "nsis_compiler="
set "nsis_dir="

for /f "tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" /v InstallLocation /reg:32 2^>nul ^| findstr /i "InstallLocation"') do set "nsis_dir=%%b"

if defined nsis_dir if exist "%nsis_dir%\makensis.exe" set "nsis_compiler=%nsis_dir%\makensis.exe"

if not defined nsis_compiler for %%X in (makensis.exe) do set "nsis_compiler=%%~$PATH:X"

if not defined nsis_compiler (
    echo Error: build system cannot find NSIS! Make sure it's installed and makensis.exe is in your PATH environment variable.>&2
    exit /b 1
)

if "%~1"=="" (
    echo Error: No arguments passed>&2
    exit /b 1
)

"%nsis_compiler%" %*
exit /b %ERRORLEVEL%
