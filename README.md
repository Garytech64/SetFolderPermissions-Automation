# SetFolderPermissions-Automation

## Project Structure

SetFolderPermissions-Automation/
│
├─ Scripts/
│ ├─ SetFolderPermissions.ps1 # Creates department and manager folders with NTFS permissions
│ ├─ ClientSetup.ps1 # Configures domain clients (optional)
│ ├─ ADSetup.ps1 # Configures Active Directory (optional)
│ ├─ GoldenImagePrep.ps1 # Prepares Windows 10 VM for golden image
│
├─ LabConfigs/
│ └─ GoldenImageSettings/ # Placeholder folder for golden image configuration files (.gitkeep)
│
├─ Logs/ # Placeholder for log files (if needed)
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

### ClientSetup.ps1
- Maps network drives for each department
- Configures domain-joined client machines (example: joining policies, mapped drives)
- **Run on:** Client machines
- **Requires:** Domain user with appropriate rights

### ADSetup.ps1
- Optionally sets up Active Directory objects (OUs, users, groups)
- Assigns users to groups
- **Run on:** DC1 (domain controller)
- **Requires:** Domain admin privileges

### GoldenImagePrep.ps1
- Prepares a Windows 10 VM for golden image creation
- Clears temp files and old user profiles
- Runs Sysprep with generalize and shutdown options
- **Run on:** Windows 10 VM
- **Requires:** Local admin privileges

---

## Lab Configuration

- LabConfigs/GoldenImageSettings/ – Placeholder for settings related to Windows 10 golden image
- .gitkeep file ensures the folder is tracked in Git
- Logs/ folder can be used to store script execution logs

---

## Usage

### Clone the repository
`powershell
git clone https://github.com/Garytech64/SetFolderPermissions-Automation.git
cd SetFolderPermissions-Automation
Run scripts in order
On DC1 (optional)
powershell
Copy code
.\Scripts\ADSetup.ps1
On FS1
powershell
Copy code
.\Scripts\SetFolderPermissions.ps1
On client machines (optional)
powershell
Copy code
.\Scripts\ClientSetup.ps1
On Windows 10 VM for golden image (optional)
powershell
Copy code
.\Scripts\GoldenImagePrep.ps1
