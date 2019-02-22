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
        [Switch]$Exact, 

        [Parameter()]
        [Switch]$Export
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
            if ($Export)
            {
                $Result.Certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new([byte[]]$Result.Certificate, $Result.Thumbprint, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
            }
            else
            {
                $Result.Certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new([byte[]]$Result.Certificate, $Result.Thumbprint)
            }

            [PSAdminKeyVaultCertificate]$Result
        }
    }

    end
    {
        Cleanup
    }

}