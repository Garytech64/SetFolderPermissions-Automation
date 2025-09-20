<#
.SYNOPSIS
Sets up Active Directory objects.

.DESCRIPTION
- Creates OUs, users, and groups if not already configured
- Assigns users to groups

.RUNON
DC1 (Domain Controller)

.REQUIRES
Domain admin privileges
#>

# ADSetup.ps1
# Run on DC1 as Domain Admin

Import-Module ActiveDirectory

# Create OUs
$OUs = @("Departments", "Clients")
foreach ($ou in $OUs) {
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ou'" -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $ou -ProtectedFromAccidentalDeletion $true
        Write-Host "Created OU: $ou"
    } else {
        Write-Host "OU already exists: $ou"
    }
}

# Create groups
$Groups = @("Finance", "HR", "Sales", "IT", "Workshop", "HSSQ", "Directors", "General")
foreach ($group in $Groups) {
    if (-not (Get-ADGroup -Filter "Name -eq '$group'" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $group -GroupScope Global -Path "OU=Departments,DC=lab,DC=local"
        Write-Host "Created group: $group"
    } else {
        Write-Host "Group already exists: $group"
    }
}

# Create test users and add to groups
$Users = @{
    "jdoe" = "Finance"
    "asmith" = "HR"
    "bwilliams" = "Sales"
}

foreach ($user in $Users.Keys) {
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$user'" -ErrorAction SilentlyContinue)) {
        $pwd = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force
        New-ADUser -Name $user -SamAccountName $user -AccountPassword $pwd -Enabled $true -Path "OU=Departments,DC=lab,DC=local"
        Add-ADGroupMember -Identity $Users[$user] -Members $user
        Write-Host "Created user $user and added to group $($Users[$user])"
    } else {
        Write-Host "User already exists: $user"
    }
}
