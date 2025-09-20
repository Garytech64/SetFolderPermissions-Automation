<#
.SYNOPSIS
Prepares a Windows 10 VM for golden image creation.

.DESCRIPTION
- Cleans temp files and old user profiles
- Clears logs, prefetch, and recycle bin
- Cleans Windows Update cache
- Runs Sysprep with generalize and shutdown options

.RUNON
Windows 10 VM

.REQUIRES
Local admin privileges
#>

# Import logging module
Import-Module "$PSScriptRoot\..\Modules\Logging.psm1"

Write-Log "=== Golden Image Preparation Started ==="

try {
    # Step 1: Ensure VM is not joined to domain
    Write-Log "[INFO] Ensure this VM has been removed from the domain and joined to WORKGROUP."

    # Step 2: Delete all user profiles except Administrator & Public
    Write-Log "[STEP] Cleaning up user profiles..."
    $Profiles = Get-WmiObject Win32_UserProfile | Where-Object {
        $_.LocalPath -notlike "C:\Users\Administrator*" -and $_.LocalPath -notlike "C:\Users\Public"
    }
    foreach ($Profile in $Profiles) {
        try {
            $Profile.Delete()
            Write-Log "Deleted profile: $($Profile.LocalPath)"
        } catch {
            Write-Log "Failed to delete profile: $($Profile.LocalPath)" "WARNING"
        }
    }

    # Step 3: Clear temp folders
    Write-Log "[STEP] Clearing temp files..."
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

    # Step 4: Clear event logs
    Write-Log "[STEP] Clearing event logs..."
    try {
        wevtutil el | ForEach-Object { wevtutil cl $_ }
    } catch {
        Write-Log "Failed to clear some event logs: $_" "WARNING"
    }

    # Step 5: Clean Windows Update cache
    Write-Log "[STEP] Cleaning Windows Update cache..."
    Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
    Start-Service -Name wuauserv -ErrorAction SilentlyContinue

    # Step 6: Clear Prefetch and Recycle Bin
    Write-Log "[STEP] Clearing Prefetch and Recycle Bin..."
    Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue

    # Step 7: Run Sysprep
    Write-Log "[FINAL STEP] Running Sysprep..."
    & "$env:SystemRoot\System32\Sysprep\Sysprep.exe" /oobe /generalize /shutdown
} catch {
    Write-Log "Error in GoldenImagePrep: $_" "ERROR"
}

Write-Log "=== Golden Image Preparation Completed ==="
