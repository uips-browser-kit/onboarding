# maintainer.ps1 — onboarding for maintainers
# Requires UIPS_BROWSER_KIT_ROOT to be set.

. "$PSScriptRoot/shared.ps1"

$org = "uips-browser-kit"
$repos = @("library", "rules", "snippets", "skills", "testproject", "testdata",
           "testharness-webapps", "docs", "playground", "exploration", "org")

Write-Host "Cloning maintainer repos into $env:UIPS_BROWSER_KIT_ROOT ..."
foreach ($repo in $repos) {
    $target = Join-Path $env:UIPS_BROWSER_KIT_ROOT $repo
    if (-not (Test-Path $target)) {
        gh repo clone "$org/$repo" $target
    } else {
        Write-Host "  $repo already exists, skipping."
    }
}

Write-Host "Creating shared venv at $env:UV_PROJECT_ENVIRONMENT ..."
if (-not (Test-Path $env:UV_PROJECT_ENVIRONMENT)) {
    uv venv $env:UV_PROJECT_ENVIRONMENT
} else {
    Write-Host "  venv already exists, skipping."
}

Write-Host "Maintainer onboarding complete."
Write-Host "Next steps:"
Write-Host "  1. Run 'just install' in each package repo"
