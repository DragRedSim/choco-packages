Import-Module au

$releases = 'https://redirect.splashtop.com/srs/win'

function global:au_GetLatest {
	$package = [AUPackage]::new( $pwd )
	$returned_location = [System.Net.HttpWebRequest]::Create($releases).GetResponse().ResponseUri.AbsoluteUri

	$version = $returned_location -split 'v|_|.exe' | select -Last 1 -Skip 1
	$version = $version.ToString()
	#short-circuit if there's no new version available
	if ($version -eq $package.NuspecVersion) {
		return @{Version = $version}
	}

	$url			= $returned_location
	if ($url.StartsWith("/")) {
		# url is NOT fully qualified
		$url = ([System.Uri]$returned_location).scheme + '://' + ([System.Uri]$returned_location).authority + $url
	}
	
	$checksumType	= 'sha256'
	$checksum		= Get-RemoteChecksum -Algorithm $checksumType -Url $url
	
	return @{
		Url             = $url
		Version         = $version
		Checksum        = $checksum
		ChecksumType    = $checksumType
	}
}

function global:au_SearchReplace {
  @{
      'tools\chocolateyInstall.ps1' = @{
          "(^[$]url\s*=\s*)('.*')"       	    = "`$1'$($Latest.Url)'"
          "(^[$]checksum\s*=\s*)('.*')"     	= "`$1'$($Latest.Checksum)'"
          "(^[$]checksumType\s*=\s*)('.*')" 	= "`$1'$($Latest.ChecksumType)'"
      }
  }
}

Update-Package -ChecksumFor 32