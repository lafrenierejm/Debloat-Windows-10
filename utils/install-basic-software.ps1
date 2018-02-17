#   Description:
# This script will use Windows package manager to bootstrap Chocolatey and
# install a list of packages. Script will also install Sysinternals Utilities
# into your default drive's root directory.

$packages = @(
    "7zip.install"
    "adobereader"
    "classic-shell -installArgs ADDLOCAL=ClassicStartMenu"
    "googlechrome"
)

echo "Setting up Chocolatey software package manager"
Get-PackageProvider -Name chocolatey -Force

echo "Setting up Full Chocolatey Install"
Install-Package -Name Chocolatey -Force -ProviderName chocolatey
$chocopath = (Get-Package chocolatey | ?{$_.Name -eq "chocolatey"} | Select @{N="Source";E={((($a=($_.Source -split "\\"))[0..($a.length - 2)]) -join "\"),"Tools\chocolateyInstall" -join "\"}} | Select -ExpandProperty Source)
& $chocopath "upgrade all -y"
choco install chocolatey-core.extension --force

echo "Installing Packages"
$packages | %{choco install $_ --force -y}
