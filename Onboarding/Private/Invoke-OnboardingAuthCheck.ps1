function Invoke-OnboardingAuthCheck {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$AuthCommand,
        [Parameter(Mandatory)][string]$Name
    )

    Write-Host "Verifying $Name authentication..."
    $parts = $AuthCommand -split '\s+'
    & $parts[0] $parts[1..$parts.Length]
}
