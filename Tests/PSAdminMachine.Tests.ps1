describe "PSAdminMachine" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\Module\PSAdmin\PSAdmin.psm1 -Force
        Open-PSAdmin -Path "$PSScriptRoot/TestDatabase/DBConfig.xml"
        $VaultName      = "Vault_Machine_Test"
        New-PSAdminKeyVault -VaultName $VaultName
    }

    Context "New-PSAdminMachine" {
        it "Validate [POS] Create Machine" {
            New-PSAdminMachine -VaultName $VaultName -Name "Machine_New"
            Get-PSAdminMachine -VaultName $VaultName -Name "Machine_New" | Should -HaveCount 1
        }

        it "Validate [NEG] Create Machine with Duplicate Name" {
            { New-PSAdminMachine -VaultName $VaultName -Name "Machine_New" } | Should -Throw
        }
    }

    Context "Get-PSAdminMachine" {
        it "Validate [POS] Get Null" {
            Get-PSAdminMachine -VaultName $VaultName -Name "Machine_Get_Null" | Should -HaveCount 0
        }

        it "Validate [POS] Get" {
            New-PSAdminMachine -VaultName $VaultName -Name "Machine_Get"
            Get-PSAdminMachine -VaultName $VaultName -Name "Machine_Get" | Should -HaveCount 1
        }

        it "Validate [POS] Get Exact" {
            New-PSAdminMachine -VaultName $VaultName -Name "Machine_Get_Exact"
            Get-PSAdminMachine -VaultName $VaultName -Name "Machine_Get_Exact" | Should -HaveCount 1
        }

        it "Validate [POS] Get Wildcard" {
            Get-PSAdminMachine -VaultName $VaultName -Name "Machine_Get*" | Should -HaveCount 2
        }

    }

    Context "Set-PSAdminMachine" {
        #Set Item should be wildcard only.
        it "Validate [POS] Set Value" {
            New-PSAdminMachine -VaultName $VaultName -Name "Machine_Set"
            Set-PSAdminMachine -VaultName $VaultName -Name "Machine_Set" -Description "Machine_Set"
            Get-PSAdminMachine -VaultName $VaultName -Name "Machine_Set" | ForEach-Object Description | Should -Be "Machine_Set"
        }
    }

    Context "Remove-PSAdminMachine" {
        it "Validate [POS] Remove Exact" {
            New-PSAdminMachine -VaultName $VaultName -Name "Machine_Remove_Exact"
            Remove-PSAdminMachine -VaultName $VaultName -Name "Machine_Remove_Exact" -Confirm:$False
            Get-PSAdminMachine -VaultName $VaultName -Name "Machine_Remove_Exact" | Should -BeNullOrEmpty

        }
        
        it "Validate [POS] Remove WildCard" {
            New-PSAdminMachine -VaultName $VaultName -Name "Machine_Remove_WildCard1"
            New-PSAdminMachine -VaultName $VaultName -Name "Machine_Remove_WildCard2"
            Remove-PSAdminMachine -VaultName $VaultName -Name "Machine_Remove_WildCard*" -Confirm:$false -Match
            Get-PSAdminMachine -VaultName $VaultName -Name "Machine_Remove_WildCard*" | Should -BeNullOrEmpty
        }

        it "Validate [NEG] Remove NonExistant" {
            { Remove-PSAdminKeyVault -VaultName $VaultName -Name "Machine_Remove_Null" } | Should -Throw 
        }

    }

    Context "Cleanup" {
        Remove-PSAdminMachine -VaultName $VaultName -Name "*" -Confirm:$false -Match
        Get-PSAdminMachine -VaultName $VaultName -Name "*" | Should -HaveCount 0
    }
}