# contributor.ps1 — onboarding for contributors

. "$PSScriptRoot/shared.ps1"

$org = "uips-browser-kit"
$repos = @("testproject", "testdata", "docs", "playground", "exploration", "slides")

Write-Host "Cloning contributor repos..."
foreach ($repo in $repos) {
    if (-not (Test-Path $repo)) {
        gh repo clone "$org/$repo"
    } else {
        Write-Host "  $repo already cloned, skipping."
    }
}

Write-Host "Contributor onboarding complete."
Write-Host "Next steps:"
Write-Host "  1. Read docs/guides/contributing-*.md"
Write-Host "  2. Open an issue before starting work on a new feature"
