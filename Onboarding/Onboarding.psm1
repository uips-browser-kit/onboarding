$script:ModuleRoot = $PSScriptRoot

foreach ($file in (Get-ChildItem -Path (Join-Path $PSScriptRoot 'Private') -Filter '*.ps1' -File)) {
    . $file.FullName
}

$publicFiles = Get-ChildItem -Path (Join-Path $PSScriptRoot 'Public') -Filter '*.ps1' -File
foreach ($file in $publicFiles) {
    . $file.FullName
}

Export-ModuleMember -Function ($publicFiles | ForEach-Object { $_.BaseName })
