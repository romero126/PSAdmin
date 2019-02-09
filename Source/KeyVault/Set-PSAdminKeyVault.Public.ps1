function Set-PSAdminKeyVault
{
    [CmdletBinding()]
    param(
        #[Parameter(ValueFromPipelineByPropertyName)]
        #[System.String]$Id = "*",

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.String]$VaultName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Location,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$VaultURI,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$SKU,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("True", "False")]
        [System.String]$SoftDeleteEnabled,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String[]]$Tags

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
                VaultName               = $VaultName
                Id                      = $Id
            }
        }

        $Result = Set-PSAdminSQliteObject @DBQuery
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