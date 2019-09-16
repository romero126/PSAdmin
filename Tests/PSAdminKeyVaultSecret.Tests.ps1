describe -Name "PSAdminKeyVault" {
    
    BeforeAll {
        Import-Module $PSScriptRoot\..\Module\PSAdmin\PSAdmin.psm1 -Force
#        Open-PSAdmin -Path "$PSScriptRoot/TestDatabase/DBConfig.xml"
        Open-PSAdmin -SQLConnectionString "Data Source=$PSScriptRoot/PSAdmin.DB;Pooling=True;FailIfMissing=False;Synchronous=Full;"
        $VaultName      = "Vault_Secret_Test"
        #$SecretValue    = (1..25 | ForEach-Object { [char]( (65..90), (97..122) | Get-Random ) } ) -join ""
        $SecretValue = [Guid]::NewGuid().ToString().Replace('-', '')
        New-PSAdminKeyVault -VaultName $VaultName
    }

    Context "New-PSAdminKeyVaultSecret" {
        it -Name "Validate [POS] Create KeyVaultSecret" {
            New-PSAdminKeyVaultSecret -VaultName $VaultName -Name "New" -SecretValue $SecretValue
            Get-PSAdminKeyVaultSecret -VaultName $VaultName -Name "New" | Should -HaveCount 1
        }
        
        it "Validate [NEG] Create KeyVaultSecret with Duplicate Name" {
            { New-PSAdminKeyVaultSecret -VaultName $VaultName -Name "New" -SecretValue $SecretValue } | Should -Throw
        }
    }

    Context "Get-PSAdminKeyVaultSecret" {
        it "Validate [POS] Get Null" {
            Get-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Get_Null" | Should -HaveCount 0
        }

        it "Validate [POS] Get" {
            New-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Get" -SecretValue $SecretValue
            Get-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Get" | Should -HaveCount 1
        }

        it "Validate [POS] Get Exact" {
            New-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Get_Exact" -SecretValue $SecretValue
            Get-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Get_Exact" -Exact | Should -HaveCount 1
            Get-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Get*" -Exact | Should -HaveCount 0
        }

        it "Validate [POS] Get WithoutSecret" {
            New-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Get_WithoutSecret" -SecretValue $SecretValue
            Get-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Get_WithoutSecret" -WithoutSecret | Should -HaveCount 1
            Get-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Get_WithoutSecret" -WithoutSecret | ForEach-Object SecretValue | Should -Be $null
        }

        it "Validate [POS] Get Wildcard" {
            Get-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Get*" | Should -HaveCount 3
        }

        it "Validate [POS] Get SecretValue [SecureString]" {
            New-PSAdminkeyVaultSecret -VaultName $VaultName -Name "Get_SecureString" -SecretValue $SecretValue
            Get-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Get_SecureString" | ForEach-Object SecretValue | Should -BeOfType [SecureString]
        }

        it "Validate [POS] Get SecretValue [String]" {
            New-PSAdminkeyVaultSecret -VaultName $VaultName -Name "Get_Decrypted" -SecretValue $SecretValue
            Get-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Get_Decrypted" -Decrypt | ForEach-Object SecretValue | Should -Be $SecretValue
        }
    }

    Context "Set-PSAdminKeyVault" {
        it "Validate [POS] Set Item" {
            New-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Set" -SecretValue ([Guid]::NewGuid().ToString())
            Set-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Set" -SecretValue $SecretValue
            Get-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Set" -Decrypt | ForEach-Object SecretValue | Should -Be $SecretValue
        }
    }
    
    Context "Remove-PSAdminKeyVault" {
        it "Validate [POS] Remove Vault" {
            New-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Remove" -SecretValue $SecretValue
            Remove-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Remove" -Confirm:$false
            Get-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Remove" | Should -BeNullOrEmpty
        }
        it "Validate [NEG] Remove NonExistant Vault" {
            { Remove-PSAdminKeyVaultSecret -VaultName $VaultName -Name "Remove_NonExistant" -Confirm:$false } | Should -Throw 
        }

    }

    Context "Cleanup" {
        it "Cleanup" {
            Remove-PSAdminKeyVaultSecret -VaultName $VaultName -Name "*" -Match -Confirm:$false
            
            Get-PSAdminKeyVaultSecret -VaultName $VaultName -Name "*" | Should -HaveCount 0
            write-host "Cleanup"

            Remove-PSAdminKeyVault -VaultName $VaultName -Confirm:$false
            Get-PSAdminKeyVault -VaultName $VaultName | Should -HaveCount 0
        }
    }
}
