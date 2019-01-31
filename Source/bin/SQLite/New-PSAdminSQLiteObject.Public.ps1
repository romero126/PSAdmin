function New-PSAdminSQLiteObject
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Data.SQLite.SQLiteConnection]$Database,
        [Parameter(Mandatory)]
        [System.String[]]$Keys,
        [Parameter(Mandatory)]
        [System.String]$Table,
        [Parameter(Mandatory)]
        [PSObject]$InputObject
    )
    begin
    {
        $Database.Open()
    }

    process
    {
        $cmd = [System.Data.SQLite.SQLiteCommand]::new($Database)
 
        $tableSchema = new-object System.Collections.Arraylist
        $tableValues = new-object System.Collections.Arraylist

        foreach ($i in $InputObject.PSObject.Properties) {
            $tableSchema.Add($i.Name) | out-null
            $tableValues.Add("@"+$i.Name) | out-null
            $cmd.Parameters.AddWithValue("@"+$i.Name, $i.Value) | out-null
        }

        $Query = "INSERT INTO {0} ({1}) VALUES ({2}) " -f $Table, ($tableSchema -join ","), ( $tableValues -join ",")
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