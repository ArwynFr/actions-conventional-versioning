[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $CommitMessage
)

$ConventionalCommit = $CommitMessage -match '^(patch|minor|major): '

if ($ConventionalCommit) {
    return $Matches[1]
}

if ($CommitMessage -match 'BREAKING CHANGE:') {
    return 'major'
}

if ($CommitMessage -match 'NEW FEATURE:') {
    return 'minor'
}

return 'patch'
