Describe "PSAdminKeyVaultCertificate" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\Module\PSAdmin\PSAdmin.psm1 -Force

        Open-PSAdmin -Path "$PSScriptRoot/TestDatabase/DBConfig.xml"

        $VaultName      = "Vault_Certificate_Test"
        $CertPath       = "$PSScriptRoot/PSAdminKeyVaultCertificate.Tests.pfx"
        $CertThumb      = "B86837D68B56856BC0C2E79361954E63E0A98A6F"
        $CertPass       = $CertThumb | ConvertTo-SecureString -AsPlainText -Force
        $CertRaw        = [System.Text.Encoding]::Default.GetBytes( (Get-Content -Path $CertPath -Raw) )
        $CertBase64     = [Convert]::ToBase64String($CertRaw)
        New-PSAdminKeyVault -VaultName $VaultName
    }

    Context "Import-PSAdminKeyVaultCertificate" {
        it "Validate [POS] Import -FilePath" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FilePath $CertPath -Name "Import-FilePath"
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Import-FilePath" | Should -HaveCount 1
        }
        it "Validate [POS] Import -CertificateString" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -CertificateString $CertBase64 -Name "Import-CertificateString"
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Import-CertificateString" | Should -HaveCount 1
        }
        it "Validate [NEG] Duplicate" {
            $CertPass = $CertThumb | ConvertTo-SecureString -AsPlainText -Force
            { Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FilePath $CertPath -Name "Import-FilePath" -ErrorAction Stop } | Should -Throw
        }
    }

    Context "Get-PSAdminKeyVaultCertificate" {
        it "Validate [POS] Get NonExistant" {
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "GET_NULL" | Should -HaveCount 0

        }
        it "Validate [POS] Get" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FilePath $CertPath -Name "GET"
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "GET" | Should -HaveCount 1
        }
        it "Validate [POS] Get Exact" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FilePath $CertPath -Name "GET_Exact0"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FilePath $CertPath -Name "GET_Exact1"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FilePath $CertPath -Name "GET_Exact"
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "GET_Exact" -Exact | % Name | Should -Be "GET_Exact"
        }
        it "Validate [POS] Get Wildcard" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FilePath $CertPath -Name "GET_WILDCARD1"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FilePath $CertPath -Name "GET_WILDCARD2"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FilePath $CertPath -Name "GET_WILDCARD3"
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "GET_WILDCARD*" | Should -HaveCount 3
        }
    }

    Context "Remove-PSAdminKeyVaultCertificate" {
        it "Validate [POS] Remove" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPass -FilePath $CertPath -Name "REMOVE"
            Remove-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "REMOVE" -Confirm:$false
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "REMOVE" | Should -HaveCount 0
        }
        it "Validate [POS] NonExistant" {
            { Remove-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "REMOVE_NULL" -Confirm:$false -ErrorAction Stop } | Should -Throw
        }
    }

    Context "Export-PSAdminKeyVaultCertificate" {
        it "Validate [POS] Export" {
            #Validating this is unique a unique process.
        }
    }

    Context "Cleanup" {
        it "Cleanup" {
            Remove-PSAdminKeyVault -VaultName $VaultName -Confirm:$false
            Get-PSAdminKeyVault -VaultName $VaultName | Should -HaveCount 0
        }
    }

}