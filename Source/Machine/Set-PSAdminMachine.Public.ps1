Function Set-PSAdminMachine
{
    <#
        .SYNOPSIS
            Sets a value for PSAdminMachine with Specified Matching Name.

        .DESCRIPTION
            Sets a value for PSAdminMachine with Specified Matching Name.
        
        .PARAMETER VaultName
            Specify VaultName

        .PARAMETER Name
            Specify Name

        .PARAMETER Description
            Specify Description

        .PARAMETER LastOnline
            Specify LastOnline

        .PARAMETER AssetNumber
            Specify AssetNumber

        .PARAMETER SerialNumber
            Specify SerialNumber

        .PARAMETER DeviceSKU
            Specify DeviceSKU

        .PARAMETER OSVersion
            Specify OSVersion

        .PARAMETER Location
            Specify Location

        .PARAMETER Building
            Specify Building

        .PARAMETER Room
            Specify Room

        .PARAMETER Rack
            Specify Rack

        .PARAMETER Slot
            Specify Slot

        .PARAMETER VMHost
            Specify VMHost

        .PARAMETER MachineDefinition
            Specify MachineDefinition

        .PARAMETER ProvisioningState
            Specify ProvisioningState

        .PARAMETER DesiredVersion
            Specify DesiredVersion

        .PARAMETER ActualVersion
            Specify ActualVersion

        .PARAMETER Domain
            Specify Domain

        .PARAMETER Forest
            Specify Forest

        .PARAMETER PublicFQDN
            Specify PublicFQDN

        .PARAMETER LoadBalancer
            Specify LoadBalancer

        .PARAMETER PublicIP
            Specify PublicIP

        .PARAMETER LocalIP
            Specify LocalIP

        .PARAMETER MACAddress
            Specify MACAddress

        .PARAMETER Tags
            Specify Tags

        .PARAMETER Notes
            Specify Notes

        .EXAMPLE

            ``` powershell
            Set-PSAdminMachine -VaultName "<VaultName>" -Name "<HostName>" -<Parameter> "<Value>"
            ```
        .INPUTS
            PSAdminMachine.PSAdmin.Module, or any specific object that contains Id, VaultName, Name

        .OUTPUTS
            None.

        .NOTES

        .LINK

    #>

    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $Id,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position=0)]
        [System.String]             $VaultName,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position=1)]
        [System.String]             $Name,
        
        [Parameter()]
        [System.String]             $Description,
        
        [Parameter()]
        [Nullable[System.DateTime]] $LastOnline,
        
        [Parameter()]
        [System.String]             $AssetNumber,
        
        [Parameter()]
        [System.String]             $SerialNumber,
        
        [Parameter()]
        [System.String]             $DeviceSKU,
        
        [Parameter()]
        [System.String]             $OSVersion,
        
        [Parameter()]
        [System.String]             $Location,
        
        [Parameter()]
        [System.String]             $Building,
        
        [Parameter()]
        [System.String]             $Room,
        
        [Parameter()]
        [System.String]             $Rack,
        
        [Parameter()]
        [System.String]             $Slot,
        
        [Parameter()]
        [System.String]             $VMHost,
        
        [Parameter()]
        [System.String]             $MachineDefinition,
        
        [Parameter()]
        [System.String]             $ProvisioningState,
        
        [Parameter()]
        [System.String]             $DesiredVersion,
        
        [Parameter()]
        [System.String]             $ActualVersion,
        
        [Parameter()]
        [System.String]             $Domain,
        
        [Parameter()]
        [System.String]             $Forest,
        
        [Parameter()]
        [System.String]             $PublicFQDN,
        
        [Parameter()]
        [System.String]             $LoadBalancer,
        
        [Parameter()]
        [IPAddress]                 $PublicIP,
        
        [Parameter()]
        [IPAddress]                 $LocalIP,
        
        [Parameter()]
        [System.String]             $MACAddress, 
        
        [Parameter()]
        [System.String[]]             $Tags,
        
        [Parameter()]
        [System.String]             $Notes

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
            InputObject     = [PSCustomObject]@{}
        }

        #Needs to be dynamically generated for it to work properly
        foreach ($Param in $PSBoundParameters.GetEnumerator())
        {
            if ($Param.Key -eq 'Tags')
            {
                Add-Member -InputObject $DBQuery.InputObject -MemberType NoteProperty -Name $Param.Key -Value ($Param.Value -join ';')
                Continue;
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

        if ($PassThru) {
            $Result = Get-PSAdminMachine -VaultName $VaultName -Name $Name -Exact
            if ($Result)
            {
                [PSAdminmachine]$Result
            }
        }

    }
    
    end
    {
        Cleanup
    }
}