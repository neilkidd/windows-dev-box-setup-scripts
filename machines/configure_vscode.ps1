# windows 10 specific.
# expects code to installed and on path
# Expects git bash to be on the path.

code --install-extension editorconfig.editorconfig
code --install-extension AlanWalk.markdown-toc
code --install-extension bungcip.better-toml
code --install-extension DavidAnson.vscode-markdownlint
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension redhat.vscode-yaml
code --install-extension fcrespo82.markdown-table-formatter

code --install-extension ms-vscode-remote.vscode-remote-extensionpack
code --install-extension ms-dotnettools.csharp

code --install-extension ritwickdey.liveserver
code --install-extension coenraads.bracket-pair-colorizer

# configure (user) settings.json
$settingsDirPath = "$env:APPDATA\Code\User\"
$settingsFilePath = "$settingsDirPath\settings.json"
$utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False

if (-not (Test-Path -LiteralPath $settingsDirPath)) {
    Write-Host "Creating settings dir."
    New-Item -Path $settingsDirPath -ItemType Directory -Force
}

$bashPath = (Get-Command bash.exe).Path.Replace("\", "\\")

$jsonTemplate = @"
{{
    "editor.renderWhitespace": "all",
    "editor.renderControlCharacters": true,
    "terminal.integrated.shell.windows": "{0}",
    "cSpell.language": "en-GB"
}}
"@ -f $bashPath

# Overwrites existing content
[System.IO.File]::WriteAllLines($settingsFilePath, $jsonTemplate, $utf8NoBomEncoding)
