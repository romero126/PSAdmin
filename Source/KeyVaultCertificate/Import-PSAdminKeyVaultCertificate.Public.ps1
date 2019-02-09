function Import-PSAdminKeyVaultCertificate
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ParameterSetName = "ImportFromString")]
        [Parameter(Mandatory, ParameterSetName = "ImportFromFile")]
        [System.String]$VaultName,

        [Parameter(ParameterSetName = "ImportFromString")]
        [Parameter(ParameterSetName = "ImportFromFile")]
        [System.String]$Name,

        [Parameter(Mandatory, ParameterSetName = "ImportFromFile")]
        [System.String]$FilePath,
        
        [Parameter(Mandatory, ParameterSetName = "ImportFromString")]
        [System.String]$CertificateString,

        [Parameter(Mandatory, ParameterSetName = "ImportFromString")]
        [Parameter(Mandatory, ParameterSetName = "ImportFromFile")]
        [SecureString]$Password,
        
        [Parameter(ParameterSetName = "ImportFromString")]
        [Parameter(ParameterSetName = "ImportFromFile")]
        [System.String[]]$Tag = ""
    )

    begin
    {
        function Cleanup {
            Disconnect-PSAdminSQLite -Database $Database
        }
        $Database = Connect-PSAdminSQLite @Script:PSAdminDBConfig        
    }

    process
    {

        $Result = Get-PSAdminKeyVaultCertificate -Name $Name -VaultName $VaultName
        if ($Result)
        {
            Cleanup
            throw New-PSAdminException -ErrorID KeyVaultCertificateExceptionExists -ArgumentList $VaultName, $Name
        }

        switch ($PSCmdlet.ParameterSetName)
        {
            "ImportFromFile" {
                $CertificateByteArray = Get-Content -Path $FilePath -Encoding Byte
            }
            "ImportFromString" {
                $CertificateByteArray = [System.Convert]::FromBase64String($CertificateString)
            }
        }

        $x509 = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new([byte[]]$CertificateByteArray, $Password, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)

        if ((!$x509.HasPrivateKey) -or (!$x509.PrivateKey)) {
            $x509.Dispose()
            Cleanup
            throw New-PSAdminException -ErrorID KeyVaultCertificateExceptionPrivateKey
        }

        if ([String]::IsNullOrWhiteSpace($Name))
        {
            $Name = $x509.FriendlyName
        }

        $x509Password = $x509.Thumbprint | ConvertTo-SecureString -AsPlainText -Force
        $RawCert = $x509.Export( [System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, $x509Password )

        $DBQuery = @{
            Database        = $Database
            Keys            = ("VaultName", "Name")
            Table           = "PSAdminKeyVaultCertificate"
            InputObject = [PSCustomObject]@{
                Certificate             = $RawCert
                KeyId                   = $x509.SerialNumber
                SecretId                = $x509.SerialNumber
                Thumbprint              = $x509.Thumbprint
                RecoveryLevel           = "Default"
                ScheduledPurgeDate      = ""
                DeletedDate             = ""
                Enabled                 = "True"
                Expires                 = $x509.NotAfter
                NotBefore               = $x509.NotBefore
                Created                 = [DateTime]::UtcNow
                Updated                 = [DateTime]::UtcNow
                Tags                    = $Tag -join ";"
                VaultName               = $VaultName
                Name                    = $Name
                Version                 = 0
                Id                      = [guid]::NewGuid().ToString().Replace('-', '')
            }
        }

        $x509.Dispose()

        $Result = New-PSAdminSQliteObject @DBQuery
        if ($Result -eq -1)
        {
            Cleanup
            throw New-PSAdminException -ErrorID ExceptionUpdateDatabase
        }
    }

    end
    {
        Cleanup
    }

}

#$FileString = Get-Content $PSScriptRoot\cert.pfx -Encoding Byte
#$FileString = [System.Convert]::ToBase64String($FileString)

#Write-Host "MyHash", $FileString
#$Password = ConvertTo-SecureString -String "123456" -AsPlainText -force
#Import-PSAdminKeyVaultCertificate -VaultName "Default" -CertificateString $FileString -Password $Password


#$FileName = Get-ChildItem $PSScriptRoot\cert.pfx
#$Password = ConvertTo-SecureString -String "123456" -AsPlainText -force
#Import-PSAdminKeyVaultCertificate -VaultName "Default" -FilePath $FileName.FullName.ToString() -Password $Password


<#
$FileName = Get-Item .\Source\KeyVaultCertificate\cert.pfx
$Password = ConvertTo-SecureString -String "123456" -AsPlainText -force
Import-PSAdminKeyVaultCertificate -VaultName "Default" -FilePath $FileName.FullName.ToString() -Password $Password
#>
#Encrypt 
<#

$DBObject = New-Object PSObject | Select UserName,ENCRYPTEDHASH,ENCRYPTED,x509ThumbPrint,x509Serial,x509Expire,x509DNSName
    $DBObject.USERNAME = $Credential.USERNAME
    # Generate New Encryption key for Database
    $key = new-object byte[](32)
    $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($key)
    $DBObject.ENCRYPTEDHASH = Get-CentralAdminSecureVaultEncryptedValue -Value $Credential.USERNAME -Key $Credential.Password
    $DBObject.ENCRYPTED = Get-CentralAdminSecureVaultEncryptedValue -Value ([System.Text.Encoding]::ASCII.GetString($KEY)) -Key $Credential.Password
    $KEY = $null # Cleanup Memory

#>