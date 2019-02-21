function Remove-PSAdminMachine
{
        <#
        .SYNOPSIS
            Removes PSAdminMachine and removes Specified Matching item.

        .DESCRIPTION
            Removes PSAdminMachine and removes Specified Matching item.
        
        .Parameter Id
            Specify identifier

        .Parameter VaultName
            Specify VaultName

        .Parameter Name
            Specify Machine Name
            
        .Parameter Match
            Specify Match Search Mode

        .EXAMPLE
            Remove-PSAdminMachine -VaultName "<VaultName>" -Name "<HostName>" 

        .EXAMPLE
            Remove-PSAdminMachine -VaultName "<VaultName>" -Name "<HostName>" -Match

        .INPUTS
            PSAdminMachine.PSAdmin.Module, or any specific object that contains Id, VaultName, Name

        .OUTPUTS
            None.

        .NOTES

        .LINK

    #>

    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Id = "*",

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String]$VaultName,
        
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.String]$Name,

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
        $Machines = Get-PSAdminMachine -VaultName $VaultName -Name $Name -Exact:(!$Match)
        
        if (-not $Machines)
        {
            Cleanup
            throw New-PSAdminException -ErrorID ExceptionUpdateDatabase
            throw ($Script:PSAdminLocale.GetElementById("MachineNotFoundException").Value -f $Name, $VaultName)
        }

        foreach ($Machine in $Machines)
        {
            if (!$PSCmdlet.ShouldProcess( ($Script:PSAdminLocale.GetElementById("MachineRemove").Value -f $Machine.Name, $Machine.VaultName) ))
            {
                continue;
            }

            $DBQuery = @{
                Database        = $Database
                Keys            = $Script:MachineConfig.TableKeys
                Table           = $Script:MachineConfig.TableName
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

    }
    
    end
    {
        Cleanup
    }
}