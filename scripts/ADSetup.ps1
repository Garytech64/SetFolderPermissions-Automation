# ADSetup.ps1
Import-Module ActiveDirectory

$Groups = @("Finance", "HR", "Sales", "IT")
foreach ($Group in $Groups) {
    if (-not (Get-ADGroup -Filter "Name -eq '$Group'" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $Group -GroupScope Global
        Write-Output "Created group $Group"
    }
}

$Users = @(
    @{Name="Alice"; Dept="Finance"},
    @{Name="Bob"; Dept="HR"},
    @{Name="Charlie"; Dept="Sales"}
)

foreach ($User in $Users) {
    if (-not (Get-ADUser -Identity $User.Name -ErrorAction SilentlyContinue)) {
        New-ADUser -Name $User.Name -SamAccountName $User.Name `
            -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) `
            -Enabled $true
        Add-ADGroupMember -Identity $User.Dept -Members $User.Name
        Write-Output "Created user $($User.Name) in $($User.Dept)"
    }
}
