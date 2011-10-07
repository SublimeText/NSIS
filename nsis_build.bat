@echo off

set nsis_compiler=

if %PROCESSOR_ARCHITECTURE%==x86 (
    Set RegQry=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS
) else (
    Set RegQry=HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\NSIS
)

if not defined nsis_compiler (
    for /F "tokens=2*" %%a in ('reg query %RegQry% /v InstallLocation ^|findstr InstallLocation') do set nsis_compiler=%%b
)

if defined nsis_compiler (
    "%nsis_compiler%\makensis.exe" %1
) else (
    echo "Error, build system cannot find NSIS! Please reinstall or add it to the batch file variable nsis_compiler."
)