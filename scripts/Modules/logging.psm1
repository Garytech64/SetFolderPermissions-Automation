function Write-Log {
    param (
        [string]$Message,
        [string]$Level = "INFO"
    )

    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogLine = "$TimeStamp [$Level] $Message"

    # Write to console
    Write-Host $LogLine

    # Write to log file
    $LogFolder = Join-Path -Path $PSScriptRoot -ChildPath "..\Logs"
    if (!(Test-Path $LogFolder)) { New-Item -Path $LogFolder -ItemType Directory | Out-Null }

    $LogFile = Join-Path -Path $LogFolder -ChildPath "LabSetup.log"
    Add-Content -Path $LogFile -Value $LogLine
}

Export-ModuleMember -Function Write-Log
