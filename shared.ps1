# shared.ps1 — common checks and helpers, sourced by all role scripts

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Test-Command($name) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
        Write-Error "Required tool not found: $name. Please install it and re-run."
    }
}

Write-Host "Checking prerequisites..."
Test-Command git
Test-Command gh
Test-Command uv
Test-Command just

Write-Host "Verifying gh authentication..."
gh auth status

Write-Host "All prerequisite checks passed."
