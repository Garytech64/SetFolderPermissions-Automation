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
- Cleans temp files and old user profiles  
- **Run on:** Windows 10 VM  
- **Requires:** Local admin privileges  

---

## Lab Configuration

- LabConfigs/GoldenImageSettings/ – Placeholder for settings related to Windows 10 golden image  
- .gitkeep file ensures the folder is tracked in Git  
- Logs/ folder can be used to store script execution logs  

---

## Step-by-Step Run Sequence

Follow this order to build and configure your lab environment:

1. **Prepare Active Directory (optional)**  
   On **DC1 (Domain Controller):**  
   `powershell
   .\Scripts\ADSetup.ps1
Creates OUs, groups, and users if not already configured.

Configure File Server
On FS1 (File Server):

powershell
Copy code
.\Scripts\SetFolderPermissions.ps1
Creates departmental and manager folders and sets NTFS permissions.

Configure Clients (optional)
On Windows 10 clients:

powershell
Copy code
.\Scripts\ClientSetup.ps1
Maps drives and applies domain client configurations.

Prepare Golden Image (optional)
On Windows 10 VM (before cloning):

powershell
Copy code
.\Scripts\GoldenImagePrep.ps1
Cleans up the VM and runs Sysprep (generalize + shutdown) so the VM can be used as a reusable golden image.

✅ After following these steps, your lab will have:

A domain controller with users and groups

A file server with properly secured folders

Clients with mapped drives

A Windows 10 golden image ready for deployment
