<#
.SYNOPSIS
Creates AD objects (OUs, users, groups) and assigns users to groups.

.RUNON
DC1 (Domain Controller)

.REQUIRES
Domain admin privileges
#>

Import-Module "$PSScriptRoot\..\Modules\Logging.psm1"

Write-Log "=== ADSetup Script Started ==="

try {
    # Example OU and group creation
    $OUs = @("Departments/Finance", "Departments/HR", "Departments/IT")
    foreach ($OU in $OUs) {
        if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$OU'" -ErrorAction SilentlyContinue)) {
            New-ADOrganizationalUnit -Name ($OU.Split('/')[-1]) -Path ($OU.Split('/')[0])
            Write-Log "Created OU: $OU"
        }
    }

    $Groups = @("Finance-Users","HR-Users","IT-Users")
    foreach ($Grp in $Groups) {
        if (-not (Get-ADGroup -Identity $Grp -ErrorAction SilentlyContinue)) {
            New-ADGroup -Name $Grp -GroupScope Global -Path "OU=Departments,DC=grytechnical,DC=local"
            Write-Log "Created group: $Grp"
        }
    }

    # Example: assign a user to a group
    Add-ADGroupMember -Identity "Finance-Users" -Members "GaryAdmin"
    Write-Log "Added GaryAdmin to Finance-Users"
} catch {
    Write-Log "Error in ADSetup: $_" "ERROR"
}

Write-Log "=== ADSetup Script Completed ==="
