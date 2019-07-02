Describe "PSAdminKeyVaultCertificate" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\Module\PSAdmin\PSAdmin.psd1 -Force

        Open-PSAdmin -SQLConnectionString "Data Source=$PSScriptRoot/PSAdmin.DB;Pooling=True;FailIfMissing=False;Synchronous=Full;"

        $VaultName      = "Vault_Certificate_Test"
        $CertPath       = "$PSScriptRoot/PSAdmin.KeyVaultCertificate.Tests.pfx"
        $CertThumb      = "B86837D68B56856BC0C2E79361954E63E0A98A6F"
        $CertPass       = $CertThumb | ConvertTo-SecureString -AsPlainText -Force
        
        $CertRaw        =   switch ($PSVersionTable.PSEdition)
                            {
                                "Desktop" {
                                    Get-Content -Path $CertPath -Encoding Byte
                                }
                                "Core" {
                                    Get-Content -Path $CertPath -AsByteStream
                                }
                                Default {
                                    throw "Cannot Determine Compatable Version"
                                }    
                            }
        $CertBase64     = [Convert]::ToBase64String($CertRaw)
        New-PSAdminKeyVault -VaultName $VaultName
    }

    AfterAll {

    }
    Context "Import-PSAdminKeyVaultCertificate" {
        it "Validate [POS] Import -FileName" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Import-FileName"
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Import-FileName" | Should -HaveCount 1
        }

        it "Validate [POS] Import -CertificateString" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -CertificateString $CertBase64 -Name "Import-CertificateString"
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Import-CertificateString" | Should -HaveCount 1
        }
        
        it "Validate [NEG] Duplicate" {
            $CertPass = $CertThumb | ConvertTo-SecureString -AsPlainText -Force
            { Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Import-FileName" -ErrorAction Stop } | Should -Throw
        }
    }

    Context "Export-PSAdminKeyVaultCertificate" {
        it "Validate [POS] Export" {
            #Validating this is unique a unique process.
        }
    }

    Context "Get-PSAdminKeyVaultCertificate" {

        it "Validate [POS] Get" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Certificate_Get"
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Get" | Should -HaveCount 1
        }

        it "Validate [POS] Get Null" {
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Get_Null" | Should -HaveCount 0
        }

        it "Validate [POS] Get Exact" {

            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Certificate_Get_Exact0"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Certificate_Get_Exact1"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Certificate_Get_Exact"
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Get_Exact" -Exact | % Name | Should -Be "Certificate_Get_Exact"
        }

        it "Validate [POS] Get Wildcard" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Certificate_Get_WildCard1"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Certificate_Get_WildCard2"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Certificate_Get_WildCard3"
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Get_WildCard*" | Should -HaveCount 3
        }
        it "Validate [POS] Get Pipeline String" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Certificate_Get_Pipeline"
            "Certificate_Get_Pipeline" | Get-PSAdminKeyVaultCertificate -VaultName $VaultName | Should -HaveCount 1
        }
        it "Validate [POS] Get Pipeline Object" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Certificate_Get_Pipeline_Object" 
            [PSCustomObject]@{
                VaultName       = $VaultName
                Name            = "Certificate_Get_Pipeline_Object"
            } | Get-PSAdminKeyVaultCertificate | Should -HaveCount 1
        }
        it "Validate [POS] Get Positional" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Certificate_Get_Positional"
            Get-PSAdminKeyVaultCertificate $VaultName "Certificate_Get_Positional" | Should -HaveCount 1
        }
    }

    Context "Remove-PSAdminKeyVaultCertificate" {
        it "Validate [POS] Remove" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Certificate_Remove"
            Remove-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Remove" -Confirm:$False
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Remove" | Should -BeNullOrEmpty
        }
        
        it "Validate [NEG] Remove Null" {
            { Remove-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Remove_Null" -ErrorAction Stop } | Should -Throw 
        }
        
        it "Validate [POS] Remove WildCard" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Certificate_Remove_WildCard1"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Certificate_Remove_WildCard2"
            Remove-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Remove_Wild*" -Confirm:$False -Match
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Remove_Wild*" | Should -BeNullOrEmpty
        }
        it "Validate [POS] Remove Pipeline" {
            
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Certificate_Remove_Pipeline1"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Certificate_Remove_Pipeline2"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Certificate_Remove_Pipeline3"
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Remove_Pipeline*" | Remove-PSAdminKeyVaultCertificate -Confirm:$False
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Remove_Pipeline*" | Should -BeNullOrEmpty
            
        }
        it "Validate [POS] Remove Positional" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FileName $CertPath -Name "Certificate_Remove_Positional"
            Remove-PSAdminKeyVaultCertificate $VaultName "Certificate_Remove_Positional" -Confirm:$False
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Remove_Positional" | Should -BeNullOrEmpty
        }
    }

    it "Cleanup" {
        Remove-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "*" -Confirm:$False -Match
        Remove-PSAdminKeyVault -VaultName $VaultName -Confirm:$false
        Get-PSAdminKeyVault -VaultName $VaultName | Should -HaveCount 0
    }
}