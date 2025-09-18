# GoldenImagePrep.ps1
# Run on Windows 10 VM to prepare for golden image

# Clear temp files
Get-ChildItem -Path "C:\Windows\Temp","C:\Users\*\AppData\Local\Temp" -Recurse -Force | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Write-Host "Cleared temporary files"

# Optional: remove old user profiles
Get-CimInstance Win32_UserProfile | Where-Object { $_.Special -eq $false } | Remove-CimInstance
Write-Host "Removed old user profiles"

# Run Sysprep
Write-Host "Running Sysprep..."
Start-Process "C:\Windows\System32\Sysprep\sysprep.exe" -ArgumentList "/oobe /generalize /shutdown" -Wait
Write-Host "Golden image preparation complete. VM is ready for capture."
