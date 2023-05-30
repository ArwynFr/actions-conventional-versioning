[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory)]
    [string]
    $RepositoryName,

    [Parameter()]
    [string]
    $CommitMessage,

    [Parameter()]
    [switch]
    $FeatUpgradesMinor,

    [Parameter()]
    [switch]
    $AllowAdditionalModifiers,
    
    [Parameter()]
    [switch]
    $StrictTypes
)

Install-Module -Force StepSemVer, ConventionalCommits
Import-Module -Force StepSemVer, ConventionalCommits

$Private:parameters = @{
    FeatUpgradesMinor        = $FeatUpgradesMinor
    AllowAdditionalModifiers = $AllowAdditionalModifiers
    CommitMessage            = $CommitMessage
    StrictTypes              = $StrictTypes
}
$Private:currentVersion = & $PSScriptRoot/Get-CurrentVersion.ps1 -RepositoryName "$RepositoryName"
$Private:bumpType = & $PSScriptRoot/Get-VersionBumpType.ps1 @Private:parameters
$Private:nextVersion = $Private:currentVersion | Step-SemVer -BumpType $Private:bumpType

"current-version=$Private:currentVersion" >> $env:GITHUB_OUTPUT
"bump-type=$Private:bumpType" >> $env:GITHUB_OUTPUT
"next-version=$Private:nextVersion" >> $env:GITHUB_OUTPUT

return $Private:nextVersion #| Out-Null
