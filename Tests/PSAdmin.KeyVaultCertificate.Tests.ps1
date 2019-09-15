function New-TempCert {
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ipaddress[]]$IP = [IPAddress]::Parse([String] (Get-Random) ).IPAddressToString,

        [Parameter()]
        [String[]]$DnsName = (-join ((65..90) + (97..122) | Get-Random -Count 10 | ForEach-Object {[char]$_})),

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]$DistinguishedName = "CN=TestCert",

        [Parameter()]
        [String]$PFXPass = 'TestPass'
    )

    $sanBuilder = [System.Security.Cryptography.X509Certificates.SubjectAlternativeNameBuilder]::new()

    $IP.ForEach{
        $sanBuilder.AddIpAddress($_.IPAddressToString)
    }

    $DnsName.ForEach{
        $sanBuilder.AddDnsName($_)
    }

    $distinguishedNameObj = [System.Security.Cryptography.X509Certificates.X500DistinguishedName]::new("$DistinguishedName")
    
    $rsa = [System.Security.Cryptography.RSA]::Create(2048)
    
    $request = [System.Security.Cryptography.X509Certificates.CertificateRequest]::new($distinguishedNameObj, $rsa, [System.Security.Cryptography.HashAlgorithmName]::SHA256, [System.Security.Cryptography.RSASignaturePadding]::Pkcs1)
    
    $request.CertificateExtensions.Add(
        [System.Security.Cryptography.X509Certificates.X509KeyUsageExtension]::new(
            (
                [System.Security.Cryptography.X509Certificates.X509KeyUsageFlags]::DataEncipherment -bor 
                [System.Security.Cryptography.X509Certificates.X509KeyUsageFlags]::KeyEncipherment -bor
                [System.Security.Cryptography.X509Certificates.X509KeyUsageFlags]::DigitalSignature
            ), $false)
    )
    
    $oid = [System.Security.Cryptography.Oid]::new("1.3.6.1.5.5.7.3.1")
    $oidCollection = [System.Security.Cryptography.OidCollection]::new()
    $null = $oidCollection.Add($oid)
    
    $extension = [System.Security.Cryptography.X509Certificates.X509EnhancedKeyUsageExtension]::new($oidCollection, $true)
    
    $request.CertificateExtensions.Add(
        $extension
    )
    
    $request.CertificateExtensions.Add($sanBuilder.Build())
    
    $certificate = $request.CreateSelfSigned(
        [System.DateTimeOffset]::new(([datetime]::UtcNow).AddDays(-1)),
        [System.DateTimeOffset]::new(([datetime]::UtcNow).AddDays(3650))
    )

    $certificate
}


