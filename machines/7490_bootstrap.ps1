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

# Workaround choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force

#--- Setting up Windows ---
executeScript "FileExplorerSettings.ps1";
executeScript "SystemConfiguration.ps1";
executeScript "RemoveDefaultAppsExceptDell.ps1";

# Browsers
choco upgrade --cacheLocation="$ChocoCachePath" --yes googlechrome

choco upgrade --cacheLocation="$ChocoCachePath" --yes Firefox --package-parameters="'l=en-GB'"

choco upgrade --cacheLocation="$ChocoCachePath" --yes lastpass
# end browsers

# productivity tools
choco upgrade --cacheLocation="$ChocoCachePath"--yes f.lux.install
choco upgrade --cacheLocation="$ChocoCachePath" --yes 7zip.install
choco upgrade --cacheLocation="$ChocoCachePath" --yes libreoffice-still
choco upgrade --cacheLocation="$ChocoCachePath" --yes sumatrapdf.install
choco upgrade --cacheLocation="$ChocoCachePath" --yes cutepdf
choco upgrade --cacheLocation="$ChocoCachePath" --yes imgburn
choco upgrade --cacheLocation="$ChocoCachePath" --yes paint.net
choco upgrade --cacheLocation="$ChocoCachePath" --yes potplayer #Could have been vlc?
choco upgrade --cacheLocation="$ChocoCachePath" --yes rufus
choco upgrade --cacheLocation="$ChocoCachePath" --yes handbrake.install
choco upgrade --cacheLocation="$ChocoCachePath" --yes chocolateygui
choco upgrade --cacheLocation="$ChocoCachePath" --yes dropbox
choco upgrade --cacheLocation="$ChocoCachePath" --yes speccy
choco upgrade --cacheLocation="$ChocoCachePath" --yes virtualclonedrive

# https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
# executeScript "HyperV.ps1";
RefreshEnv

# command line dev tools
choco upgrade --cacheLocation="$ChocoCachePath" --yes ag # ag is (grep || ack) on steroids
choco upgrade --cacheLocation="$ChocoCachePath" --yes jq
choco upgrade --cacheLocation="$ChocoCachePath" --yes curl
choco upgrade --cacheLocation="$ChocoCachePath" --yes wget
choco upgrade --cacheLocation="$ChocoCachePath" --yes vim

choco upgrade --cacheLocation="$ChocoCachePath" --yes powershell-core
choco upgrade --cacheLocation="$ChocoCachePath" --yes azure-cli
Install-Module -Force Az
# choco upgrade --yes microsoftazurestorageexplorer - fails checksum

Install-Module -Force posh-git #for powershell integration

choco upgrade --cacheLocation="$ChocoCachePath" --yes terraform
choco upgrade --cacheLocation="$ChocoCachePath" --yes packer
# choco upgrade --yes vagrant - never completes :(
choco upgrade --cacheLocation="$ChocoCachePath" --yes cmder
RefreshEnv

# UI tools
choco upgrade --cacheLocation="$ChocoCachePath" --yes sysinternals
choco upgrade --cacheLocation="$ChocoCachePath" --yes vscode
choco upgrade --cacheLocation="$ChocoCachePath" --yes virtualbox
choco upgrade --cacheLocation="$ChocoCachePath" --yes slack

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

choco upgrade --cacheLocation="$ChocoCachePath" --yes visualstudio2017community --package-parameters="'--add Microsoft.VisualStudio.Component.Git'"
Update-SessionEnvironment #refreshing env due to Git install
# See https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community?view=vs-2017
choco upgrade --cacheLocation="$ChocoCachePath" --yes visualstudio2017-workload-azure 
choco upgrade --cacheLocation="$ChocoCachePath" --yes visualstudio2017-workload-data
choco upgrade --cacheLocation="$ChocoCachePath" --yes visualstudio2017-workload-manageddesktop
choco upgrade --cacheLocation="$ChocoCachePath" --yes visualstudio2017-workload-netcoretools
choco upgrade --cacheLocation="$ChocoCachePath" --yes visualstudio2017-workload-netweb 

choco upgrade --cacheLocation="$ChocoCachePath" --yes jetbrainstoolbox
#choco upgrade --yes resharper-ultimate-all --package-parameters="'/PerMachine /NoCpp /NoTeamCityAddin'"

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
