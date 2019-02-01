Write-Warning "Running tests for PSAdminMachine"

describe "PSAdminMachine" {
    BeforeAll {
        $PSModuleArgs = @{
            Path                    = "$PSScriptRoot/TestDatabase/"
            DBConfigFile            = "DBConfig.xml"
        }
        Import-Module $PWD\Source\PSAdmin.psm1 -ArgumentList $PSModuleArgs -Force
    }
    Context "New-PSAdminMachine" {
        it "Validate [POS] Create Machine" {
            New-PSAdminMachine -Name "Test1" -Description "Test Data"
            Get-PSAdminMachine -Name "Test1" | Should -HaveCount 1
        }

        it "Validate [NEG] Create Machine with Duplicate Name" {
            { New-PSAdminMachine -Name "Test1" -Description "Should fail" } | Should -Throw
        }
    }

    Context "Get-PSAdminMachine" {
        it "Validate [POS] Get" {
            Get-PSAdminMachine "*" | Should -HaveCount 1
        }

        it "Validate [POS] Get Wildcard" {
            New-PSAdminMachine -Name "Test_Get1" -Description "Test_Get1"
            New-PSAdminMachine -Name "Test_Get2" -Description "Test_Get2"
            Get-PSAdminMachine -Name "Test_G*" | Should -HaveCount 2
        }
    }

    Context "Set-PSAdminMachine" {
        it "Validate [POS] Set Value" {
            New-PSAdminMachine -Name "Test_Set" -Description "Test_Set"
            Set-PSAdminMachine -Name "Test_Set" -Description "ValidateMe"
            Get-PSAdminMachine -Name "Test_Set" | ForEach-Object Description | Should -be "ValidateMe"
        }
    }

    Context "Remove-PSAdminMachine" {
        it "Validate [POS] Validate Removal" {
            Remove-PSAdminMachine -Name "Test_*"
            Get-PSAdminMachine -Name "Test_*" | Should -HaveCount 0
        }
    }

    Context "Cleanup" {
        Remove-PSAdminMachine -Name "*"
        Get-PSAdminMachine -Name "*" | Should -HaveCount 0
    }
}