# Description: Boxstarter Script
# Author: neilkidd
# Bootstrap 7590 laptop - windows 11 Pro (International)

# To run
# 1.) Open an elevated PS shell ( https://boxstarter.org/installboxstarter#installing-from-the-web )
# Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); Get-Boxstarter -Force
# 2. Open BoxStarter Shell from the desktop shortcut
# $creds = Get-Credential
# Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/neilkidd/windows-dev-box-setup-scripts/master/7590_win11_bootstrap.ps1 -Credential $creds

Disable-UAC
$ConfirmPreference = "None" #ensure installing powershell modules don't prompt on needed dependencies

# https://boxstarter.org/winconfig#set-windowsexploreroptions
# Show hidden files, Show protected OS files, Show file extensions
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

# https://ccmexec.com/2021/10/modifying-windows-11-start-button-location-and-taskbar-icons-during-osd-autopilot/
# Send the task bar to the ruddy left
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarAl -Type DWord -Value 0
# Set Task bar to smallest icons
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarSi -Value 0
# Auto hide the taskbar
$StuckRects3Path = 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
$RegValues = (Get-ItemProperty -Path $StuckRects3Path).Settings
$RegValues[8] = 3
Set-ItemProperty -Path $StuckRects3Path -Name Settings -Value $RegValues

# TRY LATER #--- File Explorer Settings ---
#
# will expand explorer to the actual folder you're in
# Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1
#adds things back in your left pane like recycle bin
# Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1
#opens PC to This PC, not quick access
# Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
#taskbar where window is open for multi-monitor
# Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2

#######################################################################################################################
# Install apps

# ORDER MATTERS
# Firefox last - so it becomes the default
choco upgrade --yes googlechrome --ignore-checksums # A risk, but see the choco site
choco upgrade --yes firefox --package-parameters="'/l=en-GB /RemoveDistributionDir'" --ignore-checksums # A risk, but see the choco site

# Might not be required yet - I want to validate what comes with VS first
choco upgrade --yes git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal /NoAutoCrlf'"

# Larger apps needing restarts speed up the process
choco upgrade --yes sql-server-management-studio

# vs 2022 packages: https://learn.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community?view=vs-2022
choco upgrade --yes visualstudio2022community --package-parameters="'--add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.Data --add Microsoft.VisualStudio.Workload.NetCrossPlat --add Microsoft.VisualStudio.Workload.Node --passive --locale en-US'"

choco upgrade --yes 7zip
choco upgrade --yes authy-desktop
choco upgrade --yes bitwarden
choco upgrade --yes chocolateygui
choco upgrade --yes dbeaver
choco upgrade --yes dropbox
choco upgrade --yes gimp
choco upgrade --yes jetbrainstoolbox
choco upgrade --yes joplin
choco upgrade --yes libreoffice-still
choco upgrade --yes riot
choco upgrade --yes slack
choco upgrade --yes vscode

# Deffered for now
#choco upgrade --yes synctrayzor
#choco upgrade --yes zoom
#choco upgrade --yes microsoft-teams.install
#choco upgrade --yes postman
#choco upgrade --yes f.lux.install

# pin self updating apps
# https://github.com/chocolatey/choco/wiki/CommandsPin
# To update all others, run 'choco upgrade all' from an elevated PS shell
# or use Chocolatey Gui
choco pin add -n=authy-desktop
choco pin add -n=bitwarden
choco pin add -n=dbeaver
choco pin add -n=dropbox
choco pin add -n=Firefox
choco pin add -n=GoogleChrome
choco pin add -n=jetbrainstoolbox
choco pin add -n=joplin
choco pin add -n=libreoffice-still
choco pin add -n=slack
choco pin add -n=visualstudio2022community
choco pin add -n=vscode

# Deferred for now
#choco pin add -n="f.lux.install"
#choco pin add -n="microsoft-teams.install"
#choco pin add -n=postman
#choco pin add -n=potplayer
#choco pin add -n=synctrayzor
#choco pin add -n=zoom

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