Describe "PSAdminKeyVaultCertificate" {
    BeforeAll {
        #region Certificate
        $CertPath = Join-Path -Path $PSScriptRoot -ChildPath "PSAdmin.KeyVaultCertificate.Tests-dynamic.pfx"
        $CertPath_ExportFileName = Join-Path $PSScriptRoot -ChildPath "Import-FileName_Export.pfx"
        $CertPath_ExportString = Join-Path $PSScriptRoot -ChildPath "Import-CertificateString_Export.pfx"

        $CertPassStr = ( -join ((33..126) | Get-Random -Count 32 | ForEach-Object { [char]$_ }))
        $CertPassSecStr = "$CertPassStr" | ConvertTo-SecureString -AsPlainText -Force 
        
        $Cert = New-TempCert -PFXPass $CertPassStr
        $CertThumb = $Cert.Thumbprint

        [io.file]::WriteAllBytes($CertPath, $Cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pfx, "$CertPassStr"))

        $CertRaw = switch ($PSVersionTable.PSEdition) {
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
        $CertBase64 = [Convert]::ToBase64String($CertRaw)
        #endregion

        Import-Module $PSScriptRoot\..\Module\PSAdmin\PSAdmin.psd1 -Force

        Open-PSAdmin -SQLConnectionString "Data Source=$PSScriptRoot/PSAdmin.DB;Pooling=True;FailIfMissing=False;Synchronous=Full;"

        $VaultName = "Vault_Certificate_Test"

        New-PSAdminKeyVault -VaultName $VaultName

    }

    Context "Import-PSAdminKeyVaultCertificate" {
        it "Validate [POS] Import -FileName" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Import-FileName"
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Import-FileName" | Should -HaveCount 1
        }

        it "Validate [POS] Import -CertificateString" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -CertificateString $CertBase64 -Name "Import-CertificateString"
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Import-CertificateString" | Should -HaveCount 1
        }
        
        it "Validate [NEG] Duplicate" {
            { Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Import-FileName" -ErrorAction Stop } | Should -Throw
        }
    }

    Context "Export-PSAdminKeyVaultCertificate" {
        it "Validate [POS] Export" {
            Export-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Import-FileName" -FileName $CertPath_ExportFileName -Password $CertPassSecStr
            Test-Path $CertPath_ExportFileName | Should -Be $true
            Export-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Import-CertificateString" -FileName $CertPath_ExportString -Password $CertPassSecStr
            Test-Path $CertPath_ExportString | Should -Be $true
        }

        it "Validate [POS] Cert Thumbprint Match -FileName" {
            $certObj = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList $CertPath_ExportFileName, $CertPassSecStr, ([System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
            $certObj.Thumbprint | Should -Be $CertThumb
        }

        it "Validate [POS] Cert Thumbprint Match -CertificateString" {
            $certObj = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList $CertPath_ExportString, $CertPassSecStr, ([System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
            $certObj.Thumbprint | Should -Be $CertThumb
        }
    }

    Context "Get-PSAdminKeyVaultCertificate" {

        it "Validate [POS] Get" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Certificate_Get"
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Get" | Should -HaveCount 1
        }

        it "Validate [POS] Get Null" {
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Get_Null" | Should -HaveCount 0
        }

        it "Validate [POS] Get Exact" {

            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Certificate_Get_Exact0"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Certificate_Get_Exact1"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Certificate_Get_Exact"
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Get_Exact" -Exact | ForEach-Object Name | Should -Be "Certificate_Get_Exact"
        }

        it "Validate [POS] Get Wildcard" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Certificate_Get_WildCard1"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Certificate_Get_WildCard2"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Certificate_Get_WildCard3"
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Get_WildCard*" | Should -HaveCount 3
        }
        it "Validate [POS] Get Pipeline String" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Certificate_Get_Pipeline"
            "Certificate_Get_Pipeline" | Get-PSAdminKeyVaultCertificate -VaultName $VaultName | Should -HaveCount 1
        }
        it "Validate [POS] Get Pipeline Object" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Certificate_Get_Pipeline_Object" 
            [PSCustomObject]@{
                VaultName = $VaultName
                Name      = "Certificate_Get_Pipeline_Object"
            } | Get-PSAdminKeyVaultCertificate | Should -HaveCount 1
        }
        it "Validate [POS] Get Positional" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Certificate_Get_Positional"
            Get-PSAdminKeyVaultCertificate $VaultName "Certificate_Get_Positional" | Should -HaveCount 1
        }
    }

    Context "Remove-PSAdminKeyVaultCertificate" {
        it "Validate [POS] Remove" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Certificate_Remove"
            Remove-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Remove" -Confirm:$False
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Remove" | Should -BeNullOrEmpty
        }
        
        it "Validate [NEG] Remove Null" {
            { Remove-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Remove_Null" -ErrorAction Stop } | Should -Throw 
        }
        
        it "Validate [POS] Remove WildCard" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Certificate_Remove_WildCard1"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Certificate_Remove_WildCard2"
            Remove-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Remove_Wild*" -Confirm:$False -Match
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Remove_Wild*" | Should -BeNullOrEmpty
        }
        it "Validate [POS] Remove Pipeline" {
            
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Certificate_Remove_Pipeline1"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Certificate_Remove_Pipeline2"
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Certificate_Remove_Pipeline3"
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Remove_Pipeline*" | Remove-PSAdminKeyVaultCertificate -Confirm:$False
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Remove_Pipeline*" | Should -BeNullOrEmpty
            
        }
        it "Validate [POS] Remove Positional" {
            Import-PSAdminKeyVaultCertificate -VaultName $VaultName -Password $CertPassSecStr -FileName $CertPath -Name "Certificate_Remove_Positional"
            Remove-PSAdminKeyVaultCertificate $VaultName "Certificate_Remove_Positional" -Confirm:$False
            Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "Certificate_Remove_Positional" | Should -BeNullOrEmpty
        }
    }

    it "Cleanup" {
        Remove-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "*" -Confirm:$False -Match
        Remove-PSAdminKeyVault -VaultName $VaultName -Confirm:$false
        Get-PSAdminKeyVault -VaultName $VaultName | Should -HaveCount 0

        Remove-Item $CertPath -Force
        Remove-Item $CertPath_ExportFileName
        Remove-Item $CertPath_ExportString
    }
}