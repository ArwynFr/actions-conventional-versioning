[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory)]
    [semver]
    $NextVersion,

    [Parameter()]
    [string]
    $Pattern
)

if ($PSCmdlet.ShouldProcess($NextVersion, 'gh release create')) {
    gh release create "$NextVersion" --generate-notes --repo "$RepositoryName"
    if (-Not [string]::IsNullOrEmpty($Pattern)) {
        gh release upload "$NextVersion" --repo "$RepositoryName" (Get-Item "$Pattern")
    }
}
