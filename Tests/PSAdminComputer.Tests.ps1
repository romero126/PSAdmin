describe "PSAdminComputer" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\Module\PSAdmin\PSAdmin.psm1 -Force
        Open-PSAdmin -Path "$PSScriptRoot/TestDatabase/DBConfig.xml"
        $VaultName      = "Vault_Computer_Test"
        New-PSAdminKeyVault -VaultName $VaultName -ErrorAction SilentlyContinue
    }
    AfterAll {
        Remove-PSAdminKeyVault -VaultName $VaultName -Confirm:$False
    }
    Context "New-PSAdminComputer" {
        it "Validate [POS] Create Machine" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_New"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_New" | Should -HaveCount 1
        }

        it "Validate [NEG] Create Machine with Duplicate Name" {
            { New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_New" } | Should -Throw
        }
    }

    Context "Get-PSAdminComputer" {
        it "Validate [POS] Get Null" {
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Get_Null" | Should -HaveCount 0
        }

        it "Validate [POS] Get" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Get"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Get" | Should -HaveCount 1
        }

        it "Validate [POS] Get Exact" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Get_Exact"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Get_Exact" | Should -HaveCount 1
        }

        it "Validate [POS] Get Wildcard" {
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Get*" | Should -HaveCount 2
        }

    }

    Context "Set-PSAdminComputer" {
        #Set Item should be wildcard only.
        it "Validate [POS] Set Value" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set"
            Set-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set" -Description "Computer_Set"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set" | ForEach-Object Description | Should -Be "Computer_Set"
        }
    }

    Context "Remove-PSAdminComputer" {
        it "Validate [POS] Remove Exact" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_Exact"
            Remove-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_Exact" -Confirm:$False
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_Exact" | Should -BeNullOrEmpty

        }
        
        it "Validate [POS] Remove WildCard" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_WildCard1"
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_WildCard2"
            Remove-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_WildCard*" -Confirm:$false -Match
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_WildCard*" | Should -BeNullOrEmpty
        }

        it "Validate [NEG] Remove NonExistant" {
            { Remove-PSAdminKeyVault -VaultName $VaultName -ComputerName "Computer_Remove_Null" } | Should -Throw 
        }

    }

    Context "Cleanup" {
        Remove-PSAdminComputer -VaultName $VaultName -ComputerName "*" -Confirm:$false -Match
        Get-PSAdminComputer -VaultName $VaultName -ComputerName "*" | Should -HaveCount 0
    }

}