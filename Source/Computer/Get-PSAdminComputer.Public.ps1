function Get-PSAdminComputer
{
    <#
        .SYNOPSIS
            Searches PSAdminComputer for an machine with Specified Matching Name

        .DESCRIPTION
            Searches PSAdminComputer for an machine with Specified Matching Name
        
        .PARAMETER Id
            Specify Id

        .PARAMETER VaultName
            Specify VaultName

        .PARAMETER ComputerName
            Specify ComputerName Name

        .PARAMETER Exact
            Specify Exact Search Mode

        .EXAMPLE
            Gets the PSAdminComputer from a Vault from WildCard
            Searches the Vault for a Hostname and retrieves its data
            ``` powershell
            Get-PSAdminComputer -VaultName "<VaultName>" -Name "*"
            ```
        .EXAMPLE
            Gets a PSAdminComputer from a Vault
            Searches the Vault for a Hostname and retrieves its data
            ``` powershell
            Get-PSAdminComputer -VaultName "<VaultName>" -Name "<HostName>"
            ```
        .INPUTS
            PSAdminComputer, or any specific object that contains Id, VaultName, Name

        .OUTPUTS
            PSAdminComputer.

        .NOTES

        .LINK
    #>
    
    [OutputType([PSCustomObject[]])]
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Id                  = "*",

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position=0)]
        [System.String]$VaultName,

        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position=1)]
        [System.String]$ComputerName        = "*",
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [String[]]$Tags = "*",

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
            Keys            = $Script:ComputerConfig.TableKeys + "Tags"
            Table           = $Script:ComputerConfig.TableName
            InputObject     = [PSCustomObject]@{
                VaultName       = $VaultName
                ComputerName    = $ComputerName
                Id              = $Id
                Tags            = $Tags
            }
        }

        $Results = Get-PSAdminSQliteObject @DBQuery -Match:(!$Exact)
        
        foreach ($Result in $Results) {
            $Result.Tags = $Result.Tags -split ';'
            [PSAdminComputer]$Result
        }
    }

    end
    {
        Cleanup
    }
}