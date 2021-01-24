# Description: Boxstarter Script
# Author: neilkidd
# Bootstrap 7590 laptop - windows 10 pro

# To run
# 1.) Open an elevated PS V3 shell ( https://boxstarter.org/InstallBoxstarter )
# . { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
# 2. Open BoxStarter Shell from the desktop shortcut
# $creds = Get-Credential
# Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/neilkidd/windows-dev-box-setup-scripts/master/machines/7590_bootstrap.ps1 -Credential $creds

Disable-UAC
$ConfirmPreference = "None" #ensure installing powershell modules don't prompt on needed dependencies

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$strpos = $helperUri.LastIndexOf("/machines/")
$helperUri = $helperUri.Substring(0, $strpos)
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	Invoke-Expression ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

# Workaround choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
$chocoCachePath = "$env:TEMP"

if([string]::IsNullOrEmpty($chocoCachePath)) {
    $chocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
}
Write-Host "Using chocoCachePath: $chocoCachePath"

if (-not (Test-Path -LiteralPath $chocoCachePath)) {
    Write-Host "Creating chocoCachePath dir."
    New-Item -Path $chocoCachePath -ItemType Directory -Force
}

#--- Setting up Windows ---
executeScript "FileExplorerSettings.ps1";
executeScript "SystemConfiguration.ps1";
executeScript "RemoveDefaultAppsExceptDell.ps1";

# Install apps
choco upgrade --cacheLocation="$chocoCachePath" --yes git.install --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal /NoAutoCrlf'"

Install-Module -Force posh-git
RefreshEnv

# ORDER MATTERS
# Firefox last - so it becomes the default
choco upgrade --cacheLocation="$chocoCachePath" --yes googlechrome
choco upgrade --cacheLocation="$chocoCachePath" --yes firefox --package-parameters="'/l=en-GB /RemoveDistributionDir'"

# Always required!
choco upgrade --cacheLocation="$chocoCachePath" --yes git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal /NoAutoCrlf'"

# Larger apps needing restarts speed up the process
choco upgrade --cacheLocation="$chocoCachePath" --yes sql-server-management-studio
# VS 2019 packages: https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community?view=vs-2019
choco upgrade --cacheLocation="$chocoCachePath" --yes visualstudio2019community --package-parameters "--add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.Data -add Microsoft.VisualStudio.Workload.NetCoreTools --passive --locale en-US"

choco upgrade --cacheLocation="$chocoCachePath" --yes chocolateygui
choco upgrade --cacheLocation="$chocoCachePath" --yes 7zip.install
choco upgrade --cacheLocation="$chocoCachePath" --yes libreoffice-fresh
choco upgrade --cacheLocation="$chocoCachePath" --yes gimp
choco upgrade --cacheLocation="$chocoCachePath" --yes bitwarden
# choco upgrade --cacheLocation="$chocoCachePath" --yes potplayer
choco upgrade --cacheLocation="$chocoCachePath" --yes synctrayzor
choco upgrade --cacheLocation="$chocoCachePath" --yes joplin
choco upgrade --cacheLocation="$chocoCachePath" --yes slack
choco upgrade --cacheLocation="$chocoCachePath" --yes zoom
choco upgrade --cacheLocation="$chocoCachePath" --yes microsoft-teams.install
choco upgrade --cacheLocation="$chocoCachePath" --yes authy-desktop
choco upgrade --cacheLocation="$chocoCachePath" --yes dropbox
choco upgrade --cacheLocation="$chocoCachePath" --yes dbeaver
choco upgrade --cacheLocation="$chocoCachePath" --yes postman
choco upgrade --cacheLocation="$chocoCachePath" --yes vscode.install
choco upgrade --cacheLocation="$chocoCachePath" --yes jetbrainstoolbox

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
choco pin add -n=libreoffice-fresh
choco pin add -n="microsoft-teams.install"
choco pin add -n=postman
#choco pin add -n=potplayer
choco pin add -n=slack
choco pin add -n=synctrayzor
choco pin add -n=visualstudio2019community
choco pin add -n="vscode.install"
choco pin add -n=zoom

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula

###############################################################################
# TODO Manually
#
# WSL2 - Breaks when scripted
# Manual steps work fine
# https://docs.microsoft.com/en-us/windows/wsl/install-win10
#
# Docker Desktop
# https://www.docker.com/products/docker-desktop
#
# Windows Terminal (from Windows Store)
# Using the choco package means the latest releases lag and is 'orphaned' from
# the store releases.
#
###############################################################################
