describe -Name "PSAdminKeyVault" {
    
    BeforeAll {
        Import-Module $PSScriptRoot\..\Module\PSAdmin\PSAdmin.psm1 -Force
        Open-PSAdmin -Path "$PSScriptRoot/TestDatabase/DBConfig.xml"
        New-PSAdminKeyVault -VaultName "VaultSecretTest"
    }

    Context "New-PSAdminKeyVaultSecret" {
        
        it -Name "Validate [POS] Create KeyVaultSecret" {
            New-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "New" -SecretValue "SecretValue"
            Get-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "New" | Should -HaveCount 1
        }
        
        it "Validate [NEG] Create KeyVaultSecret with Duplicate Name" {
            { New-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "New" } | Should -Throw
        }

    }

    Context "Get-PSAdminKeyVaultSecret" {

        it "Validate [POS] Get" {
            Get-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "*" | Should -HaveCount 1
        }

        it "Validate [POS] Get Wildcard" {
            New-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "GetWildCard01" -SecretValue "SecretValue"
            New-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "GetWildCard02" -SecretValue "SecretValue"
            Get-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "GetWildCard*" | Should -HaveCount 2
        }
        
        it "Validate [POS] Secret Value" {
            $SecretValue = [Guid]::NewGuid().ToString()
            New-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "GetSecretValue" -SecretValue $SecretValue
            Get-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "GetSecretValue" | ForEach-Object SecretValue | Should -BeOfType SecureString
        }

        it "Validate [POS] Secret Value Decrypted" {
            $SecretValue = [Guid]::NewGuid().ToString()
            New-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "GetSecretValueDecrypted" -SecretValue $SecretValue
            Get-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "GetSecretValueDecrypted" -Decrypt | ForEach-Object SecretValue | Should -Be $SecretValue
        }

    }

    Context "Set-PSAdminKeyVault" {
        it "Validate [POS] Set Item" {
            $SecretValue = [Guid]::NewGuid().ToString()
            New-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "SetSecretValue" -SecretValue "NotYah"
            Set-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "SetSecretValue" -SecretValue $SecretValue
            Get-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "SetSecretValue" -Decrypt | ForEach-Object SecretValue | Should -Be $SecretValue
        }
    }

    Context "Remove-PSAdminKeyVault" {
        it "Validate [POS] Remove Vault" {
            New-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "RemoveSecretValue" -SecretValue "Test"
            Remove-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "RemoveSecretValue"
            Get-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "RemoveSecretValue" | Should -BeNullOrEmpty
        }
        it "Validate [NEG] Remove NonExistant Vault" {
            { Remove-PSAdminKeyVaultSecret -VaultName "VaultSecretTest" -Name "RemoveNonExist" } | Should -Throw 
        }

    }

    Context "Cleanup" {
        it "Cleanup" {
            Remove-PSAdminKeyVault -VaultName "*" -Confirm:$false
        }
    }

}
