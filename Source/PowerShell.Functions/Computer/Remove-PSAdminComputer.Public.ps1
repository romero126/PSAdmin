function Remove-PSAdminComputer
{
        <#
        .SYNOPSIS
            Removes PSAdminComputer and removes Specified Matching item.

        .DESCRIPTION
            Removes PSAdminComputer and removes Specified Matching item.
        
        .Parameter Id
            Specify identifier

        .Parameter VaultName
            Specify VaultName

        .Parameter ComputerName
            Specify Machine Name
            
        .Parameter Match
            Specify Match Search Mode

        .EXAMPLE

            ``` powershell
            Remove-PSAdminComputer -VaultName "<VaultName>" -Name "<HostName>" 
            ```
        .EXAMPLE

            ``` powershell
            Remove-PSAdminComputer -VaultName "<VaultName>" -Name "<HostName>" -Match
            ```
        .INPUTS
            PSAdminComputer, or any specific object that contains Id, VaultName, Name

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
        [System.String]$ComputerName,

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
        $Computers = Get-PSAdminComputer -VaultName $VaultName -ComputerName $ComputerName -Exact:(!$Match)
        
        if (-not $Computers)
        {
            Cleanup
            throw New-PSAdminException -ErrorID ExceptionUpdateDatabase
            throw ($Script:PSAdminLocale.GetElementById("MachineNotFoundException").Value -f $ComputerName, $VaultName)
        }

        foreach ($Computer in $Computers)
        {
            if (!$PSCmdlet.ShouldProcess( ($Script:PSAdminLocale.GetElementById("MachineRemove").Value -f $Computer.ComputerName, $Computer.VaultName) ))
            {
                continue;
            }

            $DBQuery = @{
                Database        = $Database
                Keys            = $Script:ComputerConfig.TableKeys
                Table           = $Script:ComputerConfig.TableName
                InputObject     = [PSCustomObject]@{
                    VaultName       = $Computer.VaultName
                    ComputerName    = $Computer.ComputerName
                    Id              = $Computer.Id
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