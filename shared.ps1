# shared.ps1 — common checks and helpers, sourced by all role scripts
#
# Requires UIPS_BROWSER_KIT_ROOT to be set before running, e.g.:
#   $env:UIPS_BROWSER_KIT_ROOT = 'D:\work\uips-browser-kit'

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $env:UIPS_BROWSER_KIT_ROOT) {
    throw "UIPS_BROWSER_KIT_ROOT is not set. " +
          "Set it to your workspace root (e.g. `$env:UIPS_BROWSER_KIT_ROOT = 'D:\work\uips-browser-kit') " +
          "before running onboarding scripts."
}
$env:UV_PROJECT_ENVIRONMENT = "$env:UIPS_BROWSER_KIT_ROOT\.venv"

Import-Module (Join-Path $PSScriptRoot 'Onboarding/Onboarding.psd1') -Force

Write-Host "Workspace root: $env:UIPS_BROWSER_KIT_ROOT"
Write-Host "Checking prerequisites..."
# TA_PTC_002/003: Windows 10 or 11  TA_PTC_004: git  TA_PTC_008: just  TA_PTC_010: uv  TA_PTC_011: gh
Test-OnboardingSoftware `
    -Ids @('TA_PTC_002', 'TA_PTC_003', 'TA_PTC_004', 'TA_PTC_008', 'TA_PTC_010', 'TA_PTC_011')

Write-Host "All prerequisite checks passed."
