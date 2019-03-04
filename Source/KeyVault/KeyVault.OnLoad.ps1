$Database = Connect-PSAdminSQlite @Script:PSAdminDBConfig
$Null = New-PSAdminSQLiteTable -Database $Database -Table $Script:KeyVaultConfig.TableName -PSCustomObject $Script:KeyVaultConfig.TableSchema
Disconnect-PSAdminSQLite -Database $Database