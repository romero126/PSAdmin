$Database = Connect-PSAdminSQlite @Script:PSAdminDBConfig

$KeyVaultSecretSchema = [PSCustomObject]@{
    VaultName   = [String]""
    Name        = [String]""
    Version     = [String]""
    Id          = [String]""
    Enabled     = [String]""
    Expires     = [String]""
    NotBefore   = [String]""
    Created     = [String]""
    Updated     = [String]""
    ContentType = [String]""
    Tags        = [String]""
    SecretValue = [String]""
}

$Null = New-PSAdminSQLiteTable -Database $Database -Table "PSAdminKeyVaultSecret" -PSCustomObject $KeyVaultSecretSchema

Disconnect-PSAdminSQLite -Database $Database