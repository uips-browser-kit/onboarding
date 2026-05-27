#Requires -Module Pester

BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '..' 'Onboarding.psd1') -Force
}

Describe 'Test-OnboardingCommand' {
    It 'does not throw when the command exists on PATH' {
        InModuleScope Onboarding {
            { Test-OnboardingCommand -Command 'pwsh' -Name 'PowerShell Core' -InstallUrl 'https://github.com/PowerShell/PowerShell' } |
                Should -Not -Throw
        }
    }

    It 'throws with the command name in the message when missing' {
        InModuleScope Onboarding {
            { Test-OnboardingCommand -Command '__no_such_cmd__' -Name 'Missing Tool' -InstallUrl 'https://example.com' } |
                Should -Throw -ExpectedMessage "*'__no_such_cmd__'*"
        }
    }

    It 'throws with the install URL in the message when missing' {
        InModuleScope Onboarding {
            { Test-OnboardingCommand -Command '__no_such_cmd__' -Name 'Missing Tool' -InstallUrl 'https://example.com/install' } |
                Should -Throw -ExpectedMessage '*https://example.com/install*'
        }
    }
}

Describe 'Test-OnboardingWindowsVersion' {
    It 'does not throw when the current Windows version is in the allowed list' -Skip:(-not $IsWindows) {
        InModuleScope Onboarding {
            $build   = [System.Environment]::OSVersion.Version
            $current = if ($build.Build -ge 22000) { '11' } elseif ($build.Build -ge 10240) { '10' } else { $build.Major.ToString() }
            { Test-OnboardingWindowsVersion -AllowedVersions @($current) -InstallUrl '' } | Should -Not -Throw
        }
    }

    It 'throws when the current version is not in the allowed list' -Skip:(-not $IsWindows) {
        InModuleScope Onboarding {
            { Test-OnboardingWindowsVersion -AllowedVersions @('9') -InstallUrl '' } | Should -Throw
        }
    }

    It 'includes the supported versions in the error message' -Skip:(-not $IsWindows) {
        InModuleScope Onboarding {
            { Test-OnboardingWindowsVersion -AllowedVersions @('9') -InstallUrl '' } |
                Should -Throw -ExpectedMessage '*Windows 9*'
        }
    }

    It 'throws on a non-Windows host' -Skip:($IsWindows) {
        InModuleScope Onboarding {
            { Test-OnboardingWindowsVersion -AllowedVersions @('10', '11') -InstallUrl '' } |
                Should -Throw -ExpectedMessage '*not Windows*'
        }
    }
}

Describe 'Test-OnboardingSoftware' {
    Context 'unknown ID' {
        It 'throws with the ID in the message' {
            { Test-OnboardingSoftware -Ids @('TA_PTC_999') } | Should -Throw -ExpectedMessage '*TA_PTC_999*'
        }
    }

    Context 'command check delegation' {
        BeforeEach {
            Mock -ModuleName Onboarding Test-OnboardingCommand { }
        }

        It 'calls Test-OnboardingCommand with the correct command for git (TA_PTC_004)' {
            Test-OnboardingSoftware -Ids @('TA_PTC_004')
            Should -Invoke Test-OnboardingCommand -ModuleName Onboarding -Times 1 `
                -ParameterFilter { $Command -eq 'git' }
        }

        It 'does not call Test-OnboardingCommand for os-category entries' {
            Mock -ModuleName Onboarding Test-OnboardingWindowsVersion { }
            Test-OnboardingSoftware -Ids @('TA_PTC_002')
            Should -Invoke Test-OnboardingCommand -ModuleName Onboarding -Times 0
        }
    }

    Context '-IncludeAuth' {
        BeforeEach {
            Mock -ModuleName Onboarding Test-OnboardingCommand { }
            Mock -ModuleName Onboarding Invoke-OnboardingAuthCheck { }
        }

        It 'calls Invoke-OnboardingAuthCheck for gh (TA_PTC_011) when -IncludeAuth is set' {
            Test-OnboardingSoftware -Ids @('TA_PTC_011') -IncludeAuth
            Should -Invoke Invoke-OnboardingAuthCheck -ModuleName Onboarding -Times 1
        }

        It 'does not call Invoke-OnboardingAuthCheck without -IncludeAuth' {
            Test-OnboardingSoftware -Ids @('TA_PTC_011')
            Should -Invoke Invoke-OnboardingAuthCheck -ModuleName Onboarding -Times 0
        }

        It 'does not call Invoke-OnboardingAuthCheck for tools without an auth_command' {
            Test-OnboardingSoftware -Ids @('TA_PTC_004') -IncludeAuth
            Should -Invoke Invoke-OnboardingAuthCheck -ModuleName Onboarding -Times 0
        }
    }

    Context 'OS check grouping' {
        BeforeEach {
            Mock -ModuleName Onboarding Test-OnboardingWindowsVersion { }
        }

        It 'calls Test-OnboardingWindowsVersion exactly once when multiple OS IDs are given' {
            Test-OnboardingSoftware -Ids @('TA_PTC_002', 'TA_PTC_003')
            Should -Invoke Test-OnboardingWindowsVersion -ModuleName Onboarding -Times 1
        }

        It 'passes both versions in AllowedVersions when Windows 10 and 11 IDs are given' {
            Test-OnboardingSoftware -Ids @('TA_PTC_002', 'TA_PTC_003')
            Should -Invoke Test-OnboardingWindowsVersion -ModuleName Onboarding -Times 1 `
                -ParameterFilter { $AllowedVersions -contains '10' -and $AllowedVersions -contains '11' }
        }
    }
}
