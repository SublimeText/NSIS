@echo off
set nsis_compiler=

if %PROCESSOR_ARCHITECTURE%==x86 (
    set RegQry=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS
) else (
    set RegQry=HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\NSIS
)

for /F "tokens=2*" %%a in ('reg query "%RegQry%" /v InstallLocation ^|findstr InstallLocation') do set nsis_compiler=%%b

if not defined nsis_compiler (
    for %%X in (makensis.exe) do (set nsis_compiler=%%~dp$PATH:X)
)

set args=
:loop
    set args=%args% %1
    shift
if not "%~1"=="" goto loop

if defined nsis_compiler (
    "%nsis_compiler%\makensis.exe" %args%
) else (
    echo "Error, build system cannot find NSIS! Make sure it's installed and makensis.exe is in your PATH environment variable."
)
