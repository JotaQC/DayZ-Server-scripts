Param(
    [string]$sourceDir = "C:\DayZServer",
    [string]$backupDir = "H:\",
    [string]$compressionLevel = 3, # Set compression level: 1 = fastest, 9 = highest compression
    [string]$logsPath = "H:\Logs\BackupsLogs"
)

# Check if the backup drive is available
if (-not (Test-Path $backupDir)) {
    $errorMessage = "[!] [$(Get-Date -Format 'HH:mm:ss')] -- The backup destination drive ($backupDir) is not available. Aborting backup."
    Write-Error $errorMessage

    # Fallback log location if remote drive is unavailable
    $localLogPath = "C:\BackupErrorLogs"
    if (-not (Test-Path $localLogPath)) {
        New-Item -ItemType Directory -Path $localLogPath -Force | Out-Null
    }
    $fallbackLogFile = "$localLogPath\BackupError_$(Get-Date -Format 'dd-MM-yyyy_HH-mm-ss').log"
    $errorMessage | Out-File -FilePath $fallbackLogFile -Encoding UTF8 -Append

    exit 1
}

# Generate timestamp string for folder and file naming
$dateTime = (Get-Date -Format "dd-MM-yyyy_-_HH'h'-mm'm'-ss's'")

# Create backup logs directory (if it doesn't exist)
if (-not (Test-Path $logsPath)) {
    New-Item -ItemType Directory -Path $logsPath -Force | Out-Null
}
"[+] [$(Get-Date -Format 'HH:mm:ss')] -- Timestamp generated and log backup file created. -- Timestamp: $dateTime" | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
"--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append

# This script will also save every process of the backup as a log
"[*] [$(Get-Date -Format 'HH:mm:ss')] -- Backup Script Running . . ." | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
"--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append

# Extract the folder name from the source path
"[*] [$(Get-Date -Format 'HH:mm:ss')] -- Extracting folder name from source path . . ." | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
$dirName = Split-Path $sourceDir -Leaf
"[+] [$(Get-Date -Format 'HH:mm:ss')] -- Folder name extracted. -- Folder name: $dirName" | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
"--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append

# Build the full path where the backup will be stored
"[*] [$(Get-Date -Format 'HH:mm:ss')] -- Building the full path where the backup will be stored . . ." | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
$backupPath = Join-Path $backupDir "$dirName`_$dateTime"
"[+] [$(Get-Date -Format 'HH:mm:ss')] -- Full path created. -- Full path: $backupPath" | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
"--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append

# Define the ZIP file name and full path
"[*] [$(Get-Date -Format 'HH:mm:ss')] -- Setting ZIP file name and full path . . ." | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
$zipFileName = "$dirName`_$dateTime.zip"
$zipFilePath = Join-Path $backupPath $zipFileName
"[+] [$(Get-Date -Format 'HH:mm:ss')] -- File name and full path set. -- File name: $zipFileName | Full path: $zipFilePath" | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
"--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append

# Create the backup directory (if it doesn't exist) | It will never exist, but it is a good practice to check in case the structure changes in the future and the time is no longer added to the name
"[*] [$(Get-Date -Format 'HH:mm:ss')] -- Checking if backup directory exists . . ." | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
if (-not (Test-Path $backupPath)) {
    "[*] [$(Get-Date -Format 'HH:mm:ss')] -- Creating backup directory . . ." | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
    New-Item -ItemType Directory -Force -Path $backupPath
    "[+] [$(Get-Date -Format 'HH:mm:ss')] -- Directory for backup created. -- Backup Path: $backupPath" | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
} else {
    "[!] [$(Get-Date -Format 'HH:mm:ss')] -- Directory for backup already exists. -- Backup Path: $backupPath" | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
}
"--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append

# Prepare 7-Zip execution with arguments
"[*] [$(Get-Date -Format 'HH:mm:ss')] -- Preparing 7-Zip for execution with arguments . . ." | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
$sevenZipCmd = "C:\Program Files\7-Zip\7z.exe"
$arguments = "a -tzip `"$zipFilePath`" `"$sourceDir\*`" -mx=$compressionLevel"
"[+] [$(Get-Date -Format 'HH:mm:ss')] -- 7-Zip and arguments prepared." | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
"--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append

# Run 7-Zip to compress all contents of the source directory
"[*] [$(Get-Date -Format 'HH:mm:ss')] -- Running 7-Zip to compress all . . ." | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
Start-Process -FilePath $sevenZipCmd -ArgumentList $arguments -NoNewWindow -Wait
"[+] [$(Get-Date -Format 'HH:mm:ss')] -- 7-Zip finished compression." | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
"--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append

# Waits until a file is no longer locked before continuing.
# This is used to avoid access errors when a file may still be in use after compression completes, especially on slower systems or under high CPU load, where the file handle isn't released immediately.
function Wait-ForFileUnlock {
    param (
        [string]$filePath,
        [int]$timeoutInSeconds = 30
    )
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    while ($sw.Elapsed.TotalSeconds -lt $timeoutInSeconds) {
        try {
            $stream = [System.IO.File]::Open($filePath, 'Open', 'Read', 'None')
            $stream.Close()
            return $true
        } catch {
            Start-Sleep -Milliseconds 500
        }
    }
    throw "Timeout waiting for file to be released: $filePath"
}

"[*] [$(Get-Date -Format 'HH:mm:ss')] -- Waiting for ZIP file to be released . . ." | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
Wait-ForFileUnlock -filePath $zipFilePath
"[+] [$(Get-Date -Format 'HH:mm:ss')] -- ZIP file is unlocked and ready for hashing." | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append

# Generate file hashes (SHA1, SHA256, MD5) in parallel and write them to checksums.txt
"[*] [$(Get-Date -Format 'HH:mm:ss')] -- Generating file hashes in SHA1, SH256 and MD5 . . ." | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
@('SHA1', 'SHA256', 'MD5') | ForEach-Object {
    $hash = Get-FileHash -Path $zipFilePath -Algorithm $_ | Format-List
    $outPath = "$backupPath\checksums.txt"
    $append = if ($_ -eq 'SHA1') { $false } else { $true }
    $hash | Out-File -FilePath $outPath -Append:$append
}
"[+] [$(Get-Date -Format 'HH:mm:ss')] -- Hashes generated and saved to file. -- Checksum file: $backupPath\checksums.txt" | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
"--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
"[+] [$(Get-Date -Format 'HH:mm:ss')] -- Backup Script Running Complete." | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append
"////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////" | Out-File -FilePath "$logsPath\BackupInfo_$dateTime.log" -Encoding UTF8 -Append

# Print the backup file path after the backup is complete
Write-Output "Backup created: $zipFilePath"
