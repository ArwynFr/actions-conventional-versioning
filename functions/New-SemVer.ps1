[CmdletBinding()]
param (
    [Parameter()]
    [semver]
    $Version,

    [Parameter()]
    [string]
    $BumpType
)

if ('Breaking' -eq $BumpType) {
    return [semver]::new($Version.Major + 1)
}

if ('Feature' -eq $BumpType) {
    return [semver]::new($Version.Major, $Version.Minor + 1)
}

return [semver]::new($Version.Major, $Version.Minor, $Version.Patch + 1)
