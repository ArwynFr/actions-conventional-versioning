[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $RepositoryName,

    [Parameter(Mandatory = $true)]
    [string]
    $CommitMessage,

    [Parameter()]
    [string]
    $Pattern
)

$Private:currentVersion = & $env:GITHUB_ACTION_PATH/functions/Get-SemVer.ps1 -RepositoryName "$RepositoryName"
$Private:bumpType = & $env:GITHUB_ACTION_PATH/functions/Get-VersionBumpType.ps1 -CommitMessage "$CommitMessage"
$Private:nextVersion = & $env:GITHUB_ACTION_PATH/functions/New-SemVer.ps1 -Version $Private:currentVersion -BumpType $Private:bumpType
Write-Host "Current Version: $Private:currentVersion"
Write-Host "Change Category: $Private:bumpType"
Write-Host "Next Version: $Private:nextVersion"
gh release create "$private:nextVersion" --generate-notes --repo "$RepositoryName" "$Pattern"
