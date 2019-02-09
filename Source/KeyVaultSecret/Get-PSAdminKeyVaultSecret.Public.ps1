function Get-PSAdminKeyVaultSecret
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String]$VaultName,

        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.String]$Name = "*",

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Id = "*",

        [Parameter()]
        [Switch]$Decrypt
    )

    begin
    {
        $PSTypeName = "PSAdminKeyVaultSecret.PSAdmin.Module"
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

        $Results = Get-PSAdminSQliteObject @DBQuery

        foreach ($Result in $Results) {
            $Result.SecretValue = ConvertFrom-PSAdminKeyVaultSecretValue -VaultName $VaultName -InputData $Result.SecretValue -Decrypt:$Decrypt
            $Result.PSObject.TypeNames.Insert(0, "PSAdminKeyVaultSecret.PSAdmin.Module")
            $Result
        }

    }
    
    end
    {
        Cleanup
    }

}