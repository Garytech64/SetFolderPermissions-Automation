<#
.SYNOPSIS
Creates department and manager folders with NTFS permissions.

.DESCRIPTION
- Creates department folders: Finance, HR, Sales, IT, Workshop, HSSQ, Directors, General
- Creates subfolders for Managers
- Sets NTFS permissions for each department and manager group
- Verifies and audits permissions after setup

.RUNON
FS1 (File Server)

.REQUIRES
Domain admin privileges
#>

# SetFolderPermissions.ps1
# ==========================
# Script to set NTFS permissions on departmental folders
# Run as Domain Admin

# Exit if not run as Domain Admin
if (-not (whoami /groups | Select-String "Domain Admins")) {
    Write-Error "This script must be run as a Domain/Admin user. Exiting."
    exit 1
}

$SharePath = "E:\Advanced Shared Folder"

# Departments with Managers subfolder
$DepartmentsWithManagers = @("Finance","HR","Sales","Workshop","HSSQ","IT")

# Special folders with no Managers subfolder
$FoldersNoManager = @("Directors","General")

function Log($msg) {
    Write-Host $msg
}

# ===============================
# Department Folders
# ===============================
foreach ($Dept in $DepartmentsWithManagers) {
    $DeptPath = Join-Path $SharePath $Dept
    $MgrPath  = Join-Path $DeptPath "Managers"

    if (Test-Path $DeptPath) {
        Log "Folder exists: $DeptPath"
        icacls $DeptPath /inheritance:d | Out-Null
        icacls $DeptPath /grant "SYSTEM:(OI)(CI)F" `
                           /grant "Domain Admins:(OI)(CI)F" `
                           /grant "GRYTECHNICAL\${Dept}:(OI)(CI)M" | Out-Null
        icacls $DeptPath /grant "GRYTECHNICAL\${Dept} Managers:(OI)(CI)F" | Out-Null
    }

    if (Test-Path $MgrPath) {
        Log "Managers folder exists: $MgrPath"
        icacls $MgrPath /inheritance:d | Out-Null
        icacls $MgrPath /grant "SYSTEM:(OI)(CI)F" `
                           /grant "Domain Admins:(OI)(CI)F" `
                           /grant "GRYTECHNICAL\${Dept}:(OI)(CI)M" | Out-Null
        icacls $MgrPath /grant "GRYTECHNICAL\${Dept} Managers:(OI)(CI)F" | Out-Null
    }
}

# ===============================
# Special Folders (no Managers subfolder)
# ===============================
foreach ($Folder in $FoldersNoManager) {
    $FolderPath = Join-Path $SharePath $Folder

    if (Test-Path $FolderPath) {
        Log "Folder exists: $FolderPath"
        icacls $FolderPath /inheritance:d | Out-Null
        icacls $FolderPath /grant "SYSTEM:(OI)(CI)F" `
                           /grant "Domain Admins:(OI)(CI)F" `
                           /grant "GRYTECHNICAL\${Folder}:(OI)(CI)F" | Out-Null
    }
}

# ===============================
# Verify permissions
# ===============================
Write-Host "=== Verification / Audit Start ==="
foreach ($Path in (Get-ChildItem $SharePath -Directory)) {
    icacls $Path.FullName
}
# === Verification / Audit Complete ===
Write-Host ""
Write-Host "=== Script completed. Summary ===" -ForegroundColor Green

# Optional: add a small pause to let the output finish scrolling
Start-Sleep -Seconds 2
