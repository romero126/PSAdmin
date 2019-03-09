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
        #Set Manifesto
        #Validate [POS] Set Value
        #Validate [POS] Pipeline Input
        #Validate [POS] Take WildCard Input
        #Validate [POS] not throw Terminating Errors
        #Validate [POS] Take Positional Values
        #Validate [POS] Passthru
        #Validate [POS] Exact
        #Validate [POS] Wildcard
#        #Validate [POS] NonExistant
#        #Validate [NEG] 

        it "Validate [POS] Set Value" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set"
            Set-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set" -Description "Computer_Set"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set" | ForEach-Object Description | Should -Be "Computer_Set"
        }

        it "Validate [POS] Take Wildcard Input" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_Wildcard"
            Set-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_Wild*" -Description "Computer_Set_WildCard"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_Wildcard" | ForEach-Object Description | Should -Be "Computer_Set_WildCard"
        }

        it "Validate [POS] Pipeline Input" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_Pipeline"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_Pipeline" | Set-PSAdminComputer -Description "Computer_Set_Pipeline"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_Pipeline" | ForEach-Object Description | Should -Be "Computer_Set_Pipeline"
        }

        it "Validate [POS] Positional Values" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_Positional"
            Set-PSAdminComputer $VaultName "Computer_Set_Positional" -Description "Computer_Set_Positional"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_Positional" | ForEach-Object Description | Should -Be "Computer_Set_Positional"
        }

        it "Validate [POS] Passthru" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_PassThru"
            Set-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_PassThru" -Description "Computer_Set_PassThru" -PassThru | ForEach-Object Description | Should -Be "Computer_Set_PassThru"
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