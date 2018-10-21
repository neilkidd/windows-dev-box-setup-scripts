# Description: Boxstarter Script
# Author: neilkidd
# Bootstrap optimus laptop - windows 10

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
executeScript "RemoveDefaultApps.ps1";

# Browsers
choco upgrade --yes googlechrome

choco upgrade --yes Firefox --package-parameters="'l=en-GB'"

choco upgrade --yes lastpass
# end browsers

# productivity tools
choco upgrade --yes f.lux
choco upgrade --yes 7zip
choco upgrade --yes libreoffice-still
choco upgrade --yes sumatrapdf
choco upgrade --yes cutepdf
choco upgrade --yes imgburn
choco upgrade --yes paint.net
choco upgrade --yes potplayer # Blu-ray - could have been vlc?
choco upgrade --yes rufus
choco upgrade --yes handbrake
choco upgrade --yes chocolateygui
choco upgrade --yes dropbox


Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
