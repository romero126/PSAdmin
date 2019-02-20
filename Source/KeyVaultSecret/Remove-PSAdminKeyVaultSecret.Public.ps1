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
        
        $KeyVaultSecret = Get-PSAdminKeyVaultSecret -VaultName $VaultName -Name $Name -Exact:(!$Match)

        if (!$KeyVaultSecret)
        {
            Cleanup
            throw ($Script:PSAdminLocale.GetElementById("KeyVaultSecretNotFound").Value -f $Name, $VaultName)
        }

        if (!$PSCmdlet.ShouldProcess( ($Script:PSAdminLocale.GetElementById("KeyVaultSecretRemoveAll").Value -f $Name, $VaultName) ))
        {
            return
        }

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