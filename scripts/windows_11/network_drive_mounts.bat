echo off

set /P user="Are you Alex or Adam?: "

REM Common

net use P: \\ALEXANDRIA\pictures /persistent:yes
echo "Picture share mounted under P"

net use V: \\ALEXANDRIA\videos /persistent:yes
echo "Video share mounted under V"

REM Adam

if %user%==Adam net use A: \\ALEXANDRIA\Adam /persistent:yes
if %user%==Adam echo "Adam share mounted under A"

if %user%==Adam net use B: \\ALEXANDRIA\DevRack /persistent:yes
if %user%==Adam echo "DevRack share mounted under B"

if %user%==Adam net use Z: \\ALEXANDRIA\backups /persistent:yes
if %user%==Adam echo "Backup share mounted under Z"

REM Alex

if %user%==Alex net use A: \\ALEXANDRIA\Alex /persistent:yes
if %user%==Alex echo "Alex share mounted under A"

pause