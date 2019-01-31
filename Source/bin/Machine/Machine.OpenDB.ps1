$Script:PSAdminMachineSchema = [XML](Get-Content "$PSScriptRoot\DBSchema.xml")


function Local:GenerateTableSchema
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
		[System.Data.SQLite.SQLiteConnection]$Database,
        [Parameter(Mandatory)]
        [System.Xml.XmlDocument]$MachineSchema
    )
    
    begin
    {

    }

    process
    {
        #Create Table Object
        $TableName = $MachineSchema.DB.Table.Name
        $TableObj = [PSCustomObject]@{}
        $MachineSchema.DB.Table.ITEM | ForEach-Object { Add-Member -InputObject $TableObj -MemberType NoteProperty -Name $_ -Value "" }
        New-PSAdminSQLiteTable -Database $Database -Table $TableName -PSCustomObject $TableObj
    }

    end
    {

    }
}

function Local:UpdateTableSchema
{
    [CmdletBinding()]
    param(
		[Parameter(Mandatory)]
		[System.Data.SQLite.SQLiteConnection]$Database,
        [Parameter(Mandatory)]
        [System.Xml.XmlDocument]$MachineSchema
    )
    begin
    {

    }
    process
    {
#        Write-Host "Placeholder for Powershell"
    }
    end
    {

    }
}

$Database = Connect-PSAdminSQlite @Script:PSAdminDBConfig

Local:GenerateTableSchema -Database $Database -MachineSchema $Script:PSAdminMachineSchema
Local:UpdateTableSchema -Database $Database -MachineSchema $Script:PSAdminMachineSchema




Disconnect-PSAdminSQLite -Database $Database