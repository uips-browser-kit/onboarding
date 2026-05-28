# maintainer.ps1 — onboarding for maintainers
# Requires UIPS_BROWSER_KIT_ROOT to be set.

. "$PSScriptRoot/shared.ps1"

# TA_PTC_011: gh — verify authentication (maintainers need org-level API access)
Test-OnboardingSoftware -Ids @('TA_PTC_011') -IncludeAuth

Test-OnboardingHostsFile `
    -Hostnames (Get-Content (Join-Path $PSScriptRoot 'Onboarding/data/harness-hosts.txt'))
