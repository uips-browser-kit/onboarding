# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo does

PowerShell prerequisite-check scripts for each team role in the `uips-browser-kit` org. A new member runs the script for their role; it verifies their local environment against the org's TOGAF software inventory. No repo cloning happens here.

## Running tests

```powershell
Invoke-Pester ./Onboarding/Tests/Onboarding.Tests.ps1 -Output Detailed
```

Requires Pester 5 (`Install-Module Pester -Force -Scope CurrentUser` if missing).

## Running a role script

```powershell
$env:UIPS_BROWSER_KIT_ROOT = 'D:\work\uips-browser-kit'   # must be set first
. ./maintainer.ps1
```

## Architecture

All detection logic lives in the `Onboarding/` PowerShell module. The role scripts (`contributor.ps1`, `maintainer.ps1`, `docs.ps1`, `triage.ps1`) and `shared.ps1` are thin dot-source frontends.

### Data flow

```
physical-technology-components.csv   (source of truth — copied from docs/togaf/tec/)
        ↓  extended with: command, auth_command columns
Onboarding/data/physical-technology-components.csv
        ↓  loaded by
Test-OnboardingSoftware  (Public)
        ↓  dispatches to
Test-OnboardingWindowsVersion   category = os
Test-OnboardingCommand          command column non-empty
Invoke-OnboardingAuthCheck      auth_command column non-empty + -IncludeAuth switch
```

### Check types

| Type | Trigger | Private function |
|---|---|---|
| OS | `category = os` | `Test-OnboardingWindowsVersion` — compares `OSVersion.Version.Build` against `version` column |
| Command | `command` column non-empty | `Test-OnboardingCommand` — `Get-Command` on PATH |
| Auth | `auth_command` column non-empty + `-IncludeAuth` | `Invoke-OnboardingAuthCheck` — splits and `&`-invokes the auth command |

### Role differentiation

`shared.ps1` runs the baseline checks (Windows 10/11, git, just, uv, gh binary — no auth) for all roles. `maintainer.ps1` adds a separate `Test-OnboardingSoftware -Ids @('TA_PTC_011') -IncludeAuth` call to gate on `gh auth status`, because maintainers are the only role that needs org-level API access.

### Adding a role-specific check

```powershell
# inside any role script, after . "$PSScriptRoot/shared.ps1"
Test-OnboardingSoftware -Ids @('TA_PTC_007')   # require Python
```

### Keeping the CSV in sync

The module's CSV at `Onboarding/data/physical-technology-components.csv` is a copy of `D:\github.com\uips-browser-kit\docs\togaf\tec\physical-technology-components.csv` with two appended columns (`command`, `auth_command`). When the source CSV changes, copy it and re-add those columns. PTC IDs referenced in `shared.ps1` must be updated to match if IDs shift.
