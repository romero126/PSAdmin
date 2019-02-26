function Get-PSAdminMachine
{
    <#
        .SYNOPSIS
            Searches PSAdminMachine for an machine with Specified Matching Name

        .DESCRIPTION
            Searches PSAdminMachine for an machine with Specified Matching Name
        
        .PARAMETER Id
            Specify Id

        .PARAMETER VaultName
            Specify VaultName

        .PARAMETER Name
            Specify Machine Name

        .PARAMETER Exact
            Specify Exact Search Mode

        .EXAMPLE
            Get-PSAdminMachine -VaultName "<VaultName>" -Name "<HostName>"

        .EXAMPLE
            Get-PSAdminMachine -VaultName "<VaultName>" -Name "<HostName>"

        .INPUTS
            PSAdminMachine.PSAdmin.Module, or any specific object that contains Id, VaultName, Name

        .OUTPUTS
            PSAdminMachine.PSAdmin.Module.

        .NOTES

        .LINK
    #>
    
    [OutputType([PSCustomObject[]])]
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Id          = "*",

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position=0)]
        [System.String]$VaultName,

        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position=1)]
        [System.String]$Name        = "*",
        
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
            Keys            = $Script:MachineConfig.TableKeys
            Table           = $Script:MachineConfig.TableName
            InputObject     = [PSCustomObject]@{
                VaultName       = $VaultName
                Name            = $Name
                Id              = $Id
                Tags            = $Tags
            }
        }

        $Results = Get-PSAdminSQliteObject @DBQuery -Match:(!$Exact)
        
        foreach ($Result in $Results) {
            $Result.Tags = $Result.Tags -split ';'
            [PSAdminMachine]$Result
        }

    }

    end
    {
        Cleanup
    }
}