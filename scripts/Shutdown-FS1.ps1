<#
.SYNOPSIS
    Shuts down FS1 safely.

.DESCRIPTION
    This script initiates a clean shutdown of the FS1 file server.
    Can be run locally or remotely with proper permissions.

.RUNON
    FS1 (File Server)

.REQUIRES
    Domain admin privileges
#>

Write-Host "Shutting down FS1..." -ForegroundColor Cyan

# Optional: warn users logged in before shutdown
msg * "FS1 will shut down in 1 minute. Please save your work."

# Wait 60 seconds to give users time
Start-Sleep -Seconds 60

# Initiate shutdown
Stop-Computer -ComputerName localhost -Force
