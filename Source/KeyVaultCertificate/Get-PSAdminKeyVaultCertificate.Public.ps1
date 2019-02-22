function Get-PSAdminKeyVaultCertificate {
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
        [Switch]$Exact
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
            Keys            = $Script:KeyVaultCertificateConfig.TableKeys
            Table           = $Script:KeyVaultCertificateConfig.TableName
            InputObject = [PSCustomObject]@{
                Thumbprint              = $Thumbprint
                VaultName               = $VaultName
                Name                    = $Name
                Id                      = $Id
            }
        }
        $Results = Get-PSAdminSQliteObject @DBQuery -Match:(!$Exact)
        foreach ($Result in $Results) {
            $Result.PSObject.TypeNames.Insert(0, "PSAdminKeyVaultCertificate.PSAdmin.Module")
            $Result
        }
        
    }

    end
    {
        Cleanup
    }

}