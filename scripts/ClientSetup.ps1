<#
.SYNOPSIS
Configures domain-joined client machines.

.DESCRIPTION
- Maps network drives
- Applies optional client configuration (policies, scripts)

.RUNON
Domain clients

.REQUIRES
Domain user with appropriate rights
#>

Import-Module "$PSScriptRoot\..\Modules\Logging.psm1"

Write-Log "=== ClientSetup Script Started ==="

try {
    # Example mapped drives
    $DriveMappings = @{
        "F:" = "\\FS1\Finance"
        "H:" = "\\FS1\HR"
        "S:" = "\\FS1\Sales"
    }

    foreach ($Drive in $DriveMappings.Keys) {
        try {
            if (-not (Get-PSDrive -Name $Drive.TrimEnd(':') -ErrorAction SilentlyContinue)) {
                New-PSDrive -Name $Drive.TrimEnd(':') -PSProvider FileSystem -Root $DriveMappings[$Drive] -Persist
                Write-Log "Mapped drive $Drive to $($DriveMappings[$Drive])"
            } else {
                Write-Log "Drive $Drive already mapped" "INFO"
            }
        } catch {
            Write-Log "Failed to map $Drive" "WARNING"
        }
    }
} catch {
    Write-Log "Error in ClientSetup: $_" "ERROR"
}

Write-Log "=== ClientSetup Script Completed ==="
