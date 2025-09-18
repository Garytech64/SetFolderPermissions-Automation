# ClientSetup.ps1
$BasePath = "\\FS1\Advanced Shared Folder"

$Drives = @{
    "Finance" = "F:"
    "HR"      = "H:"
    "Sales"   = "S:"
    "IT"      = "I:"
}

foreach ($Dept in $Drives.Keys) {
    $DriveLetter = $Drives[$Dept]
    if (!(Test-Path $DriveLetter)) {
        New-PSDrive -Name $DriveLetter.TrimEnd(":") -PSProvider FileSystem -Root "$BasePath\$Dept" -Persist
        Write-Output "Mapped $Dept to $DriveLetter"
    }
}
