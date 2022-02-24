[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $CommitMessage
)

if ($CommitMessage -match 'BREAKING CHANGE:') {
    return 'Breaking'
}

$private:commitFirstLine = ($CommitMessage -split [Environment]::NewLine)[0]
if (($private:commitFirstLine -split ": ")[0].EndsWith('!')) {
    return 'Breaking'
}

if ($private:commitFirstLine.StartsWith("feat")) {
    return 'Feature'
}

return 'Fix'
