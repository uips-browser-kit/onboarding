# triage.ps1 — onboarding for the triage team

. "$PSScriptRoot/shared.ps1"

$org = "uips-browser-kit"

Write-Host "Fetching open issues across org..."
gh issue list --repo "$org/library" --state open
gh issue list --repo "$org/docs" --state open

Write-Host "Triage onboarding complete."
Write-Host "Next steps:"
Write-Host "  1. Review CONTRIBUTING.md in each repo for label conventions"
Write-Host "  2. Use 'gh issue edit' to apply labels and assign milestones"
