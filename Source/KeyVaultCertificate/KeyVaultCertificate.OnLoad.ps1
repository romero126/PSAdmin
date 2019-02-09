$Database = Connect-PSAdminSQlite @Script:PSAdminDBConfig

$KeyVaultCertificate = [PSCustomObject]@{
    Certificate             = [Char[]]""
    KeyId                   = [String]""
    SecretId                = [String]""
    Thumbprint              = [String]""
    RecoveryLevel           = [String]""
    ScheduledPurgeDate      = [String]""
    DeletedDate             = [String]""
    Enabled                 = [String]""
    Expires                 = [String]""
    NotBefore               = [String]""
    Created                 = [String]""
    Updated                 = [String]""
    Tags                    = [String]""
    VaultName               = [String]""
    Name                    = [String]""
    Version                 = [String]""
    Id                      = [String]""
}

$Null = New-PSAdminSQLiteTable -Database $Database -Table "PSAdminKeyVaultCertificate" -PSCustomObject $KeyVaultCertificate

Disconnect-PSAdminSQLite -Database $Database