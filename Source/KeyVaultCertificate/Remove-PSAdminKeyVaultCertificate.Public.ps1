function Remove-PSAdminKeyVaultCertificate
{
    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Id = "*",

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 0)]
        [System.String]$VaultName,

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
        $Certificates = Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Exact:(!$Match)

        if (!$Certificates)
        {
            Cleanup
            throw ($Script:PSAdminLocale.GetElementById("KeyVaultExceptionCertificateNotFound").Value -f $VaultName, $Name)
        }

        foreach ($Certificate in $Certificates)
        {
            if (!$PSCmdlet.ShouldProcess( ($Script:PSAdminLocale.GetElementById("KeyVaultCertificateRemove").Value -f $Certificate.Name, $Certificate.VaultName) ))
            {
                return
            }
            #Todo Validate Many and Should Process
            $DBQuery = @{
                Database        = $Database
                Keys            = $Script:KeyVaultCertificateConfig.TableKeys
                Table           = $Script:KeyVaultCertificateConfig.TableName
                InputObject     = $Certificate
            }

            $Result = Remove-PSAdminSQliteObject @DBQuery
            if ($Result -eq -1)
            {
                Cleanup
                throw New-PSAdminException -ErrorID ExceptionUpdateDatabase
            }
        }
    }

    end
    {
        Cleanup
    }
}