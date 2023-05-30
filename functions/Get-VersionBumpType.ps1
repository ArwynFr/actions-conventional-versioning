[CmdletBinding()]
param (
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

$conventions = $CommitMessage | ConvertTo-ConventionalCommitHeader -StrictTypes:$StrictTypes -AdditionalModifiers:$AllowAdditionalModifiers
$modifier_bump = '-+!'.IndexOf($conventions.Modifier ?? '-')
$type_bump = $conventions.Type -eq 'feat' -and $FeatUpgradesMinor ? 1 : 0
$long_bump = switch ($true) {
    ($CommitMessage -match '\nBREAKING CHANGE: ') { 2 }
    ($CommitMessage -match '\nNEW FEATURE: ') { $AllowAdditionalModifiers ? 1 : 0 }
    default { 0 }
}

$bump = (@($modifier_bump, $type_bump, $long_bump) | Measure-Object -Maximum).Maximum
return @('patch', 'minor', 'major')[$bump]
