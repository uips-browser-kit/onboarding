# contributor.ps1 — onboarding for contributors
# Requires UIPS_BROWSER_KIT_ROOT to be set.

. "$PSScriptRoot/shared.ps1"

$org = "uips-browser-kit"
$repos = @("testproject", "testdata", "docs", "playground", "exploration", "slides")

Write-Host "Cloning contributor repos into $env:UIPS_BROWSER_KIT_ROOT ..."
foreach ($repo in $repos) {
    $target = Join-Path $env:UIPS_BROWSER_KIT_ROOT $repo
    if (-not (Test-Path $target)) {
        gh repo clone "$org/$repo" $target
    } else {
        Write-Host "  $repo already exists, skipping."
    }
}

Write-Host "Contributor onboarding complete."
Write-Host "Next steps:"
Write-Host "  1. Read docs/guides/contributing-*.md"
Write-Host "  2. Open an issue before starting work on a new feature"
