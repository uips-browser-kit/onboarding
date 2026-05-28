# contributor.ps1 — onboarding for contributors
# Requires UIPS_BROWSER_KIT_ROOT to be set.

. "$PSScriptRoot/shared.ps1"

Test-OnboardingHostsFile `
    -Hostnames (Get-Content (Join-Path $PSScriptRoot 'Onboarding/data/harness-hosts.txt'))
