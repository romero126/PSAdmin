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
                if (!$Match)
                {
                    $ItemValue = $Item.Value
                    $SearchComparator = "="
                }
                else
                {
                    $ItemValue = $Item.Value.Replace('_', '\_').Replace("*", "%")
                    $SearchComparator = "LIKE"
                }
                if ((!$Match) -and ($Item.Value -eq "*")) {
                    continue;
                }
                ("`n ``{0}`` {1} '{2}'" -f $Item.Name, $SearchComparator, $ItemValue)
            }
        }

        $Query = "SELECT`n *`nFROM`n ``{0}```nWHERE {1}" -f $Table, ($Filter -join " AND ")

        if ($Match) {
            $Query = $Query + "`nESCAPE`n '\'"
        }
#        Write-Host "Query:"
#        Write-Host $Query -ForegroundColor Yellow
        $Result = Request-PSAdminSQLiteQuery -Database $Database -Query $Query
        $Result
        
    }

    end
    {

    }
}
