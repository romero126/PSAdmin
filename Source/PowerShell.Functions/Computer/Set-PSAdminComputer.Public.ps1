Function Set-PSAdminComputer
{
    <#
        .SYNOPSIS
            Sets a value for PSAdminComputer with Specified Matching Name.

        .DESCRIPTION
            Sets a value for PSAdminComputer with Specified Matching Name.
        
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

        .PARAMETER BuildDefinition
            Specify BuildDefinition

        .PARAMETER BuildState   
            Specify BuildState

        .PARAMETER BuildDesiredVersion
            Specify BuildDesiredVersion

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
            Set-PSAdminComputer -VaultName "<VaultName>" -Name "<HostName>" -<Parameter> "<Value>"
            ```
        .INPUTS
            PSAdminComputer, or any specific object that contains Id, VaultName, Name

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
        [System.String]             $ComputerName,
        
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
        [System.String]             $BuildDefinition,
        
        [Parameter()]
        [System.String]             $BuildState,
        
        [Parameter()]
        [System.String]             $BuildDesiredVersion,
        
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
        [System.String[]]           $Tags,
        
        [Parameter()]
        [System.String]             $Notes,

        [Parameter()]
        [Switch]                    $PassThru
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
            Keys            = $Script:ComputerConfig.TableKeys
            Table           = $Script:ComputerConfig.TableName
            InputObject     = [PSCustomObject]@{}
        }

        #Needs to be dynamically generated for it to work properly
        foreach ($Param in $PSBoundParameters.GetEnumerator())
        {
            if ($Param.Key -eq 'PassThru')
            {
                Continue;
            }
            if ($Param.Key -eq 'Tags')
            {
                Add-Member -InputObject $DBQuery.InputObject -MemberType NoteProperty -Name $Param.Key -Value ($Param.Value -join ';')
                Continue;
            }
            Add-Member -InputObject $DBQuery.InputObject -MemberType NoteProperty -Name $Param.Key -Value $Param.Value
        }
        Add-Member -InputObject $DBQuery.InputObject -MemberType NoteProperty -Name "Updated" -Value ([DateTime]::UtcNow)

        $Result = Set-PSAdminSQliteObject @DBQuery -Match

        if ($Result -eq -1)
        {
            Cleanup
            throw New-PSAdminException -ErrorID ExceptionUpdateDatabase
        }

        if ($PassThru) {
            $Result = Get-PSAdminComputer -VaultName $VaultName -ComputerName $ComputerName -Exact
            [PSAdminComputer]$Result
        }

    }
    
    end
    {
        Cleanup
    }
}