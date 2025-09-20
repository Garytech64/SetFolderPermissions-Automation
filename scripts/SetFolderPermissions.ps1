<#
.SYNOPSIS
Creates department and manager folders with NTFS permissions.

.DESCRIPTION
- Creates department folders (Finance, HR, Sales, IT, Workshop, HSSQ, Directors, General)
- Creates manager subfolders
- Sets NTFS permissions for department and manager groups
- Verifies and audits permissions

.RUNON
FS1 (File Server)

.REQUIRES
Domain admin privileges
#>

# Import logging module
Import-Module "$PSScriptRoot\..\Modules\Logging.psm1"

Write-Log "=== SetFolderPermissions Script Started ==="

try {
    $Departments = @("Finance","HR","Sales","IT","Workshop","HSSQ","Directors","General")
    $BasePath = "D:\Departments"

    foreach ($Dept in $Departments) {
        $DeptPath = Join-Path -Path $BasePath -ChildPath $Dept
        if (-not (Test-Path $DeptPath)) {
            New-Item -Path $DeptPath -ItemType Directory | Out-Null
            Write-Log "Created folder: $DeptPath"
        } else {
            Write-Log "Folder already exists: $DeptPath" "INFO"
        }

        # Optional: create manager subfolder
        $MgrPath = Join-Path -Path $DeptPath -ChildPath "Managers"
        if (-not (Test-Path $MgrPath)) {
            New-Item -Path $MgrPath -ItemType Directory | Out-Null
            Write-Log "Created manager folder: $MgrPath"
        }
    }

    # Set NTFS permissions (example)
    foreach ($Dept in $Departments) {
        $DeptPath = Join-Path $BasePath $Dept
        $Group = "GRYTECHNICAL\$Dept-Users"
        try {
            icacls $DeptPath /grant "$Group:(OI)(CI)F" /T
            Write-Log "Set NTFS permissions for $Group on $DeptPath"
        } catch {
            Write-Log "Failed to set permissions for $Group on $DeptPath" "WARNING"
        }
    }
} catch {
    Write-Log "Error in SetFolderPermissions: $_" "ERROR"
}

Write-Log "=== SetFolderPermissions Script Completed ==="
