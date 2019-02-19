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
        [Parameter()]
        [Switch]$Match,
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
            if ($Keys -eq $Item.Name)
            {
                if ((!$Match) -and ($Item.Value -eq "*")) {
                    continue;
                }
                elseif (!$Match)
                {
                    $ItemValue = $Item.Value
                    $SearchComparator = "="
                    ("`n ``{0}`` {1} '{2}'" -f $Item.Name, $SearchComparator, $ItemValue)
                }
                else
                {
                    $ItemValue = $Item.Value.Replace('_', '\_').Replace("*", "%")
                    $SearchComparator = "LIKE"
                    ("`n ``{0}`` {1} '{2}' ESCAPE '\'" -f $Item.Name, $SearchComparator, $ItemValue)
                }

            }
        }

        if ([System.String]::IsNullOrEmpty($Filter))
        {
            Write-Error "PSCustomObject InputObject must contain a ($($Keys -join ', ')) Property"
        }

        $Query = "DELETE FROM`n ``{0}```nWHERE {1}" -f $Table, ($Filter -join " AND ")

        Invoke-PSAdminSQLiteQuery -Database $Database -Query $Query
        
    }

    end
    {

    }
}

