function Set-PSAdminKeyVaultSecret
{
    <#
        .SYNOPSIS
            Sets an property of an Existing Secret in the Vault

        .DESCRIPTION
            Sets an property of an Existing Secret in the Vault
        
        .Parameter VaultName
            Unique Name for KeyVault

        .Parameter Name
            Unique Name for Secret

        .Parameter Id
            Unique Id for Secret

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
            Set-PSAdminKeyVaultSecret -VaultName "<VaultName>" -Name "<NameOfSecret>" -Enabled True -ContentType txt -SecretValue "My Secret Value"

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
        [System.String]$Id,

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
        [System.String]$ContentType,

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
        $Updated = [DateTime]::UTCNow
        $DBQuery = @{
            Database        = $Database
            Keys            = $Script:KeyVaultSecretConfig.TableKeys
            Table           = $Script:KeyVaultSecretConfig.TableName
            InputObject     = [PSCustomObject]@{}
        }

        #Needs to be dynamically generated for it to work properly
        foreach ($Param in $PSBoundParameters.GetEnumerator())
        {
            if ( ($Param.Key -eq "SecretValue") -and (!([System.String]::IsNullOrEmpty($SecretValue))) )
            {
                $SecValue = ConvertTo-PSAdminKeyVaultSecretValue -VaultName $VaultName -InputData $SecretValue
                
                Add-Member -InputObject $DBQuery.InputObject -MemberType NoteProperty -Name $Param.Key -Value $SecValue
                continue;
            }
            Add-Member -InputObject $DBQuery.InputObject -MemberType NoteProperty -Name $Param.Key -Value $Param.Value
        }
        Add-Member -InputObject $DBQuery.InputObject -MemberType NoteProperty -Name "Updated" -Value ([DateTime]::UtcNow)

        $Result = Set-PSAdminSQliteObject @DBQuery

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