function Get-PSAdminKeyVaultSecret
{
    <#
        .SYNOPSIS
            Searches KeyVaultSecret Store for an Item with the Specified VaultName/Name and returns the results.

        .DESCRIPTION
            Searches KeyVaultSecret Store for an Item with the Specified VaultName/Name and returns the results.
        
        .Parameter VaultName
            Unique Name for KeyVault

        .Parameter Name
            Unique Name for Secret

        .Parameter Id
            Unique identifier for Secret

        .Parameter Decrypt
            Automatically Decrypt Value
            
        .Parameter Exact
            Specify for Exact Search based on ID/Name

        .EXAMPLE
            Get-PSAdminKeyVaultSecret -VaultName "<VaultName>" -Name "<SecretName>"

        .EXAMPLE
            Get-PSAdminKeyVaultSecret -VaultName "<VaultName>" -Name "<SecretName>" -Decrypt

        .INPUTS
            PSAdminKeyVaultSecret.PSAdmin.Module, or any specific object that contains Id, Name

        .OUTPUTS
            PSAdminKeyVaultSecret.PSAdmin.Module.

        .NOTES

        .LINK

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String]$VaultName,

        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.String]$Name = "*",

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Id = "*",

        [Parameter()]
        [Switch]$Decrypt,

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
            Keys            = ("VaultName", "Name", "Id")
            Table           = "PSAdminKeyVaultSecret"
            InputObject     = [PSCustomObject]@{
                VaultName       = $VaultName
                Name            = $Name
                Id              = $Id
            }
        }

        $Results = Get-PSAdminSQliteObject @DBQuery -Match:(!$Exact)
        
        foreach ($Result in $Results) {
            $Result.SecretValue = ConvertFrom-PSAdminKeyVaultSecretValue -VaultName $Result.VaultName -InputData $Result.SecretValue -Decrypt:$Decrypt
            $Result.PSObject.TypeNames.Insert(0, "PSAdminKeyVaultSecret.PSAdmin.Module")
            $Result
        }

    }
    
    end
    {
        Cleanup
    }

}