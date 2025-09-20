# Quick-Check.ps1
# Run on a freshly cloned VM to verify domain, drives, and basic config

Write-Host "=== Quick Setup Check ===" -ForegroundColor Cyan

# Check Domain Membership
$domain = (Get-ComputerInfo).CsDomain
Write-Host "Domain: $domain"
if ($domain -eq "WORKGROUP") { Write-Warning "This machine is not joined to the domain!" }

# List Local Admins
Write-Host "`nLocal Administrators:"
Get-LocalGroupMember -Group "Administrators" | Select Name, ObjectClass

# List Domain Admins (optional)
Write-Host "`nDomain Admins Group Members:"
Get-ADGroupMember "Domain Admins" | Select Name, SamAccountName

# Check mapped drives
Write-Host "`nMapped Drives:"
Get-PSDrive -PSProvider FileSystem | Select Name, Root

# Test network connectivity
Write-Host "`nPinging DC1..."
Test-Connection -ComputerName DC1 -Count 2

Write-Host "`nCheck complete!" -ForegroundColor Green
