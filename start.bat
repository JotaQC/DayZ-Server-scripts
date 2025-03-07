@echo off
::Window format
mode con: cols=100 lines=5

::Do not place quotation marks ("") where they are not present

:start

::Server name
set serverName="<PLACE_YOUR_SERVER_NAME_HERE>"

::Server files location
set serverLocation="<PLACE_LOCATION_OF_YOUR_SERVER_FILES_HERE>"

::Server profile folder
set profile=<SET_A_NAME_FOR_PROFILE_FOLDER>

::Server port
set serverPort=<SERVER_PORT>

::Server config
set serverConfig=serverDZ.cfg

::Logical CPU cores to use (Equal or less than available)
set serverCPU=<NUMBER_OF_CPU>

::Mods
set mods=<PLACE_YOUR_MODS_HERE_LIKE:_@MOD1;@MOD2;MOD3_THE_LAST_ONE_DOES_NOT_HAVE_;_AT_THE_END>

::Set title for terminal (DO NOT edit)
title %serverName% batch

::Change directory to DayZ Server location (DO NOT edit)
cd "%serverLocation%"
echo (%time%) -- %serverName% started.

::Launch parameters for server and DaRT (if you use DaRT. If not, comment out these lines)
start "DayZ Server" /min "DayZServer_x64.exe" -profiles=%profile% -config=%serverConfig% -port=%serverPort% "-mod=%mods%" -cpuCount=%serverCPU% -dologs -adminlog -netlog -freezecheck

::DaRT (if you use DaRT, place the DaRT folder inside the server directory)
set DaRTLocation="<CHANGE_THIS_WITH_YOUR_SERVER_FOLDER_FULL_PATH>\DaRT"
set DaRTExe="DaRT.exe"
cd "%DaRTLocation%"

:: Check if DaRT is running
tasklist /FI "IMAGENAME eq DaRT.exe" 2>NUL | find /I "DaRT.exe" >NUL
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo DaRT.exe is not running. Starting . . .
    start "" "DaRT.exe"
) else (
    echo.
    echo DaRT.exe is already running.
)

::Time in seconds before killing server process (14400 = 4 hours)
timeout 14400
cls
taskkill /im DayZServer_x64.exe /F

::Wait for confirmation and clear console
timeout 3
cls

::Time in seconds to wait before restarting the server
timeout 10
cls

::Go back to the start and repeat cycle
goto start
