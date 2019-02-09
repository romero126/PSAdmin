function Remove-PSAdminSQLiteObject
{
    [CmdletBinding()]
    Param(
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
                "``{0}`` LIKE '{1}'" -f $Item.Name, $Item.Value.Replace('*', '%')
            }
        }

        $Filter = $Filter -join " AND "
        
        if ([System.String]::IsNullOrEmpty($Filter))
        {
            Write-Error "PSCustomObject InputObject must contain a $Key Property"
        }

        $Query = "DELETE FROM {0} WHERE {1}" -f $Table, $Filter
        Invoke-PSAdminSQLiteQuery -Database $Database -Query $Query
        
    }

    end
    {

    }
}

