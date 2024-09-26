@echo off
setlocal

REM Prompt for server name
set /P server="Enter the server name (e.g., ALEXANDRIA): "

set /P user="Are you Alex or Adam?: "

REM Ask if using secure shares
set /P secure="Are you using secure shares? (Y/N): "

if /I "%secure%"=="Y" (
    REM Check if credential already exists
    cmdkey /list | findstr /I "%server%" >nul
    if %errorlevel%==0 (
        echo Credential for %server% already exists. No need to enter again.
    ) else (
        REM Prompt for username and password
        set /P "username=Enter your username: "
        set /P "password=Enter your password: "

        REM Check if username and password are provided
        if "%username%"=="" (
            echo Username cannot be empty. Exiting...
            exit /b
        )
        if "%password%"=="" (
            echo Password cannot be empty. Exiting...
            exit /b
        )

        REM Set Windows Credentials
        cmdkey /add:%server% /user:%username% /pass:%password%
    )
)

REM Common
net use P: \\%server%\pictures /persistent:yes
echo Picture share mounted under P

net use V: \\%server%\videos /persistent:yes
echo Video share mounted under V

REM Adam
if /I "%user%"=="Adam" (
    net use A: \\%server%\Adam /persistent:yes
    echo Adam share mounted under A

    net use B: \\%server%\DevRack /persistent:yes
    echo DevRack share mounted under B

    net use Z: \\%server%\backups /persistent:yes
    echo Backup share mounted under Z
)

REM Alex
if /I "%user%"=="Alex" (
    net use A: \\%server%\Alex /persistent:yes
    echo Alex share mounted under A
)

pause
