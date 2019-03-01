
## What is PSAdminKeyVaultCertificate

KeyVaultCertificate storage is a Central location to Store Certificates for exporting later.

## Import a Certificate into the store
```
    #Note all Certificates must be encrypted using a password and an Exportable Key
    $MyPassword = Read-Host -Prompt "Enter your Certificate Password" -AsSecureString
    Import-PSAdminCertifiate -VaultName "YourVaultName" -Name "NameOfCertificate" -Path "PathToCertificate" -Password $MyPassword
```

## How do I Generate a Certificate?

Create a Self Signed Certificate

```
New-SelfSignedCertificate -Subject "Certificate" -FriendlyName "MyCertificate" -KeyAlgorithim RSA -KeyLength 2048 -KeyExportPolicy Exportable -KeyUsage DataEncipherment
```

Or Do it Automagically
Open Powershell as an Administrator
```

$SelfSignedCertificate = @{
    Subject         = Read-Host -Prompt "Subject for Certificate"
    FriendlyName    = Read-Host -Prompt "Friendly Name"

    KeyAlgorithim   = "RSA"
    KeyLength       = 2048
    KeyExportPolicy = "Exportable"
    KeySpec         = "Signature"
    KeyUsage        = "DataEncipherment"
    KeyProtection   = "None"

}

$ExportCertificate = @{
    FileName    = Read-Host -Prompt "Certificate Name: (.pfx)"
    Password    = Read-Host -Prompt "Enter your Certificate Password" -AsSecureString
}

$Certificate = New-SelfSignedCertificate @SelfSignedCertificate
$Certificate.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, $ExportCertificate.Password) | Set-Content -Path $ExportCertificate.FileName -Encoding Byte

Get-ChildItem $ExportCertificate.FileName
```


* [Get-PSAdminKeyVaultCertificate][GetCommand] Gets a PSAdmin KeyVault Secret.
* [Remove-PSAdminKeyVaultCertificate][NewCommand] Creates a PSAdmin KeyVault Secret.
* [Import-PSAdminKeyVaultCertificate][SetCommand] Sets a Value in PSAdmin KeyVault Secret.
* [Export-PSAdminKeyVaultCertificate][RemoveCommand] Remove a PSAdmin KeyVault Secret.

[GetCommand]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/Get-PSAdminKeyVaultSecret.md
[NewCommand]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/New-PSAdminKeyVaultSecret.md
[SetCommand]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/Set-PSAdminKeyVaultSecret.md
[RemoveCommand]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/Remove-PSAdminKeyVaultSecret.md