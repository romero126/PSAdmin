$Database = Connect-PSAdminSQlite @Script:PSAdminDBConfig
$Null = New-PSAdminSQLiteTable -Database $Database -Table $Script:MachineConfig.TableName -PSCustomObject $Script:MachineConfig.TableSchema
Disconnect-PSAdminSQLite -Database $Database