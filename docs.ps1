# docs.ps1 — onboarding for the docs team

. "$PSScriptRoot/shared.ps1"

$org = "uips-browser-kit"
$repos = @("docs", "uips-browser-kit.github.io", "slides")

Write-Host "Cloning docs repos..."
foreach ($repo in $repos) {
    if (-not (Test-Path $repo)) {
        gh repo clone "$org/$repo"
    } else {
        Write-Host "  $repo already cloned, skipping."
    }
}

Write-Host "Docs onboarding complete."
Write-Host "Next steps:"
Write-Host "  1. Read docs/README.md for the folder structure"
Write-Host "  2. Review docs/templates/ for file templates"
