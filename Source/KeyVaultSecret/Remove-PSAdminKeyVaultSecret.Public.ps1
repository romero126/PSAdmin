function Remove-PSAdminKeyVaultSecret
{
    <#
        .SYNOPSIS
            Removes Secret from from the KeyVaultSecret Store.

        .DESCRIPTION
            Removes Secret from from the KeyVaultSecret Store.
        
        .Parameter VaultName
            Unique Name for KeyVault

        .Parameter Name
            Unique Name for Secret

        .Parameter Id
            Unique identifier for Secret
            
        .Parameter Match
            Specify for Match Search based on ID/Name

        .EXAMPLE
            Remove-PSAdminKeyVaultSecret -VaultName "<VaultName>" -Name "<SecretName>"

        .EXAMPLE
            Remove-PSAdminKeyVaultSecret -VaultName "<VaultName>" -Name "<SecretName>*"

        .INPUTS
            PSAdminKeyVaultSecret.PSAdmin.Module, or any specific object that contains Id, Name

        .OUTPUTS
            None. If Successful

        .NOTES

        .LINK

    #>

    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String]$VaultName,
        
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.String]$Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Id = "*",

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
        $Secrets = Get-PSAdminKeyVaultSecret -VaultName $VaultName -Name $Name -Exact:(!$Match)
        
        if (-not $Secrets)
        {
            Cleanup
            throw ($Script:PSAdminLocale.GetElementById("KeyVaultSecretNotFound").Value -f $Name, $VaultName)
        }

        foreach ($Secret in $Secrets)
        {
            if (!$PSCmdlet.ShouldProcess( ($Script:PSAdminLocale.GetElementById("KeyVaultSecretRemove").Value -f $Secret.Name, $Secret.VaultName) ))
            {
                continue;
            }

            $DBQuery = @{
                Database        = $Database
                Keys            = ("VaultName", "Name", "Id")
                Table           = "PSAdminKeyVaultSecret"
                InputObject     = [PSCustomObject]@{
                    VaultName       = $Secret.VaultName
                    Name            = $Secret.Name
                    Id              = $Secret.Id
                }
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