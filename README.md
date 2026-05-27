# onboarding

PowerShell scripts to set up a local development environment for each
team role.

## Usage

Run the script for your role from a PowerShell Core (pwsh) prompt:

```powershell
. ./contributor.ps1   # if you are a contributor
. ./maintainer.ps1    # if you are a maintainer
. ./docs.ps1          # if you are on the docs team
. ./triage.ps1        # if you are on the triage team
```

Each script runs the shared software prerequisite checks and exits.
Role-specific checks can be added by calling `Test-OnboardingSoftware` with additional PTC IDs.

## Prerequisites

- [PowerShell Core (pwsh)](https://github.com/PowerShell/PowerShell)
- [git](https://git-scm.com/)
- [gh](https://cli.github.com/) authenticated (`gh auth login`)
- [uv](https://docs.astral.sh/uv/)
- [just](https://just.systems/)

## Module

Detection logic lives in the `Onboarding/` PowerShell module.
The role scripts and `shared.ps1` are thin frontends that import it.

```
Onboarding/
  Onboarding.psd1                       module manifest
  Onboarding.psm1                       module root
  data/
    physical-technology-components.csv  software inventory (org CSV + command/auth_command columns)
  Public/
    Test-OnboardingSoftware.ps1         exported function — dispatches OS, command, and auth checks
  Private/
    Test-OnboardingCommand.ps1          checks a binary is on PATH
    Test-OnboardingWindowsVersion.ps1   checks the Windows build number
    Invoke-OnboardingAuthCheck.ps1      runs an auth-verification command
  Tests/
    Onboarding.Tests.ps1                Pester 5 tests
```

### Adding role-specific checks

Role scripts can extend the shared checks by calling `Test-OnboardingSoftware`
with additional PTC IDs from the software inventory:

```powershell
# require Python for this role
Test-OnboardingSoftware -Ids @('TA_PTC_007')
```

### Running the tests

```powershell
Invoke-Pester ./Onboarding/Tests/Onboarding.Tests.ps1 -Output Detailed
```
