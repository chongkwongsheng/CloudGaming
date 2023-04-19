 # Check if D drive already exists
if (Test-Path D:\) {
    Write-Host "D drive already exists. Skipping ephemeral storage setup."
} else {

    # Get all disks with a raw partition style
    $disks = Get-Disk | Where-Object { $_.PartitionStyle -eq 'Raw' }

    # Check if there are any disks to add
    if ($disks.Count -eq 0) {
        Write-Error "No disks to add"
        exit 1
    }

    # Sort the disks by size and select the largest one
    $largestDisk = $disks | Sort-Object Size -Descending | Select-Object -First 1

    # Initialize the largest disk
    $initializedDisk = Initialize-Disk -InputObject $largestDisk -PartitionStyle MBR -PassThru

    # Create a new partition on the largest disk and assign a drive letter
    $partition = New-Partition -DiskNumber $initializedDisk.Number -UseMaximumSize -AssignDriveLetter

    # Format the new partition as NTFS with a specified label
    $formatResult = Format-Volume -DriveLetter $partition.DriveLetter -FileSystem NTFS -NewFileSystemLabel 'EPHEMERAL' -Confirm:$false

    # Check if the format was successful and exit with an error if it was not
    if ($formatResult.FileSystem -ne 'NTFS') {
        Write-Error "Failed to format drive"
        exit 1
    }
}

$source = "C:\EphemeralBackup\SteamLibrary\"
$destinationFolder = "D:\SteamLibrary\"
$logFile = "C:\EphemeralRestore.log"

cls

# Check if source exists
if (-not (Test-Path $source)) {
    Write-Error "$source not found"
    exit 1
}

# Shutdown Steam if it is still running
try {
    $steam = (Get-Process -Name steam -ErrorAction SilentlyContinue).Path
    &$steam -shutdown
}
catch {
    "Steam not running"
}

# Delete contents of the destination folder
if (Test-Path $destinationFolder) {
    Remove-Item "$destinationFolder\*" -Recurse -Force
} else {
    New-Item -ItemType Directory -Path $destinationFolder | Out-Null
}

# Create log file
New-Item -ItemType File -Path $logFile -Force | Out-Null

# Copy contents of source to destination folder using robocopy
Write-Host "Copying contents of $source to $destinationFolder..."
$startTime = Get-Date
$robocopyArgs = "$source $destinationFolder /E /ZB /COPY:DAT /R:1 /W:1 /MT:64 /LOG:$logFile"
Start-Process -FilePath "robocopy.exe" -ArgumentList $robocopyArgs -NoNewWindow -Wait

# Calculate total time taken
$totalTime = New-TimeSpan -Start $startTime -End (Get-Date)
$totalTimeString = "{0}:{1:D2}:{2:D2}" -f $totalTime.Hours, $totalTime.Minutes, $totalTime.Seconds

# Display completion message with total time taken
cls
Write-Host "Restore complete. Total time taken: $totalTimeString"

# Check if copy was successful
$failedFiles = Get-Content -Path $logFile | Select-String -Pattern "Error copying:"
if ($failedFiles.Count -gt 0) {
    $failedFiles = $failedFiles | ForEach-Object {$_.ToString().Replace("Error copying: ","").Replace("`nError message: ","")}
    Write-Error "Failed to copy the following files:`n$($failedFiles -join "`n")"
} 
