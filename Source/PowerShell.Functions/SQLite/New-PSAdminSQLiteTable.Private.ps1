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
                
            $NameType = Switch -Wildcard ($i.TypeNameOfValue) {
                'System.Net.IPAddress'                          { 'String' }
                'System.DateTime'                               { 'String' }
                'System.Management.Automation.PSObject'         { 'BLOB' }
                'System.Nullable``1`[`[System.DateTime*`]`]'    { 'String' }
                'System.String'                                 { 'String' }
                'System.String`[`]'                             { 'String'}
                'System.Int32'                                  { 'INTEGER' }
                'System.Char`[`]'                               { 'BLOB' }
                'System.Byte`[`]'                               { 'BLOB' }
                Default {
                    'BLOB';
                    write-host ("Information: Using ``BLOB`` for ``{0}`` an Unknown Type discovered ``{1}``" -f $i.Name, $i.TypeNameOfValue) -ForegroundColor Yellow
                }
            }

            $Properties.Add( ("``{0}`` {1}" -f $i.Name, $NameType)) | out-null
            
        }

        Invoke-PSAdminSQLiteQuery -Database $Database -Query ("CREATE TABLE IF NOT EXISTS ``{0}`` ({1})" -f $Table, ($Properties -join ", "))
    
    }

    end
    {

    }
}