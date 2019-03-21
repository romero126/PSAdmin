describe -Name "PSAdminKeyVault" {

    BeforeAll {
        Import-Module $PSScriptRoot\..\Module\PSAdmin\PSAdmin.psm1 -Force
        Open-PSAdmin -Path "$PSScriptRoot/TestDatabase/DBConfig.xml"
    }

    Context "New-PSAdminKeyVault" {
        it "Validate [POS] New" {
            New-PSAdminKeyVault -VaultName "Vault_New"
            Get-PSAdminKeyVault -VaultName "Vault_New" | Should -HaveCount 1
        }
        it "Validate [NEG] New Duplicate" { 
            { New-PSAdminKeyVault -VaultName "Vault_New" } | Should -Throw
        }
        it "Validate [POS] New Pipeline" {
            "Vault_New_Pipeline1", "Vault_New_Pipeline2" | New-PSAdminKeyVault -Location "Value"
            Get-PSAdminKeyVault -VaultName "Vault_New_Pipeline*" | Should -HaveCount 2
        }
        it "Validate [POS] New Positional" {
            New-PSAdminKeyVault "Vault_New_Positional"
            Get-PSAdminKeyVault -VaultName "Vault_New_Positional" | Should -HaveCount 1
        }
        it "Validate [POS] New Passthru" {
            New-PSAdminKeyVault -VaultName "Vault_New_Passthru" -PassThru | Should -HaveCount 1
        }
    }

    Context "Get-PSAdminKeyVault" {
        it "Validate [POS] Get" {
            New-PSAdminKeyVault -VaultName "Vault_Get"
            Get-PSAdminKeyVault "Vault_Get" | Should -HaveCount 1
        }

        it "Validate [POS] Get Null" {
            Get-PSAdminKeyVault "Vault_Get_Null" | Should -HaveCount 0
        }

        it "Validate [POS] Get Exact" {
            New-PSAdminKeyVault -VaultName "Vault_Get_Exact"
            Get-PSAdminKeyVault "Vault_Get_Exact" | Should -HaveCount 1
        }

        it "Validate [POS] Get Wildcard" {
            Get-PSAdminKeyVault -VaultName "Vault_Get*" | Should -HaveCount 2
        }
        it "Validate [POS] Get Pipeline String" {
            New-PSAdminKeyVault -VaultName "Vault_Get_Pipeline_String"
            "Vault_Get_Pipeline_String" | Get-PSAdminKeyVault | Should -HaveCount 1
        }
        it "Validate [POS] Get Pipeline Object" {
            New-PSAdminKeyVault -VaultName "Vault_Get_Pipeline_Object" 
            [PSCustomObject]@{
                VaultName = "Vault_Get_Pipeline_Object"
            } | Get-PSAdminKeyVault | Should -HaveCount 1
        }
        it "Validate [POS] Get Positional" {
            New-PSAdminKeyVault -VaultName "Vault_Get_Positional"
            Get-PSAdminKeyVault "Vault_Get_Positional" | Should -HaveCount 1
        }
    }

    Context "Set-PSAdminKeyVault" {
        it "Validate [POS] Set" {
            New-PSAdminKeyVault -VaultName "Vault_Set"
            Set-PSAdminKeyVault -VaultName "Vault_Set" -Location "Vault_Set" -Exact
            Get-PSAdminKeyVault -VaultName "Vault_Set" | ForEach-Object Location | Should -Be "Vault_Set"
        }

        it "Validate [POS] Set Wildcard" {
            New-PSAdminKeyVault -VaultName "Vault_Set_Wildcard"
            Set-PSAdminKeyVault -VaultName "Vault_Set_Wild*" -Location "Vault_Set_WildCard"
            Get-PSAdminKeyVault -VaultName "Vault_Set_Wildcard" | ForEach-Object Location | Should -Be "Vault_Set_WildCard"
        }

        it "Validate [POS] Set Pipeline" {
            New-PSAdminKeyVault -VaultName "Vault_Set_Pipeline"
            Get-PSAdminKeyVault -VaultName "Vault_Set_Pipeline" | Set-PSAdminKeyVault -Location "Vault_Set_Pipeline"
            Get-PSAdminKeyVault -VaultName "Vault_Set_Pipeline" | ForEach-Object Location | Should -Be "Vault_Set_Pipeline"
        }

        it "Validate [POS] Set Positional" {
            New-PSAdminKeyVault -VaultName "Vault_Set_Positional"
            Set-PSAdminKeyVault "Vault_Set_Positional" -Location "Vault_Set_Positional"
            Get-PSAdminKeyVault -VaultName "Vault_Set_Positional" | ForEach-Object Location | Should -Be "Vault_Set_Positional"
        }

        it "Validate [POS] Set Passthru" {
            New-PSAdminKeyVault -VaultName "Vault_Set_PassThru"
            Set-PSAdminKeyVault -VaultName "Vault_Set_PassThru" -Location "Vault_Set_PassThru" -PassThru | ForEach-Object Location | Should -Be "Vault_Set_PassThru"
        }
    }

    Context "Remove-PSAdminKeyVault" {
        it "Validate [POS] Remove" {
            New-PSAdminKeyVault -VaultName "Vault_Remove"
            Remove-PSAdminKeyVault -VaultName "Vault_Remove" -Confirm:$False
            Get-PSAdminKeyVault -VaultName "Vault_Remove" | Should -BeNullOrEmpty
        }
        
        it "Validate [NEG] Remove Null" {
            { Remove-PSAdminKeyVault -VaultName "Vault_Remove_Null" -ErrorAction Stop } | Should -Throw 
        }
        
        it "Validate [POS] Remove WildCard" {
            New-PSAdminKeyVault -VaultName "Vault_Remove_WildCard1"
            New-PSAdminKeyVault -VaultName "Vault_Remove_WildCard2"
            Remove-PSAdminKeyVault -VaultName "Vault_Remove_Wild*" -Confirm:$False -Match
            Get-PSAdminKeyVault -VaultName "Vault_Remove_Wild*" | Should -BeNullOrEmpty
        }
        it "Validate [POS] Remove Pipeline" {
            New-PSAdminKeyVault -VaultName "Vault_Remove_Pipeline1"
            New-PSAdminKeyVault -VaultName "Vault_Remove_Pipeline2"
            New-PSAdminKeyVault -VaultName "Vault_Remove_Pipeline3"
            Get-PSAdminKeyVault -VaultName "Vault_Remove_Pipeline*" | Remove-PSAdminKeyVault -Confirm:$False
            Get-PSAdminKeyVault -VaultName "Vault_Remove_Pipeline" | Should -BeNullOrEmpty
        }
        it "Validate [POS] Remove Positional" {
            New-PSAdminKeyVault -VaultName "Vault_Remove_Positional"
            Remove-PSAdminKeyVault "Vault_Remove_Positional" -Confirm:$False
            Get-PSAdminKeyVault -VaultName "Vault_Remove_Positional" | Should -BeNullOrEmpty
        }

    }

    Context "Protect-PSAdminKeyVault" {

    }

    Context "Unprotect-PSAdminKeyVault" {

    }

    Context "Cleanup" {
        it "Cleanup" {
            Remove-PSAdminKeyVault -VaultName "*" -Confirm:$False -Match
            Get-PSAdminKeyVault -VaultName "*" | Should -HaveCount 0
        }
    }

}
