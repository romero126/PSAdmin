function Get-PSAdminKeyVault {
    <#
        .SYNOPSIS
            Searches KeyVault for an Item with the specified Id/Name and returns results.

        .DESCRIPTION
            Searches KeyVault for an Item with the specified Id/Name and returns results.
        
        .PARAMETER Id
            Unique Identifier for KeyVault
        
        .Parameter VaultName
            Unique Name for KeyVault

        .Parameter Exact
            Specify for Exact Search based on ID/Name

        .EXAMPLE
            Get-PSAdminKeyVault -VaultName "<VaultName>"

        .INPUTS
            PSAdminKeyVault.PSAdmin.Module, or any specific object that contains Id, Name

        .OUTPUTS
            PSAdminKeyVault.PSAdmin.Module.

        .NOTES

        .LINK

    #>

    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Id = "*",

        [Parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [System.String]$VaultName = "*",

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
            Keys            = ("VaultName", "Id")
            Table           = "PSAdminKeyVault"
            InputObject = [PSCustomObject]@{
                Id                      = $Id
                VaultName               = $VaultName
            }
        }
        $Results = Get-PSAdminSQliteObject @DBQuery -Match:(!$Exact)
        
        foreach ($Result in $Results) {
            $Result.PSObject.TypeNames.Insert(0, "PSAdminKeyVault.PSAdmin.Module")            
            $Result
        }
    }

    end
    {
        Cleanup
    }

}