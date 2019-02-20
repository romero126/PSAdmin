function Remove-PSAdminMachine
{
    <#
        .SYNOPSIS
            Removes PSAdminMachine and removes Specified Matching item.

        .DESCRIPTION
            Removes PSAdminMachine and removes Specified Matching item.
        
        .Parameter Name
            Unique Machine Name

        .Parameter Id
            Unique identifier

        .Parameter SQLIdentity
            Unique SQLIdentity
            
        .Parameter Match
            Specify Match Search Mode

        .EXAMPLE
            Remove-PSAdminMachine -Name "<HostName>" 

        .EXAMPLE
            Remove-PSAdminMachine -Name "<HostName>" -Match

        .INPUTS
            PSAdminMachine.PSAdmin.Module, or any specific object that contains Id, Name, SQLIdentity

        .OUTPUTS
            None.

        .NOTES

        .LINK

    #>

    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipeline, Position=0, ValueFromPipelineByPropertyName)]
        [System.String]$Name,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Id,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$SQLIdentity,

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
        #Generate Parameters without CommonParameters and Match
        $Params = @{}
        $PSBoundParameters.GetEnumerator() | 
            Where-Object Key -ne "Match" | 
                Where-Object { @([System.Management.Automation.PSCmdlet]::OptionalCommonParameters + [System.Management.Automation.PSCmdlet]::CommonParameters) -NotContains $_.Key } |
                    ForEach-Object {
                        $Params.Add($_.Key, $_.Value)
                    }

        $Machines = Get-PSAdminMachine @Params -Exact:(!$Match)

        if (!$Machines)
        {
            Cleanup
            throw ($Script:PSAdminLocale.GetElementById("MachineNotFound").Value -f $Name)
        }

        foreach ($Machine in $Machines)
        {
            if (!$PSCmdlet.ShouldProcess( ($Script:PSAdminLocale.GetElementById("MachineRemove").Value -f $Machine.Name) ))
            {
                continue;
            }

            $DBQuery = @{
                Database        = $Database
                Keys            = $Script:PSAdminMachineSchema.DB.Table.KEY | ForEach-Object { $_ }
                Table           = $Script:PSAdminMachineSchema.DB.Table.Name
                InputObject     = $Machine
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