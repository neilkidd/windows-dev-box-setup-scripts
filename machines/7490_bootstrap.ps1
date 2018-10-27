# Description: Boxstarter Script
# Author: neilkidd
# Bootstrap 7490 laptop - windows 10, full .net dev env

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

#--- Setting up Windows ---
executeScript "FileExplorerSettings.ps1";
executeScript "SystemConfiguration.ps1";
executeScript "RemoveDefaultAppsExceptDell.ps1";

# Browsers
choco upgrade --yes googlechrome

choco upgrade --yes Firefox --package-parameters="'l=en-GB'"

choco upgrade --yes lastpass
# end browsers

# productivity tools
choco upgrade --yes f.lux.install
choco upgrade --yes 7zip.install
choco upgrade --yes libreoffice-still
choco upgrade --yes sumatrapdf.install
choco upgrade --yes cutepdf
choco upgrade --yes imgburn
choco upgrade --yes paint.net
choco upgrade --yes potplayer #Could have been vlc?
choco upgrade --yes rufus
choco upgrade --yes handbrake.install
choco upgrade --yes chocolateygui
choco upgrade --yes dropbox
choco upgrade --yes speccy

executeScript "HyperV.ps1";
RefreshEnv

# command line dev tools
choco upgrade --yes ag # ag is (grep || ack) on steroids
choco upgrade --yes jq

choco upgrade --yes powershell-core
choco upgrade --yes azure-cli
Install-Module -Force Az
choco upgrade --yes microsoftazurestorageexplorer

Install-Module -Force posh-git #for powershell integration

choco upgrade --yes terraform
choco upgrade --yes packer
# choco upgrade --yes vagrant - never completes :(
choco upgrade --yes cmder
RefreshEnv

# UI tools
choco upgrade --yes sysinternals
choco upgrade --yes vscode
choco upgrade --yes virtualbox

#--- Tools ---
#--- Installing VS and VS Code with Git
# See this for install args: https://chocolatey.org/packages/VisualStudio2017Community
# https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community
# https://docs.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio#list-of-workload-ids-and-component-ids
# visualstudio2017community
# visualstudio2017professional
# visualstudio2017enterprise

# For full install use: choco upgrade --yes visualstudio2017community --package-parameters "'--allWorkloads --includeRecommended --includeOptional --passive --locale en-US'"

# next line will do a full install. Beware: 22.64GB and 820 packages and timesout (2018-10-23)
#choco install --yes visualstudio2017community --package-parameters="'--add Microsoft.VisualStudio.Component.Git --allWorkloads --includeRecommended --includeOptional --passive --locale en-US'"

choco upgrade --yes visualstudio2017community --package-parameters="'--add Microsoft.VisualStudio.Component.Git'"
Update-SessionEnvironment #refreshing env due to Git install
# See https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community?view=vs-2017
choco upgrade --yes visualstudio2017-workload-azure 
choco upgrade --yes visualstudio2017-workload-data
choco upgrade --yes visualstudio2017-workload-manageddesktop
choco upgrade --yes visualstudio2017-workload-netcoretools
choco upgrade --yes visualstudio2017-workload-netweb 

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
