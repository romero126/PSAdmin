function Get-PSAdminKeyVaultCertificate {
    <#
        .SYNOPSIS
            Searches KeyVaultCertificate store for a specific Id/Name/Thumbprint and returns its results.

        .DESCRIPTION
            Searches KeyVaultCertificate store for a specific Id/Name/Thumbprint and returns its results.
        
        .PARAMETER Id
            Unique Identifier for Certificate
        
        .Parameter VaultName
            Unique Name for the KeyVault

        .Parameter Name
            Unique Name for the Certificate
        
        .Parameter Thumbprint
            Unique Unique for the KeyVault

        .Parameter Exact
            Specify for Exact Search based on ID/Name

        .EXAMPLE
            Get-PSAdminKeyVaultCertificate -VaultName "<VaultName>" -Name "<Certificate>"

        .INPUTS
            PSAdminKeyVaultCertificate, or any specific object that contains Id, Name, VaultName

        .OUTPUTS
            PSAdminKeyVaultCertificate.

        .NOTES

        .LINK

    #>
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

        [Parameter(ValueFromPipelineByPropertyName)]
        [String[]]$Tags,

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
            Keys            = $Script:KeyVaultCertificateConfig.TableKeys + $Tags
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