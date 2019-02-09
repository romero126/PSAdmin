function Get-PSAdminKeyVault {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Id = "*",

        [Parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [System.String]$VaultName = "*"

    )

    begin
    {
        function Cleanup {
            Disconnect-PSAdminSQLite -Database $Database
        }
        $Database = Connect-PSAdminSQLite @Script:PSAdminDBConfig        
    }

    process
    {
        $DBQuery = @{
            Database        = $Database
            Keys            = ("VaultName", "Id")
            Table           = "PSAdminKeyVault"
            InputObject = [PSCustomObject]@{
                Id                      = $Id
                VaultName               = $VaultName
            }
        }
        $Results = Get-PSAdminSQliteObject @DBQuery
        
        foreach ($Result in $Results) {
            $Result.PSObject.TypeNames.Insert(0, "PSAdminKeyVault.PSAdmin.Module")            
            $Result
        }
    }

    end
    {
        Cleanup
    }

}