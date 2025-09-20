<#
.SYNOPSIS
Prepares a Windows 10 VM for golden image creation.

.DESCRIPTION
- Cleans temp files and old user profiles
- Clears logs, prefetch, and other system traces
- Runs Sysprep with generalize and shutdown options

.RUNON
Windows 10 VM

.REQUIRES
Local admin privileges
#>

# GoldenImagePrep.ps1
# Cleans up Windows 10 before running Sysprep for golden image creation

Write-Host "=== Golden Image Preparation Started ===" -ForegroundColor Cyan

# 1. Remove domain membership reminder
Write-Host "[INFO] Ensure this VM has been removed from the domain and joined to WORKGROUP." -ForegroundColor Yellow

# 2. Delete all user profiles except Administrator & Public
Write-Host "[STEP] Cleaning up user profiles..." -ForegroundColor Green
Get-WmiObject Win32_UserProfile | Where-Object {
    $_.LocalPath -notlike "C:\Users\Administrator*" -and
    $_.LocalPath -notlike "C:\Users\Public"
} | ForEach-Object {
    try {
        $_.Delete()
        Write-Host "Deleted profile: $($_.LocalPath)" -ForegroundColor DarkGray
    } catch {
        Write-Warning "Failed to delete profile: $($_.LocalPath)"
    }
}

# 3. Clear temp files
Write-Host "[STEP] Clearing temp files..." -ForegroundColor Green
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

# 4. Clear event logs
Write-Host "[STEP] Clearing event logs..." -ForegroundColor Green
wevtutil el | ForEach-Object { wevtutil cl $_ }

# 5. Clean Windows Update cache
Write-Host "[STEP] Cleaning Windows Update cache..." -ForegroundColor Green
Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service -Name wuauserv -ErrorAction SilentlyContinue

# 6. Clear Prefetch and Recycle Bin
Write-Host "[STEP] Clearing Prefetch and Recycle Bin..." -ForegroundColor Green
Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

# 7. Run Sysprep
Write-Host "[FINAL STEP] Running Sysprep..." -ForegroundColor Cyan
& "$env:SystemRoot\System32\Sysprep\Sysprep.exe" /oobe /generalize /shutdown

Write-Host "=== Golden Image Preparation Completed ===" -ForegroundColor Cyan
