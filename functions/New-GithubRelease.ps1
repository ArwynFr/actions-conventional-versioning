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

$private:nextVersion = & $PSScriptRoot/Get-NewVersion.ps1 -RepositoryName $RepositoryName -CommitMessage $CommitMessage

if ($PSCmdlet.ShouldProcess($private:nextVersion, 'gh release create')) {
    if (($null -eq $Pattern) -or ('' -eq $Pattern)) {
        gh release create "$private:nextVersion" --generate-notes --repo "$RepositoryName"
    } else {
        gh release create "$private:nextVersion" --generate-notes --repo "$RepositoryName" (Get-Item "$Pattern")
    }
}
