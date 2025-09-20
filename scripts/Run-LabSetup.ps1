# Run-LabSetup.ps1
# Master script to run lab setup scripts in order with logging

# Import logging module
Import-Module "$PSScriptRoot\Modules\Logging.psm1"

# Initialize log file (timestamped)
$LogFile = "$PSScriptRoot\..\Logs\LabSetup_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').log"

Write-Log "=== Lab Setup Started ===" "INFO" $LogFile

# 1. Active Directory setup (optional)
if (Test-Path "$PSScriptRoot\ADSetup.ps1") {
    Write-Log "Starting ADSetup.ps1..." "INFO" $LogFile
    try {
        & "$PSScriptRoot\ADSetup.ps1"
        Write-Log "ADSetup.ps1 completed successfully." "INFO" $LogFile
    } catch {
        Write-Log "ADSetup.ps1 failed: $_" "ERROR" $LogFile
    }
}

# 2. File Server folder creation and permissions
if (Test-Path "$PSScriptRoot\SetFolderPermissions.ps1") {
    Write-Log "Starting SetFolderPermissions.ps1..." "INFO" $LogFile
    try {
        & "$PSScriptRoot\SetFolderPermissions.ps1"
        Write-Log "SetFolderPermissions.ps1 completed successfully." "INFO" $LogFile
    } catch {
        Write-Log "SetFolderPermissions.ps1 failed: $_" "ERROR" $LogFile
    }
}

# 3. Client configuration (optional)
if (Test-Path "$PSScriptRoot\ClientSetup.ps1") {
    Write-Log "Starting ClientSetup.ps1..." "INFO" $LogFile
    try {
        & "$PSScriptRoot\ClientSetup.ps1"
        Write-Log "ClientSetup.ps1 completed successfully." "INFO" $LogFile
    } catch {
        Write-Log "ClientSetup.ps1 failed: $_" "ERROR" $LogFile
    }
}

# 4. Golden image preparation (optional)
if (Test-Path "$PSScriptRoot\GoldenImagePrep.ps1") {
    Write-Log "Starting GoldenImagePrep.ps1..." "INFO" $LogFile
    try {
        & "$PSScriptRoot\GoldenImagePrep.ps1"
        Write-Log "GoldenImagePrep.ps1 completed successfully." "INFO" $LogFile
    } catch {
        Write-Log "GoldenImagePrep.ps1 failed: $_" "ERROR" $LogFile
    }
}

Write-Log "=== Lab Setup Completed ===" "INFO" $LogFile
