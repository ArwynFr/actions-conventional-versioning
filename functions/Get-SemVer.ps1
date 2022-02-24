[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $RepositoryName
)

$private:PrevErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'silentlycontinue'
$private:currentVersionNumber = ((gh release view --json tagName --repo $RepositoryName) | convertfrom-json).TagName
$private:currentVersion = [semver]::new($private:currentVersionNumber)
$ErrorActionPreference = $private:PrevErrorActionPreference
return $private:currentVersion
