@echo off
setlocal enabledelayedexpansion

REM Prompt the user for the root directory path
set /p "rootDir=Enter the path for the root directory (e.g., P:\<DIR>\<YEAR>\<Location>\<CAMERA1>): "
REM Remove trailing backslashes from the rootDir if present
if "%rootDir:~-1%"=="\" set "rootDir=%rootDir:~0,-1%"

REM Prompt the user for the target directory path
set /p "targetDir=Enter the path for the target directory (e.g., P:\<DIR>\<YEAR>\<Location>\<RAW>): "
REM Remove trailing backslashes from the targetDir if present
if "%targetDir:~-1%"=="\" set "targetDir=%targetDir:~0,-1%"

REM Check if the target directory exists, create it if it does not
if not exist "%targetDir%" (
    echo Creating target directory: "%targetDir%"
    mkdir "%targetDir%"
)

REM Output the paths for verification
echo Searching for .ARW files in "%rootDir%"
echo Target directory is "%targetDir%"

REM Initialize file count
set /a fileCount=0

REM Move all .ARW files from subdirectories into the target directory
for /r "%rootDir%" %%f in (*.ARW) do (
    echo Moving "%%f" to "%targetDir%"
    move "%%f" "%targetDir%"
    set /a fileCount+=1
)

REM Provide a summary of the number of files moved
echo.
echo Number of .ARW files moved: !fileCount!

echo Done!
endlocal
pause
