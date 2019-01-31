function Get-PSAdminSQLiteObject
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Data.SQLite.SQLiteConnection]$Database,
        [Parameter(Mandatory)]
        [System.String]$Table,
        [Parameter(Mandatory)]
        [System.String[]]$Keys,
        [Parameter(Mandatory)]
        [PSCustomObject]$InputObject
    )
    begin
    {

    }
    process
    {

        $Filter = foreach ($Item in $InputObject.PSObject.Properties)
        {
            
            if ($Keys -eq $Item.Name) {
                "``{0}`` LIKE '{1}'" -f $Item.Name, $Item.Value.Replace("_", "\_").Replace("*", "%")
            }
        }
        
        $Query = "SELECT * From ``{0}`` WHERE {1} ESCAPE '\'" -f $Table, ($Filter -join " AND ")
        $Result = Request-PSAdminSQLiteQuery -Database $Database -Query $Query
        $Result
        
    }
    end
    {

    }
}
