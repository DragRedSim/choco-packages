
$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.splashtop.com/win/Splashtop_Streamer_Win_INSTALLER_v3.5.2.3.exe'
$checksum      = 'c89e888c89b15256e27118db183da98dd97c134db0065596090f772ebbd15a48'
$checksumType  = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'Splashtop Streamer*'

  checksum      = $checksum
  checksumType  = $checksumType

  validExitCodes= @(0, 3010, 1641)
  silentArgs   = '/s /v"/qn"'
}

Install-ChocolateyPackage @packageArgs
