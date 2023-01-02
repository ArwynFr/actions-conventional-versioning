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

Write-Host "current-version=$Private:currentVersion" >> $env:GITHUB_OUTPUT
Write-Host "bump-type=$Private:bumpType" >> $env:GITHUB_OUTPUT
Write-Host "next-version=$Private:nextVersion" >> $env:GITHUB_OUTPUT

if ($PSCmdlet.ShouldProcess($private:nextVersion, 'gh release create')) {
    if (($null -eq $Pattern) -or ('' -eq $Pattern)) {
        gh release create "$private:nextVersion" --generate-notes --repo "$RepositoryName"
    }
    else {
        gh release create "$private:nextVersion" --generate-notes --repo "$RepositoryName" (Get-Item "$Pattern")
    }
}
