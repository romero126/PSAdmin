describe -Name "PSAdminKeyVault" {

    BeforeAll {
        Import-Module $PSScriptRoot\..\Module\PSAdmin\PSAdmin.psm1 -Force
        Open-PSAdmin -Path "$PSScriptRoot/TestDatabase/DBConfig.xml"
    }

    Context "New-PSAdminKeyVault" {
        
        it -Name "Validate [POS] Create KeyVault" {
            New-PSAdminKeyVault -VaultName "Vault_New"
            Get-PSAdminKeyVault -VaultName "Vault_New" | Should -HaveCount 1
        }
        
        it "Validate [NEG] Create KeyVault with Duplicate Vaultame" {
            { New-PSAdminKeyVault -VaultName "Vault_New" } | Should -Throw
        }

    }

    Context "Get-PSAdminKeyVault" {
        it "Validate [POS] Get Null" {
            Get-PSAdminKeyVault "Vault_GetNull" | Should -HaveCount 0
        }

        it "Validate [POS] Get" {
            New-PSAdminKeyVault -VaultName "Vault_Get"
            Get-PSAdminKeyVault "Vault_Get" | Should -HaveCount 1
        }

        it "Validate [POS] Get Exact" {
            New-PSAdminKeyVault -VaultName "Vault_Get_Exact"
            Get-PSAdminKeyVault "Vault_Get_Exact" | Should -HaveCount 1
        }

        it "Validate [POS] Get Wildcard" {
            Get-PSAdminKeyVault -VaultName "Vault_Get*" | Should -HaveCount 2
        }

    }

    Context "Set-PSAdminKeyVault" {
        #Set Item should be wildcard only.
        it "Validate [POS] Set Item" {
            New-PSAdminKeyVault -VaultName "Vault_Set"
            Set-PSAdminKeyVault -VaultName "Vault_Set" -Location "Vault_SetValue"
            Get-PSAdminKeyVault -VaultName "Vault_Set" | ForEach-Object Location | Should -Be "Vault_SetValue"
        }
    }

    Context "Remove-PSAdminKeyVault" {

        it "Validate [POS] Remove Vault Exact" {
            New-PSAdminKeyVault -VaultName "Vault_Remove_Exact"
            Remove-PSAdminKeyVault -VaultName "Vault_Remove_Exact" -Confirm:$False
            Get-PSAdminKeyVault -VaultName "Vault_Remove_Exact" | Should -BeNullOrEmpty

        }
        
        it "Validate [POS] Remove Vault WildCard" {
            New-PSAdminKeyVault -VaultName "Vault_Remove_WildCard1"
            New-PSAdminKeyVault -VaultName "Vault_Remove_WildCard2"
            Remove-PSAdminKeyVault -VaultName "Vault_Remove_Wild*" -Confirm:$false -Match
            Get-PSAdminKeyVault -VaultName "Vault_Remove_Wild*" | Should -BeNullOrEmpty
        }

        it "Validate [NEG] Remove NonExistant Vault" {
            { Remove-PSAdminKeyVault -VaultName "Vault_Remove_Null" } | Should -Throw 
        }

    }

    Context "Protect-PSAdminKeyVault" {

    }

    Context "Unprotect-PSAdminKeyVault" {

    }

    Context "Cleanup" {
        it "Cleanup" {
            Remove-PSAdminKeyVault -VaultName "*" -Confirm:$false -Match
            Get-PSAdminKeyVault -VaultName "*" | Should -HaveCount 0
        }
    }

}
