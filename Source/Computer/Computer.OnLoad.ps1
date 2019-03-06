$Database = Connect-PSAdminSQlite @Script:PSAdminDBConfig
$Null = New-PSAdminSQLiteTable -Database $Database -Table $Script:ComputerConfig.TableName -PSCustomObject $Script:ComputerConfig.TableSchema
Disconnect-PSAdminSQLite -Database $Database