function Test-OnboardingHostEntry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Hostname,
        [Parameter(Mandatory)][string[]]$HostsContent
    )

    $pattern = "^\s*127\.0\.0\.1\s+$([regex]::Escape($Hostname))(\s|$)"
    return [bool]($HostsContent | Where-Object { $_ -match $pattern })
}
