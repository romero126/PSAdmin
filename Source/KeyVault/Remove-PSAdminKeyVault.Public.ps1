function Remove-PSAdminKeyVault
{
    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Id = "*",

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.String]$VaultName,

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
        $KeyVault = Get-PSAdminKeyVault -VaultName $VaultName -Exact:(!$Match)
        
        if (!$KeyVault)
        {
            Cleanup
            throw ($Script:PSAdminLocale.GetElementById("KeyVaultNotFound").Value -f $VaultName)
            
        }

        if (!$PSCmdlet.ShouldProcess( ($Script:PSAdminLocale.GetElementById("KeyVaultRemoveAll").Value -f $VaultName) ))
        {
            return
        }
        
        $DBQuery = @{
            Database        = $Database
            Keys            = ("VaultName", "Id")
            Table           = "PSAdminKeyVault"
            InputObject     = [PSCustomObject]@{
                Id              = $Id
                VaultName       = $VaultName
            }
        }

        Write-Debug -Message ($Script:PSAdminLocale.GetElementById("KeyVaultRemoveCertificates").Value -f $VaultName)
        Remove-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "*" -Match

        Write-Debug -Message ($Script:PSAdminLocale.GetElementById("KeyVaultRemoveSecrets").Value -f $VaultName)
        Remove-PSAdminKeyVaultSecret -VaultName $VaultName -Name "*" -Match
        
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