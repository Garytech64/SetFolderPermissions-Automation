# Logging.psm1

param (
    [string]$LogFolder = "$PSScriptRoot\..\..\Logs"
)

# Ensure log folder exists
if (-not (Test-Path $LogFolder)) {
    New-Item -Path $LogFolder -ItemType Directory | Out-Null
}

# Write-Log function
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp [$Level] $Message"

    # Log to console
    Write-Host $logMessage

    # Log to file
    $logFile = Join-Path $LogFolder "$(Get-Date -Format 'yyyyMMdd').log"
    Add-Content -Path $logFile -Value $logMessage
}

Export-ModuleMember -Function Write-Log
