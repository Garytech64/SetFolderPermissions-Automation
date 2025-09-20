# SetFolderPermissions-Automation

This project contains PowerShell scripts for automating folder creation, NTFS permissions, Active Directory setup, client configuration, and Windows 10 golden image preparation in a Windows domain environment. All scripts now use a centralized **logging module** (Modules\Logging.psm1) for consistent logging and error handling.

---

## Project Structure

SetFolderPermissions-Automation/
│
├─ Scripts/
│ ├─ SetFolderPermissions.ps1 # Creates department and manager folders with NTFS permissions
│ ├─ ClientSetup.ps1 # Configures domain clients (optional)
│ ├─ ADSetup.ps1 # Configures Active Directory (optional)
│ ├─ GoldenImagePrep.ps1 # Prepares Windows 10 VM for golden image
│ ├─ QuickCheck.ps1 # Optional script to verify environment setup
│
├─ Modules/
│ └─ Logging.psm1 # Centralized logging module for all scripts
│
├─ LabConfigs/
│ └─ GoldenImageSettings/ # Placeholder folder for golden image configuration files (.gitkeep)
│
├─ Logs/ # Folder for script execution logs
├─ README.md
└─ .gitignore

markdown
Copy code

---

## Scripts

### SetFolderPermissions.ps1
- Creates department folders (Finance, HR, Sales, IT, Workshop, HSSQ, Directors, General)
- Creates subfolders for Managers
- Sets NTFS permissions for each department and manager group
- Verifies and audits permissions after setup
- **Run on:** FS1 (file server)
- **Requires:** Domain admin privileges

### ClientSetup.ps1 (Optional)
- Maps network drives for each department
- Configures domain-joined client machines
- **Run on:** Client machines
- **Requires:** Domain user with appropriate rights

### ADSetup.ps1 (Optional)
- Creates Active Directory objects (OUs, users, groups)
- Assigns users to groups
- **Run on:** DC1 (domain controller)
- **Requires:** Domain admin privileges

### GoldenImagePrep.ps1
- Cleans up user profiles, temp files, event logs, prefetch, and Recycle Bin
- Runs Sysprep with /generalize /oobe /shutdown options
- **Run on:** Windows 10 VM (before creating golden image)
- **Requires:** Local admin privileges

### QuickCheck.ps1 (Optional)
- Verifies that folder structures, NTFS permissions, and client configurations are applied correctly
- **Run on:** FS1 or client machines
- **Requires:** Domain admin or domain user depending on checks

---

## Lab Configuration

- LabConfigs/GoldenImageSettings/ – Placeholder for Windows 10 golden image configuration
- .gitkeep ensures the folder is tracked in Git
- Logs/ stores script execution logs

---

## Usage

1. **Clone the repository:**

`powershell
git clone https://github.com/Garytech64/SetFolderPermissions-Automation.git
cd SetFolderPermissions-Automation
Run scripts in order:

On DC1 (optional):

powershell
Copy code
.\Scripts\ADSetup.ps1
On FS1:

powershell
Copy code
.\Scripts\SetFolderPermissions.ps1
On client machines (optional):

powershell
Copy code
.\Scripts\ClientSetup.ps1
On Windows 10 VM for golden image (optional):

powershell
Copy code
.\Scripts\GoldenImagePrep.ps1
Verify setup (optional):

powershell
Copy code
.\Scripts\QuickCheck.ps1
⚠️ Ensure Modules\Logging.psm1 exists in the Modules folder before running any scripts.

Notes
All scripts now include logging via Logging.psm1. Logs are written to the Logs folder by default.

Optional scripts are provided for convenience; GPOs may already handle some tasks such as mapped drives.

Before running GoldenImagePrep.ps1, ensure the VM is removed from the domain and joined to a WORKGROUP.
