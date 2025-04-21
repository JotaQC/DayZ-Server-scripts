@echo off

::Window format
mode con: cols=100 lines=5

:start

::Server name
set serverName="<CHANGE_ME>"

::Server files location
set serverLocation="C:\DayZServer"

::Server Profile folder
set profile=config_chernarus_1

::Server Port
set serverPort=2302

::Server config
set serverConfig=serverDZ.cfg

::Logical CPU cores to use (Equal or less than available)
set serverCPU=4

::Server-side mods (do not end with a semicolon ";", only use it to separate items, as shown below)
set servermods=<@CHANGE_ME>;<@CHANGE_ME>;<@CHANGE_ME>;<@CHANGE_ME>;<@CHANGE_ME>

::Mods (do not end with a semicolon ";", only use it to separate items, as shown below)
set mods=<@CHANGE_ME>;<@CHANGE_ME>;<@CHANGE_ME>;<@CHANGE_ME>;<@CHANGE_ME>

::Sets the terminal title (DO NOT edit)
title %serverName% batch

::DayZServer location (DO NOT edit)
cd "%serverLocation%"
echo (%time%) -- %serverName% started.

::Launch parameters for the server (no editing is needed here, but feel free to do so if you wish)
start "DayZ Server" /min "DayZServer_x64.exe" -profiles=%profile% -config=%serverConfig% -port=%serverPort% "-servermod=%servermods%" "-mod=%mods%" -cpuCount=%serverCPU% -dologs -adminlog -netlog -freezecheck

::Time in seconds before terminating the server process (14400 = 4 hours)
timeout 14530
cls
taskkill /im DayZServer_x64.exe /F

::Wait for confirmation and clear console
timeout 3
cls

:: === Backup Script Section (checkings and launching if needed) ===

:: !!! For this part, it is recommended to have PowerShell 7 installed for compatibility with backup_7z.ps1 !!!

:: Enable delayed variable expansion
setlocal enabledelayedexpansion

:: = Logs =
::Logs path
set logsPath=H:\Logs

::Check if Logs directory exist. If not, create it
if not exist %logsPath% (
    echo Logs directory does not exist. Creating one . . .
    mkdir "%logsPath%"
) else (
    echo Logs directory already exist. Skipping . . .
)

::Get current date with PowerShell
for /f %%i in ('pwsh -Command "Get-Date -Format dd-MM-yyyy"') do set today=%%i

::Set log file name based on date
set logFile=%logsPath%\backupRuns_%today%.log

::Clean logs older than 7 days
forfiles /p %logsPath% /m *.log /d -7 /c "cmd /c del @path" >nul 2>&1

::Path where backups are being saved (do not add the backslash "\" or it will fail)
set backupDir=H:

:: = Backup =
::Search for directory beginning with DayZServer_%today%
dir /b "%backupDir%\DayZServer_%today%*" >nul 2>&1
if errorlevel 1 (
    echo No backup found for today. Starting the backup script . . .
    >> "%logFile%" echo.
    >> "%logFile%" echo ------------------------------------------------------------------------------------------
    >> "%logFile%" echo.
    >> "%logFile%" echo [*] -- [ !date! @ !time! ] - Backup script executed.

    :: !!! You must have 7-Zip installed for the backup script to work !!!

    ::Change the path if needed
    pwsh -File "H:\backup_7z.ps1"

    >> "%logFile%" echo [+] -- [ !date! @ !time! ] - Backup script finished.
    >> "%logFile%" echo.
    >> "%logFile%" echo ------------------------------------------------------------------------------------------
    >> "%logFile%" echo.
) else (
    echo Backup already exists for today. Skipping . . .
    >> "%logFile%" echo [#] -- [ !date! @ !time! ] - Backup script skipped. Backup for today exists.
)

endlocal

::Time in seconds to wait before starting server again
timeout 10
cls

::Go back to the top and repeat the cycle
goto start
