# maintainer.ps1 — onboarding for maintainers

. "$PSScriptRoot/shared.ps1"

$org = "uips-browser-kit"
$repos = @("library", "rules", "snippets", "skills", "testproject", "testdata",
           "testharness-webapps", "docs", "playground", "exploration", "org")

Write-Host "Cloning maintainer repos..."
foreach ($repo in $repos) {
    if (-not (Test-Path $repo)) {
        gh repo clone "$org/$repo"
    } else {
        Write-Host "  $repo already cloned, skipping."
    }
}

Write-Host "Configuring shared venv..."
uv venv .venv

Write-Host "Maintainer onboarding complete."
Write-Host "Next steps:"
Write-Host "  1. Set UV_PROJECT_ENVIRONMENT to the shared .venv path"
Write-Host "  2. Run 'just install' in each package repo"
