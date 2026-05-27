# docs.ps1 — onboarding for the docs team
# Requires UIPS_BROWSER_KIT_ROOT to be set.

. "$PSScriptRoot/shared.ps1"

$org = "uips-browser-kit"
$repos = @("docs", "uips-browser-kit.github.io", "slides")

Write-Host "Cloning docs repos into $env:UIPS_BROWSER_KIT_ROOT ..."
foreach ($repo in $repos) {
    $target = Join-Path $env:UIPS_BROWSER_KIT_ROOT $repo
    if (-not (Test-Path $target)) {
        gh repo clone "$org/$repo" $target
    } else {
        Write-Host "  $repo already exists, skipping."
    }
}

Write-Host "Docs onboarding complete."
Write-Host "Next steps:"
Write-Host "  1. Read docs/README.md for the folder structure"
Write-Host "  2. Review docs/templates/ for file templates"
