function New-PSAdminSQLiteTable
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Data.SQLite.SQLiteConnection]$Database,
        [Parameter(Mandatory)]
        [System.String]$Table,
        [Parameter(Mandatory)]
        [PSCustomObject]$PSCustomObject
    )
    begin
    {

    }
    process
    {
        $Properties = New-Object System.Collections.ArrayList

        foreach ($i in $PSCustomObject.PSObject.Properties)
        {
    
            $NameType = $null
            
            Switch ($i.TypeNameOfValue) {
                "System.String" { $NameType = "String" }
                "System.Int32" { $NameType = "INTEGER" }
                "System.Char[]" { $NameType = "BLOB" }
                "System.Byte[]" { $NameType = "BLOB" }
                Default { write-host $i.Name, $i.TypeNameOfValue }
            }

            $Properties.Add( ("``{0}`` {1}" -f $i.Name, $NameType)) | out-null
    
        }
        
        Invoke-PSAdminSQLiteQuery -Database $Database -Query ("CREATE TABLE IF NOT EXISTS ``{0}`` ({1})" -f $Table, ($Properties -join ", "))
    
    }

    end
    {

    }
}