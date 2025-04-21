Param(
    $sourceDir = "C:\DayZServer",
    $backupDir = "H:\",
    $compressionLevel = 3 # Set compression level: 1 = fastest, 9 = highest compression
)

# Extract the folder name from the source path
$dirName = Split-Path $sourceDir -Leaf

# Generate timestamp string for folder and file naming
$dateTime = (Get-Date -Format "dd-MM-yyyy_-_HH'h'-mm'm'-ss's'")

# Build the full path where the backup will be stored
$backupPath = Join-Path $backupDir "$dirName`_$dateTime"

# Define the ZIP file name and full path
$zipFileName = "$dirName`_$dateTime.zip"
$zipFilePath = Join-Path $backupPath $zipFileName

# Create the backup directory (if it doesn't exist)
New-Item -ItemType Directory -Force -Path $backupPath

# Prepare 7-Zip execution with arguments
$sevenZipCmd = "C:\Program Files\7-Zip\7z.exe"
$arguments = "a -tzip `"$zipFilePath`" `"$sourceDir\*`" -mx=$compressionLevel"

# Run 7-Zip to compress all contents of the source directory
Start-Process -FilePath $sevenZipCmd -ArgumentList $arguments -NoNewWindow -Wait

# Generate file hashes (SHA1, SHA256, MD5) in parallel and write them to checksums.txt
@('SHA1', 'SHA256', 'MD5') | ForEach-Object -Parallel {
    $hash = Get-FileHash -Path $using:zipFilePath -Algorithm $_ | Format-List
    $outPath = "$using:backupPath\checksums.txt"
    $append = if ($_ -eq 'SHA1') { $false } else { $true }
    $hash | Out-File -FilePath $outPath -Append:$append
}

# Output the final backup path to the console
Write-Output "Backup created: $zipFilePath"
