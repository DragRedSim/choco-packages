Import-Module au

$releases = 'https://controller.dl.playstation.net/controller/lang/en/fwupdater.html'

function global:au_GetLatest {
	$package = [AUPackage]::new( $pwd )
    $json_definition_path = 'https://fwupdater.dl.playstation.net/fwupdater/info.json'
    $json_definition = Invoke-RestMethod -Uri $json_definition_path
    $version = $json_definition.ApplicationLatestVersion.ToString()
	#short-circuit if there's no new version in the JSON
	if ($version -eq $package.NuspecVersion.ToString()) {
		return @{Version = $version}
	}

	$download_page	= Invoke-WebRequest -Uri $releases
	$filere			= '\.exe$'
	$url64			= $download_page.links | ? href -match $filere | select -First 1 -expand href
	if ($url64.StartsWith("/")) {
		# url is NOT fully qualified
		$url64 = ([System.Uri]$releases).scheme + '://' + ([System.Uri]$releases).authority + $url64
	}
	
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
          "(^[$]url64\s*=\s*)('.*')"       	    = "`$1'$($Latest.Url64)'"
		  "(^[$]version\s*=\s*)('.*')"			= "`$1'$($Latest.Version)'"
          "(^[$]checksum64\s*=\s*)('.*')"     	= "`$1'$($Latest.Checksum64)'"
          "(^[$]checksumType64\s*=\s*)('.*')" 	= "`$1'$($Latest.ChecksumType64)'"
      }
  }
}

Update-Package -ChecksumFor 64