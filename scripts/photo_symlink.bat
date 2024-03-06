@echo off

REM Check if plink is available
where plink >nul 2>nul
if %errorlevel% neq 0 (
    echo plink is not installed or not in PATH.
    exit /b 1
)

REM Prompt user for source directory
set /p "source_dir=Enter source directory path: "

REM Prompt user for destination directory
set /p "destination_dir=Enter destination directory path: "

REM Prompt user for password
set /p "password=Enter root password: "

REM Execute the shell script remotely using plink
plink -ssh {alexandria_IP}@{alexandria_IP} -pw %password% "/mnt/user/DevRack/DevRack/scripts/photo_symlink.sh %source_dir% %destination_dir%"
