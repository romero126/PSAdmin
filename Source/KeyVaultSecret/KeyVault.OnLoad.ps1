$Database = Connect-PSAdminSQlite @Script:PSAdminDBConfig
$Null = New-PSAdminSQLiteTable -Database $Database -Table $Script:KeyVaultSecretConfig.TableName -PSCustomObject $Script:KeyVaultSecretConfig.TableSchema
Disconnect-PSAdminSQLite -Database $Database