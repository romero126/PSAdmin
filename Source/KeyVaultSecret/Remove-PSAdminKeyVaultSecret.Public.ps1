function Remove-PSAdminKeyVaultSecret
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String]$VaultName,
        
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.String]$Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Id = "*"
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
            Keys            = ("VaultName", "Name", "Id")
            Table           = "PSAdminKeyVaultSecret"
            InputObject     = [PSCustomObject]@{
                VaultName       = $VaultName
                Name            = $Name
                Id              = $Id
            }
        }

        $Result = Remove-PSAdminSQliteObject @DBQuery

        if ($Result -eq -1)
        {

            Cleanup
            throw New-PSAdminException -ErrorID ExceptionUpdateDatabase
        }

    }
    
    end
    {
        Cleanup
    }

}