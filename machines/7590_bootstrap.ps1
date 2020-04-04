# Description: Boxstarter Script
# Author: neilkidd
# Bootstrap 7590 laptop - windows 10 pro

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

# https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
# executeScript "HyperV.ps1";
RefreshEnv

# command line dev tools
choco upgrade --cacheLocation="$chocoCachePath" --yes ag # ag is (grep || ack) on steroids
choco upgrade --cacheLocation="$chocoCachePath" --yes jq
choco upgrade --cacheLocation="$chocoCachePath" --yes curl
choco upgrade --cacheLocation="$chocoCachePath" --yes wget
choco upgrade --cacheLocation="$chocoCachePath" --yes vim
choco upgrade --cacheLocation="$chocoCachePath" --yes git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal /NoAutoCrlf'"
choco upgrade --cacheLocation="$chocoCachePath" --yes terraform
choco upgrade --cacheLocation="$chocoCachePath" --yes tflint
choco upgrade --cacheLocation="$chocoCachePath" --yes packer
choco upgrade --cacheLocation="$chocoCachePath" --yes bitwarden-cli
choco upgrade --cacheLocation="$chocoCachePath" --yes adoptopenjdk8
choco upgrade --cacheLocation="$chocoCachePath" --yes microsoft-windows-terminal
## JS tooling
choco upgrade --cacheLocation="$chocoCachePath" --yes nvm

Install-Module -Force posh-git #for powershell integration
RefreshEnv

# Browsers
choco upgrade --cacheLocation="$chocoCachePath" --yes Firefox --package-parameters="'l=en-GB'"
# Chrome last - ideally this is the default for work as we use gsuite.
choco upgrade --cacheLocation="$chocoCachePath" --yes googlechrome
# end browsers

# productivity tools
choco upgrade --cacheLocation="$chocoCachePath" --yes jetbrainstoolbox
choco upgrade --cacheLocation="$chocoCachePath" --yes 7zip.install
choco upgrade --cacheLocation="$chocoCachePath" --yes sysinternals
choco upgrade --cacheLocation="$chocoCachePath" --yes vscode
choco upgrade --cacheLocation="$chocoCachePath" --yes libreoffice-still
choco upgrade --cacheLocation="$chocoCachePath" --yes f.lux.install
choco upgrade --cacheLocation="$chocoCachePath" --yes cutepdf
choco upgrade --cacheLocation="$chocoCachePath" --yes gimp
choco upgrade --cacheLocation="$chocoCachePath" --yes potplayer #Could have been vlc?
choco upgrade --cacheLocation="$chocoCachePath" --yes dropbox
choco upgrade --cacheLocation="$chocoCachePath" --yes speccy
choco upgrade --cacheLocation="$chocoCachePath" --yes virtualclonedrive
choco upgrade --cacheLocation="$chocoCachePath" --yes virtualbox
choco upgrade --cacheLocation="$chocoCachePath" --yes slack
choco upgrade --cacheLocation="$chocoCachePath" --yes bitwarden
choco upgrade --cacheLocation="$chocoCachePath" --yes chocolateygui
choco upgrade --cacheLocation="$chocoCachePath" --yes joplin
choco upgrade --cacheLocation="$chocoCachePath" --yes microsoft-teams.install
choco upgrade --cacheLocation="$chocoCachePath" --yes zoom

choco upgrade --cacheLocation="$chocoCachePath" --yes sql-server-management-studio
# VS 2019 packages: https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community?view=vs-2019
choco upgrade --cacheLocation="$chocoCachePath" --yes visualstudio2019community --package-parameters "--add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.Data -add Microsoft.VisualStudio.Workload.NetCoreTools --passive --locale en-US"

# pin self updating apps, so we can easily run 'choco upgrade all'
# https://github.com/chocolatey/choco/wiki/CommandsPin
choco pin add -n=Firefox
choco pin add -n=googlechrome
choco pin add -n=jetbrainstoolbox
choco pin add -n=microsoft-teams.install
choco pin add -n=visualstudio2019community
choco pin add -n=slack

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
