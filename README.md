# Windows Dev Box Setup Scripts

This repo was originally forked from [Microsoft's Windows Dev Box Setup Scripts](https://github.com/microsoft/windows-dev-box-setup-scripts).

The Microsoft repo appears to have stalled. For simplicity, I've ruthlessly deleted any unused scripts in this repo. Do go and browse the examples in the [parent repo](https://github.com/microsoft/windows-dev-box-setup-scripts).


## How to run the scripts

- Before you begin, please read the [Legal](#Legal) section.
- __Study__ and understand any script that you run
- Consider forking this repo and creating your own recipes

### Install Boxstarter Shell

1. Open an administrative powershell window 
1. Enter in a single line. (Ref: [Boxstarter Docs](https://boxstarter.org/InstallBoxstarter) )
    ```powershell
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex (New-Object System.Net.WebClient).DownloadString('https:/boxstarter.org/bootstrapper.ps1')); Get-Boxstarter -Force
    ```
### Run Scripts from the BoxStarter Shell

1. Open Boxstarter shell (From the desktop shortcut)
1. Configure credentials to enable auto reboot
    1. ```powershell
       $creds = Get-Credential
       ```
    1. Enter account username and password when prompted.
1. Run installation script
    1. ```powershell
       Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/neilkidd/windows-dev-box-setup-scripts/master/machines/7590_bootstrap.ps1 -Credential $creds
       ```
1. Wait and profit

### Scripts Available

|Name  |Description  |
|---------|---------|
|[Lenovo Thinkpad X1 (Windows 10, 2004)](./thinkpad_x1_boxstart.ps1)| Win 10, VS 2019 Dev Box |
|<a href='./7590_bootstrap.ps1'>Dell Inspiron 7590   | Win 10, VS 2019 Dev Box |
|<a href='./e6230_bootstrap.ps1'>Dell E6230     | Minimal apps for my daughter|

## Legal
Please read before using scripts.

### Using our scripts downloads third party software

When you use our sample scripts, these will direct to Chocolately to install the packages.
By using Chocolatey to install a package, you are accepting the license for the application, executable(s), or other artifacts delivered to your machine as a result of a Chocolatey install. This acceptance occurs whether you know the license terms or not. Read and understand the license terms of any package you plan to install prior to installation through Chocolatey. If you do not want to accept the license of a package you are installing, you need to uninstall the package and any artifacts that end up on your machine as a result of the install.

### Samples are provided AS-IS without any warranties of any kind

Chocolately has implemented security safeguards in their process to help protect the community from malicious or pirated software, but any use of these scripts is at your own risk.  Please read the Chocolately's legal terms of use and the Boxstarter project license as well as how the community repository for Chocolatey.org is maintained.

This project is subject to the MIT License and we make no warranties, express or implied of any kind. In no event will Microsoft, Neil Kidd or contributing copyright holders be liable for any claim, damages or other liability arising from out of or in connection with the use of the project software or the use of other dealings in the project software.
