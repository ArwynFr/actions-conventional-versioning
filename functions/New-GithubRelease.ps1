[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory)]
    [string]
    $RepositoryName,

    [Parameter()]
    [string]
    $CommitMessage,

    [Parameter()]
    [string]
    $Pattern
)

$Private:currentVersion = & $env:GITHUB_ACTION_PATH/functions/Get-SemVer.ps1 -RepositoryName "$RepositoryName"
$Private:bumpType = & $env:GITHUB_ACTION_PATH/functions/Get-VersionBumpType.ps1 -CommitMessage "$CommitMessage"
$Private:nextVersion = & $env:GITHUB_ACTION_PATH/functions/New-SemVer.ps1 -Version $Private:currentVersion -BumpType $Private:bumpType

Write-Host "::set-output name=current-version::$Private:currentVersion"
Write-Host "::set-output name=bump-type::$Private:bumpType"
Write-Host "::set-output name=next-version::$Private:nextVersion"

Write-Output "current-version: $Private:currentVersion"
Write-Output "bump-type: $Private:bumpType"
Write-Output "next-version: $Private:nextVersion"

if ($PSCmdlet.ShouldProcess($private:nextVersion, 'gh release create')) {
    gh release create "$private:nextVersion" --generate-notes --repo "$RepositoryName" "$Pattern"
}
