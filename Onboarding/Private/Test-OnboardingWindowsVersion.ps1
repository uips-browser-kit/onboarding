function Test-OnboardingWindowsVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string[]]$AllowedVersions,
        [string]$InstallUrl = ''
    )

    if (-not $IsWindows) {
        throw "This check requires Windows; the current host is not Windows."
    }

    $build = [System.Environment]::OSVersion.Version
    $current = if ($build.Build -ge 22000) { '11' }
               elseif ($build.Build -ge 10240) { '10' }
               else { $build.Major.ToString() }

    Write-Host "  Windows $current (build $($build.Build))..." -NoNewline
    if ($current -notin $AllowedVersions) {
        $supported = ($AllowedVersions | ForEach-Object { "Windows $_" }) -join ', '
        Write-Host " UNSUPPORTED"
        $msg = "Windows $current is not in the supported list ($supported)."
        if ($InstallUrl) { $msg += " See: $InstallUrl" }
        throw $msg
    }
    Write-Host " OK"
}
