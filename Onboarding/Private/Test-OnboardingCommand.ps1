function Test-OnboardingCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Command,
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$InstallUrl
    )

    Write-Host "  $Name ($Command)..." -NoNewline
    if (-not (Get-Command $Command -ErrorAction SilentlyContinue)) {
        Write-Host " MISSING"
        throw "$Name ('$Command') not found on PATH. Install from: $InstallUrl"
    }
    Write-Host " OK"
}
