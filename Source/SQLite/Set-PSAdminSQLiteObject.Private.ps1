function Set-PSAdminSQLiteObject
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
        [PSCustomObject]$InputObject,
        [Parameter()]
        [Switch]$Match
    )

    begin
    {

        $Database.Open()

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
                elseif ($Item.TypeNameOfValue -eq 'System.String[]')
                { 
                    foreach ($i in $Item.Value)
                    {
                        if ($i -eq "*")
                        { 
                            continue;
                        }
                        "``{0}`` LIKE '%{1}%'" -f $Item.Name, $i
                    }
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
                    $ItemValue = $Item.Value.Replace('\','\\').Replace('_', '\_').Replace("*", "%")
                    $SearchComparator = "LIKE"
                    ("`n ``{0}`` {1} '{2}' ESCAPE '\'" -f $Item.Name, $SearchComparator, $ItemValue)
                }

            }
        }

        $Filter = $Filter -join " AND "

        if ([System.String]::IsNullOrEmpty($Filter))
        {
            Write-Error "PSCustomObject InputObject must contain a $Key Property"
        }

        $cmd = [System.Data.SQLite.SQLiteCommand]::new($Database)

        $tableSchema = new-object System.Collections.Arraylist
        
        foreach ($i in $InputObject.PSObject.Properties) {
            if ($Keys -eq $i.Name) {
                Continue;
            }
            $tableSchema.Add(("{0} = @{0}" -f $i.Name)) | out-null
            $cmd.Parameters.AddWithValue($i.Name, $i.Value) | out-null
        }

        $Query = "UPDATE {0} SET {1} WHERE {2}" -f $table, ($tableSchema -join ","), $Filter

        $cmd.CommandText = $Query
        $result = -1
        
        try {
            $result = $cmd.ExecuteNonQuery();
        }
        catch {
            $result = -1
        }

        return $result

    }
    end
    {

        $Database.Close()

    }
}