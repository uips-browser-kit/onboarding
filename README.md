# onboarding

PowerShell scripts to set up a local development environment for each
team role.

## Usage

Run the script for your role from a PowerShell Core (pwsh) prompt:

```powershell
# All roles — run shared setup first
. ./shared.ps1

# Then run your role-specific script
. ./contributor.ps1   # if you are a contributor
. ./maintainer.ps1    # if you are a maintainer
. ./docs.ps1          # if you are on the docs team
. ./triage.ps1        # if you are on the triage team
```

## Prerequisites

- [PowerShell Core (pwsh)](https://github.com/PowerShell/PowerShell)
- [git](https://git-scm.com/)
- [gh](https://cli.github.com/) authenticated (`gh auth login`)
- [uv](https://docs.astral.sh/uv/)
- [just](https://just.systems/)
