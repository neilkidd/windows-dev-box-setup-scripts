# Description: Boxstarter Script
# Author: neilkidd
# Bootstrap Dell E6230 laptop - Windows 10 Pro

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
choco upgrade --yes googlechrome
choco upgrade --yes Firefox --package-parameters="'l=en-GB'"
# end browsers

# productivity tools
choco upgrade --cacheLocation="$ChocoCachePath" --yes f.lux.install
choco upgrade --cacheLocation="$ChocoCachePath" --yes 7zip.install
choco upgrade --cacheLocation="$ChocoCachePath" --yes libreoffice-still
choco upgrade --cacheLocation="$ChocoCachePath" --yes sumatrapdf.install
choco upgrade --cacheLocation="$ChocoCachePath" --yes cutepdf
choco upgrade --cacheLocation="$ChocoCachePath" --yes imgburn
choco upgrade --cacheLocation="$ChocoCachePath" --yes paint.net
choco upgrade --cacheLocation="$ChocoCachePath" --yes potplayer
choco upgrade --cacheLocation="$ChocoCachePath" --yes rufus
choco upgrade --cacheLocation="$ChocoCachePath" --yes chocolateygui
choco upgrade --cacheLocation="$ChocoCachePath" --yes speccy


Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
