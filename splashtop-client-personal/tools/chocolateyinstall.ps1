
$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.splashtop.com/winclient/STP/Splashtop_Personal_Win_v3.5.2.4.exe'
$checksum      = '2314592a6d2c34a908ba692bfe693a13e16183aa41da0a6bae37d90f0a385f71'
$checksumType  = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'Splashtop Personal*'

  checksum      = $checksum
  checksumType  = $checksumType

  validExitCodes= @(0, 3010, 1641)
  silentArgs   = '/s /v"/qn"'
}

Install-ChocolateyPackage @packageArgs
