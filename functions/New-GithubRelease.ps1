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

$Private:currentVersion = & $PSScriptRoot/Get-SemVer.ps1 -RepositoryName "$RepositoryName"
$Private:bumpType = & $PSScriptRoot/Get-VersionBumpType.ps1 -CommitMessage "$CommitMessage"
$Private:nextVersion = & $PSScriptRoot/New-SemVer.ps1 -Version $Private:currentVersion -BumpType $Private:bumpType

Write-Host "::set-output name=current-version::$Private:currentVersion"
Write-Host "::set-output name=bump-type::$Private:bumpType"
Write-Host "::set-output name=next-version::$Private:nextVersion"

Write-Output "current-version: $Private:currentVersion"
Write-Output "bump-type: $Private:bumpType"
Write-Output "next-version: $Private:nextVersion"

if ($PSCmdlet.ShouldProcess($private:nextVersion, 'gh release create')) {
    if (($null -eq $Pattern) -or ('' -eq $Pattern)) {
        gh release create "$private:nextVersion" --generate-notes --repo "$RepositoryName"
    }
    else {
        gh release create "$private:nextVersion" --generate-notes --repo "$RepositoryName" (Get-Item "$Pattern")
    }
}
