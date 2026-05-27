function Test-OnboardingSoftware {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string[]]$Ids,
        [switch]$IncludeAuth
    )

    $dataPath = Join-Path $script:ModuleRoot 'data' 'physical-technology-components.csv'
    $catalog  = Import-Csv $dataPath

    $entries = foreach ($id in $Ids) {
        $row = $catalog | Where-Object { $_.id -eq $id }
        if (-not $row) {
            throw "PTC ID '$id' not found in the software inventory. Check Onboarding/data/physical-technology-components.csv."
        }
        $row
    }

    # OS check — collect all os-category entries and test once with the combined allowed list
    $osEntries = @($entries | Where-Object { $_.category -eq 'os' })
    if ($osEntries.Count -gt 0) {
        $allowedVersions = @($osEntries | Where-Object { $_.version } | ForEach-Object { $_.version })
        $installUrl      = ($osEntries | Select-Object -First 1).source
        Test-OnboardingWindowsVersion -AllowedVersions $allowedVersions -InstallUrl $installUrl
    }

    # Command checks and auth checks for all non-os entries
    foreach ($entry in ($entries | Where-Object { $_.category -ne 'os' })) {
        if ($entry.command) {
            Test-OnboardingCommand -Command $entry.command -Name $entry.name -InstallUrl $entry.source
        }
        if ($IncludeAuth -and $entry.auth_command) {
            Invoke-OnboardingAuthCheck -AuthCommand $entry.auth_command -Name $entry.name
        }
    }
}
