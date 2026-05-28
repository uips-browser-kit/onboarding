function Test-OnboardingHostsFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string[]]$Hostnames,
        [string]$HostsPath = 'C:\Windows\System32\drivers\etc\hosts'
    )

    Write-Host "Checking hosts file ($HostsPath)..."
    $content = @(Get-Content $HostsPath -ErrorAction Stop)
    $missing = [System.Collections.Generic.List[string]]::new()

    foreach ($hostname in $Hostnames) {
        Write-Host "  127.0.0.1  $hostname..." -NoNewline
        if (Test-OnboardingHostEntry -Hostname $hostname -HostsContent $content) {
            Write-Host " OK"
        } else {
            Write-Host " MISSING"
            $missing.Add($hostname)
        }
    }

    if ($missing.Count -gt 0) {
        $lines = $missing | ForEach-Object { "127.0.0.1  $_" }
        throw "Add the following entries to $HostsPath :`n`n$($lines -join "`n")"
    }
}
