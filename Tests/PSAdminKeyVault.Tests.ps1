describe -Name "PSAdminKeyVault" {

    BeforeAll {
        Import-Module $PSScriptRoot\..\Module\PSAdmin\PSAdmin.psm1 -Force
        Open-PSAdmin -Path "$PSScriptRoot/TestDatabase/DBConfig.xml"
    }

    Context "New-PSAdminKeyVault" {
        
        it -Name "Validate [POS] Create KeyVault" {
            New-PSAdminKeyVault -VaultName "VaultTest"
            Get-PSAdminKeyVault -VaultName "VaultTest" | Should -HaveCount 1
        }
        
        it "Validate [NEG] Create KeyVault with Duplicate Vaultame" {
            { New-PSAdminKeyVault -VaultName "VaultTest" } | Should -Throw
        }

    }

    Context "Get-PSAdminKeyVault" {

        it "Validate [POS] Get" {
            Get-PSAdminKeyVault "VaultTest" | Should -HaveCount 1
        }

        it "Validate [POS] Get Wildcard" {
            New-PSAdminKeyVault -VaultName "VaultTest_Get1"
            New-PSAdminKeyVault -VaultName "VaultTest_Get2"
            Get-PSAdminKeyVault -VaultName "VaultTest_*" | Should -HaveCount 2
        }

    }

    Context "Set-PSAdminKeyVault" {
        it "Validate [POS] Set Item" {
            New-PSAdminKeyVault -VaultName "VaultTest_SetItem"
            Set-PSAdminKeyVault -VaultName "VaultTest_SetItem" -Location "VaultTest_SetItem"
            Get-PSAdminKeyVault -VaultName "VaultTest_SetItem" | ForEach-Object Location | Should -Be "VaultTest_SetItem"
        }
    }

    Context "Remove-PSAdminKeyVault" {
        it "Validate [POS] Remove Vault" {
            New-PSAdminKeyVault -VaultName "VaultTest_RemoveItem"
            Remove-PSAdminKeyVault -VaultName "VaultTest_RemoveItem" -Confirm:$false
            Get-PSAdminKeyVault -VaultName "VaultTest_RemoveItem" | Should -BeNullOrEmpty
        }
        it "Validate [NEG] Remove NonExistant Vault" {
            { Remove-PSAdminKeyVault -VaultName "VaultTest_RemoveItem" } | Should -Throw 
        }

    }

    Context "Protect-PSAdminKeyVault" {

    }

    Context "Unprotect-PSAdminKeyVault" {

    }

    Context "Cleanup" {
        it "Cleanup" {
            Remove-PSAdminKeyVault -VaultName "*" -Confirm:$false
        }
    }

}
