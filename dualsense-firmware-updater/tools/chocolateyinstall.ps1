
$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://fwupdater.dl.playstation.net/fwupdater/FWupdaterInstaller.exe'
$checksum64     = 'f558c839ba897b42aaa51e2215d50ac3bd04e3a0e008f8dd1ebab4ba2dee04ef'
$checksumType64 = 'sha256'
$version        = '1.0.0.2'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'EXE'
  url64          = $url64
  checksum64     = $checksum64
  checksumType64 = $checksumType64
  softwareName   = 'Firmware updater for DualSense*'
  version        = $version
  validExitCodes = @(0, 3010, 1641)
  silentArgs     = '/s /v"/qn"'
}

Install-ChocolateyPackage @packageArgs
