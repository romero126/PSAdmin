function Remove-PSAdminKeyVault
{
    <#
        .SYNOPSIS
            Removes KeyVault from Database

        .DESCRIPTION
            Removes KeyVault from Database
        
        .PARAMETER Id
            Unique Identifier for KeyVault
        
        .Parameter VaultName
            Unique Name for KeyVault

        .Parameter Match
            Specify for Match Search based on ID/Name

        .EXAMPLE
            Example: Exact
            ``` powershell
            Remove-PSAdminKeyVault -VaultName "<VaultName>"
            ```
        .EXAMPLE
            Remove Matching
            ``` powershell
            Remove-PSAdminKeyVault -VaultName "Vault*" -Match
            ```
        .INPUTS
            PSAdminKeyVault.PSAdmin.Module, or any specific object that contains Id, VaultName

        .OUTPUTS
            None. If Successful

        .NOTES

        .LINK

    #>
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
        $KeyVaults = Get-PSAdminKeyVault -VaultName $VaultName -Exact:(!$Match)
        
        if (!$KeyVaults)
        {
            Cleanup
            throw ($Script:PSAdminLocale.GetElementById("KeyVaultNotFound").Value -f $VaultName)

        }

        foreach ($KeyVault in $KeyVaults)
        {
            if (!$PSCmdlet.ShouldProcess( ($Script:PSAdminLocale.GetElementById("KeyVaultRemoveAll").Value -f $KeyVault.VaultName) ))
            {
                return
            }
            $DBQuery = @{
                Database        = $Database
                Keys            = ("VaultName", "Id")
                Table           = "PSAdminKeyVault"
                InputObject     = [PSCustomObject]@{
                    Id              = $KeyVault.Id
                    VaultName       = $KeyVault.VaultName
                }
            }

            try
            {
                Write-Debug -Message ($Script:PSAdminLocale.GetElementById("KeyVaultRemoveCertificates").Value -f $VaultName)
                Remove-PSAdminKeyVaultCertificate -VaultName $VaultName -Name "*" -Match
    
                Write-Debug -Message ($Script:PSAdminLocale.GetElementById("KeyVaultRemoveSecrets").Value -f $VaultName)
                Remove-PSAdminKeyVaultSecret -VaultName $VaultName -Name "*" -Match
            }
            catch
            {
    
            }

            $Result = Remove-PSAdminSQliteObject @DBQuery -Match:($Match)
        
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