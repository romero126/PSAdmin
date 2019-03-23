describe -Name "PSAdminKeyVault" {

    BeforeAll {
        Import-Module $PSScriptRoot\..\Module\PSAdmin\PSAdmin.psm1 -Force
        Open-PSAdmin -Path "$PSScriptRoot/TestDatabase/DBConfig.xml"
        $VaultName      = "Vault_Computer_Test"
        New-PSAdminKeyVault -VaultName $VaultName -ErrorAction SilentlyContinue
    }

    AfterAll {
        Remove-PSAdminComputer -VaultName $VaultName -ComputerName "*" -Confirm:$False -Match
        Remove-PSAdminKeyVault -VaultName $VaultName -Confirm:$False
    }

    Context "New-PSAdminComputer" {
        it "Validate [POS] New" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_New"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_New" | Should -HaveCount 1
        }
        it "Validate [NEG] New Duplicate" { 
            { New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_New" -ErrorAction Stop } | Should -Throw
        }
        it "Validate [POS] New Pipeline" {
            "Computer_New_Pipeline1", "Computer_New_Pipeline2" | New-PSAdminComputer -VaultName $VaultName -Description "Value"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_New_Pipeline*" | Should -HaveCount 2
        }
        it "Validate [POS] New Positional" {
            New-PSAdminComputer $VaultName "Computer_New_Positional"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_New_Positional" | Should -HaveCount 1
        }
        it "Validate [POS] New Passthru" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_New_Passthru" -PassThru | Should -HaveCount 1
        }
    }

    Context "Get-PSAdminComputer" {
        it "Validate [POS] Get" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Get"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Get" | Should -HaveCount 1
        }

        it "Validate [POS] Get Null" {
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Get_Null" | Should -HaveCount 0
        }

        it "Validate [POS] Get Exact" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Get_Exact"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Get_Exact" | Should -HaveCount 1
        }

        it "Validate [POS] Get Wildcard" {
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Get*" | Should -HaveCount 2
        }
        it "Validate [POS] Get Pipeline String" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Get_Pipeline_String"
            "Computer_Get_Pipeline_String" | Get-PSAdminComputer -VaultName $VaultName | Should -HaveCount 1
        }
        it "Validate [POS] Get Pipeline Object" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Get_Pipeline_Object" 
            [PSCustomObject]@{
                VaultName       = $VaultName
                ComputerName    = "Computer_Get_Pipeline_Object"
            } | Get-PSAdminComputer | Should -HaveCount 1
        }
        it "Validate [POS] Get Positional" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Get_Positional"
            Get-PSAdminComputer $VaultName "Computer_Get_Positional" | Should -HaveCount 1
        }
    }
    
    Context "Set-PSAdminComputer" {
        it "Validate [POS] Set" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set"
            Set-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set" -Location "Computer_Set" -Exact
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set" | ForEach-Object Location | Should -Be "Computer_Set"
        }

        it "Validate [POS] Set Wildcard" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_Wildcard"
            Set-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_Wild*" -Location "Computer_Set_WildCard"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_Wildcard" | ForEach-Object Location | Should -Be "Computer_Set_WildCard"
        }

        it "Validate [POS] Set Pipeline" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_Pipeline"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_Pipeline" | Set-PSAdminComputer -Location "Computer_Set_Pipeline"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_Pipeline" | ForEach-Object Location | Should -Be "Computer_Set_Pipeline"
        }

        it "Validate [POS] Set Positional" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_Positional"
            Set-PSAdminComputer $VaultName "Computer_Set_Positional" -Location "Computer_Set_Positional"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_Positional" | ForEach-Object Location | Should -Be "Computer_Set_Positional"
        }

        it "Validate [POS] Set Passthru" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_PassThru"
            Set-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Set_PassThru" -Location "Computer_Set_PassThru" -PassThru | ForEach-Object Location | Should -Be "Computer_Set_PassThru"
        }
    }
    
    Context "Remove-PSAdminComputer" {
        it "Validate [POS] Remove" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove"
            Remove-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove" -Confirm:$False
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove" | Should -BeNullOrEmpty
        }
        
        it "Validate [NEG] Remove Null" {
            { Remove-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_Null" -ErrorAction Stop } | Should -Throw 
        }
        
        it "Validate [POS] Remove WildCard" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_WildCard1"
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_WildCard2"
            Remove-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_Wild*" -Confirm:$False -Match
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_Wild*" | Should -BeNullOrEmpty
        }
        it "Validate [POS] Remove Pipeline" {
            
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_Pipeline1"
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_Pipeline2"
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_Pipeline3"
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_Pipeline*" | Remove-PSAdminComputer -Confirm:$False
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_Pipeline*" | Should -BeNullOrEmpty
            
        }
        it "Validate [POS] Remove Positional" {
            New-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_Positional"
            Remove-PSAdminComputer $VaultName "Computer_Remove_Positional" -Confirm:$False
            Get-PSAdminComputer -VaultName $VaultName -ComputerName "Computer_Remove_Positional" | Should -BeNullOrEmpty
        }

    }
}
