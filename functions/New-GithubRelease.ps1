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
    gh release create "$private:nextVersion" --generate-notes --repo "$RepositoryName"
    if (-Not [string]::IsNullOrEmpty($Pattern)) {
        gh release upload "$private:nextVersion" --repo "$RepositoryName" (Get-Item "$Pattern")
    }
}
