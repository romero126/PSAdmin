$Database = Connect-PSAdminSQlite @Script:PSAdminDBConfig

$KeyVaultSchema = [PSCustomObject]@{
    Id                              = [String]""
    VaultName                       = [String]""
    Location                        = [String]""
    VaultURI                        = [String]""
    SKU                             = [String]""
    SoftDeleteEnabled               = [String]""
    Tags                            = [String]""
    Thumbprint                      = [String]""
    VaultKey                        = [char[]]""
    ResourceGroup                   = [String]""
    ResourceID                      = [String]""

}

$null = New-PSAdminSQLiteTable -Database $Database -Table "PSAdminKeyVault" -PSCustomObject $KeyVaultSchema

Disconnect-PSAdminSQLite -Database $Database