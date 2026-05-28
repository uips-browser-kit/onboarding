function Test-OnboardingHostEntry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Hostname,
        [Parameter(Mandatory)][string]$HostsContent
    )

    # (?m) makes ^ and $ match per line within the raw file string
    $pattern = "(?m)^\s*127\.0\.0\.1\s+$([regex]::Escape($Hostname))\s*$"
    return $HostsContent -match $pattern
}
