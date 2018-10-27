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

executeScript "HyperV.ps1";
RefreshEnv

# command line dev tools
choco upgrade --yes ag # ag is (grep || ack) on steroids
choco upgrade --yes jq
choco upgrade --yes cmder
Install-Module -Force posh-git #for powersehell integration

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
