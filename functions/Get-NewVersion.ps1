[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory)]
    [string]
    $RepositoryName,

    [Parameter()]
    [string]
    $CommitMessage
)

$Private:currentVersion = & $PSScriptRoot/Get-CurrentVersion.ps1 -RepositoryName "$RepositoryName"
$Private:bumpType = & $PSScriptRoot/Get-VersionBumpType.ps1 -CommitMessage "$CommitMessage"
$Private:nextVersion = & $PSScriptRoot/New-SemVer.ps1 -Version $Private:currentVersion -BumpType $Private:bumpType

"current-version=$Private:currentVersion" >> $env:GITHUB_OUTPUT
"bump-type=$Private:bumpType" >> $env:GITHUB_OUTPUT
"next-version=$Private:nextVersion" >> $env:GITHUB_OUTPUT

return $Private:nextVersion #| Out-Null
