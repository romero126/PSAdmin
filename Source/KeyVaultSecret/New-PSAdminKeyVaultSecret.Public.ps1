function New-PSAdminKeyVaultSecret
{
    <#
        .SYNOPSIS
            Creates a new Secret to place in the Vault

        .DESCRIPTION
            Creates a new Secret to place in the Vault
        
        .Parameter VaultName
            Unique Name for KeyVault

        .Parameter Name
            Unique Name for Secret

        .Parameter Version
            Version for Secret

        .Parameter Enabled
            Specify if Secret is enabled

        .Parameter Expires
            Specify when Secret is expired

        .Parameter NotBefore
            Specify when Secret should take effect.

        .Parameter ContentType
            Specify ContentType Text or Blob

        .Parameter Tags
            Unique Tag Identifiers

        .Parameter SecretValue
            Secret Value to lock away in the KeyVault
            
        .EXAMPLE
            New-PSAdminKeyVaultSecret -VaultName "<VaultName>" -Name "<NameOfSecret>" -Enabled True -ContentType txt -SecretValue "My Secret Value"

        .INPUTS
            PSAdminKeyVaultSecret.PSAdmin.Module, or any specific object that contains VaultName, Name, SecretValue

        .OUTPUTS
            None. When Successful

        .NOTES

        .LINK

    #>
    

    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String]$VaultName,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String]$Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Version,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("True", "False")]
        [System.String]$Enabled,

        [Parameter(ValueFromPipelineByPropertyName)]
        [DateTime]$Expires,

        [Parameter(ValueFromPipelineByPropertyName)]
        [DateTime]$NotBefore = [DateTime]::UtcNow,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("txt", "blob")]
        [System.String]$ContentType = "txt",

        [Parameter(ValueFromPipelineByPropertyName)]
        [String[]]$Tags,

        [Parameter(ValueFromPipelineByPropertyName)]
        [PSObject]$SecretValue
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
        $KeyVault = Get-PSAdminKeyVault -VaultName $VaultName -Exact

        if (@($KeyVault).Count -ne 1)
        {
            Cleanup
            throw New-PSAdminException -ErrorID KeyVaultExceptionResultCount -ArgumentList "VaultName", $VaultName, 1, $KeyVault.Count
        }

        $Result = Get-PSAdminKeyVaultSecret -Name $Name -VaultName $VaultName -Exact
        if ($Result)
        {
            Cleanup
            throw New-PSAdminException -ErrorID KeyVaultSecretExceptionExists -ArgumentList $VaultName, $Name
        }

        $Id = [Guid]::NewGuid().ToString().Replace('-', '')
        $Created = [DateTime]::UTCNow
        $Updated = [DateTime]::UTCNow

        $DBQuery = @{
            Database        = $Database
            Keys            = $Script:KeyVaultSecretConfig.TableKeys
            Table           = $Script:KeyVaultSecretConfig.TableName
            InputObject     = [PSCustomObject]@{
                VaultName   = $VaultName
                Name        = $Name
                Version     = $Version
                Id          = $Id
                Enabled     = $Enabled
                Expires     = $Expires
                NotBefore   = $NotBefore
                Created     = $Created
                Updated     = $Updated
                ContentType = $ContentType
                Tags        = $Tags
                SecretValue = ConvertTo-PSAdminKeyVaultSecretValue -VaultName $VaultName -InputData $SecretValue
            }
        }
        
        $Result = New-PSAdminSQliteObject @DBQuery

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