<#
.SYNOPSIS
Configures domain-joined client machines.

.DESCRIPTION
- Maps network drives for each department
- Applies client configurations as needed (example: joining policies, scripts)
- Can be used to customize client setup beyond GPOs

.RUNON
Client machines

.REQUIRES
Domain user with appropriate rights
#>

# ClientSetup.ps1
# Run on domain-joined clients

$FS1 = "\\FS1"

$Departments = @("Finance","HR","Sales","IT","Workshop","HSSQ","Directors","General")

foreach ($dept in $Departments) {
    $DriveLetter = ($dept.Substring(0,1) + ":") # F: for Finance, H: for HR, etc.
    if (-not (Test-Path $DriveLetter)) {
        New-PSDrive -Name $DriveLetter.TrimEnd(":") -PSProvider FileSystem -Root "$FS1\$dept" -Persist
        Write-Host "Mapped $DriveLetter to $FS1\$dept"
    } else {
        Write-Host "Drive $DriveLetter already exists"
    }
}
