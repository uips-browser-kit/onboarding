# shared.ps1 — common checks and helpers, sourced by all role scripts
#
# Requires UIPS_BROWSER_KIT_ROOT to be set before running, e.g.:
#   $env:UIPS_BROWSER_KIT_ROOT = 'D:\work\uips-browser-kit'

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $env:UIPS_BROWSER_KIT_ROOT) {
    throw "UIPS_BROWSER_KIT_ROOT is not set. " +
          "Set it to your workspace root before running onboarding scripts. " +
          "Example: `$env:UIPS_BROWSER_KIT_ROOT = 'D:\work\uips-browser-kit'"
}
$env:UV_PROJECT_ENVIRONMENT = "$env:UIPS_BROWSER_KIT_ROOT\.venv"

function Test-Command($name) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
        throw "Required tool not found: $name. Please install it and re-run."
    }
}

Write-Host "Workspace root: $env:UIPS_BROWSER_KIT_ROOT"
Write-Host "Checking prerequisites..."
Test-Command git
Test-Command gh
Test-Command uv
Test-Command just

Write-Host "Verifying gh authentication..."
gh auth status

Write-Host "All prerequisite checks passed."
