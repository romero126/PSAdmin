$Database = Connect-PSAdminSQlite @Script:PSAdminDBConfig
$Null = New-PSAdminSQLiteTable -Database $Database -Table $Script:KeyVaultCertificateConfig.TableName -PSCustomObject $Script:KeyVaultCertificateConfig.TableSchema
Disconnect-PSAdminSQLite -Database $Database