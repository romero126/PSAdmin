function Remove-PSAdminKeyVaultCertificate
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Id = "*",

        [Parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [System.String]$VaultName = "*",

        [Parameter(ValueFromPipelineByPropertyName, Position = 1)]
        [System.String]$Name = "*",

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Thumbprint = "*",

        [Parameter()]
        [Switch]$Match
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
            Keys            = ("VaultName", "Name", "Id", "Thumbprint")
            Table           = "PSAdminKeyVaultCertificate"
            InputObject = [PSCustomObject]@{
                Thumbprint              = $Thumbprint
                VaultName               = $VaultName
                Name                    = $Name
                Id                      = $Thumbprint
            }
        }

        $Result = Remove-PSAdminSQliteObject @DBQuery -Match:($Match)

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