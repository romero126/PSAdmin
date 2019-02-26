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
                if ($Item.TypeNameOfValue -eq 'System.String[]')
                { 
                    foreach ($i in $Item.Value)
                    {
                        "``{0}`` LIKE '%{1}%'" -f $Item.Name, $i
                    }
                    continue;
                }

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
                    $ItemValue = $Item.Value.Replace('\','\\').Replace('_', '\_').Replace("*", "%")
                    $SearchComparator = "LIKE"
                    ("`n ``{0}`` {1} '{2}' ESCAPE '\'" -f $Item.Name, $SearchComparator, $ItemValue)
                }

            }
        }

        $Query = "SELECT`n *`nFROM`n ``{0}```nWHERE {1}" -f $Table, ($Filter -join " AND ")


        #if ($Match) {
        #    $Query = $Query + "`nESCAPE`n '\'"
        #}
        #Write-host "Query:", $Query.Replace("`n", ' ')
        $Result = Request-PSAdminSQLiteQuery -Database $Database -Query $Query
        $Result
        
    }

    end
    {

    }
}
