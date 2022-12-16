Import-Module au

$releases = 'https://www.crucial.com/support/storage-executive'

function global:au_GetLatest {
	$download_page	= Invoke-WebRequest -Uri $releases
	$filere			= '\.zip$'
	$url64			= $download_page.links | ? href -match $filere | select -First 1 -expand href
	if ($url64.StartsWith("/")) {
		# url is NOT fully qualified
		$url64 = ([System.Uri]$releases).scheme + '://' + ([System.Uri]$releases).authority + $url64
	}		
	$verre			= '(?<=Version\s)[\d.-]+(?=\s)'
	$download_page.Content -match $verre | Out-Null
	$version		= $Matches[0]
	
	$checksumType	= 'sha256'
	$checksum64		= Get-RemoteChecksum -Algorithm $checksumType -Url $url64
	
	return @{
		Url64             = $url64
		Version           = $version
		Checksum64        = $checksum64
		ChecksumType64    = $checksumType
	}
}

function global:au_SearchReplace {
  @{
      'tools\chocolateyInstall.ps1' = @{
          "(^[$]url64bit\s*=\s*)('.*')"       	= "`$1'$($Latest.Url64)'"
		  "(^[$]version\s*=\s*)('.*')"			= "`$1'$($Latest.Version)'"
          "(^[$]checksum64\s*=\s*)('.*')"     	= "`$1'$($Latest.Checksum64)'"
          "(^[$]checksumType64\s*=\s*)('.*')" 	= "`$1'$($Latest.ChecksumType64)'"
      }
  }
}

Update-Package -ChecksumFor none