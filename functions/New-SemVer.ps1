[CmdletBinding()]
param (
    [Parameter()]
    [semver]
    $Version,

    [Parameter()]
    [string]
    $BumpType
)

if ('major' -eq $BumpType) {
    return [semver]::new($Version.Major + 1)
}

if ('minor' -eq $BumpType) {
    return [semver]::new($Version.Major, $Version.Minor + 1)
}

return [semver]::new($Version.Major, $Version.Minor, $Version.Patch + 1)
