function New-PSAdminComputer
{
    <#
        .SYNOPSIS
            Searches PSAdminComputer for a Computer with Specified Matching Name.

        .DESCRIPTION
            Searches PSAdminComputer for a Computer with Specified Matching Name.
        
        .PARAMETER VaultName
            Specify VaultName

        .PARAMETER ComputerName
            Specify ComputerName

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

        .PARAMETER BuildActualVersion
            Specify BuildActualVersion

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

        .PARAMETER Exact
            Specify Search Mode

        .EXAMPLE

            ``` powershell
            New-PSAdminComputer -VaultName "<VaultName>" -Name "<HostName>"
            ```
        .EXAMPLE
            ``` powershell
            New-PSAdminComputer -VaultName "<VaultName>" -Name "<HostName>" -<Parameter> "Value"
            ```
        .INPUTS
            PSAdminComputer, or any specific object that contains Id, VaultName, Name

        .OUTPUTS
            None.

        .NOTES

        .LINK

    #>
    [OutputType([PSCustomObject[]])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position=0)]
        [System.String]             $VaultName,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position=1)]
        [System.String]             $ComputerName,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $Description,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [Nullable[System.DateTime]] $LastOnline,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $AssetNumber,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $SerialNumber,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $DeviceSKU,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $OSVersion,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $Location,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $Building,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $Room,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $Rack,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $Slot,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $VMHost,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $BuildDefinition,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $BuildState,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $BuildDesiredVersion,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $BuildActualVersion,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $Domain,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $Forest,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $PublicFQDN,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $LoadBalancer,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [IPAddress]                 $PublicIP,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [IPAddress]                 $LocalIP,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $MACAddress, 
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $Tags,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $Notes,

        [Parameter()]
        [Switch]                    $Exact
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

        if (!$KeyVault)
        {
            Cleanup
            throw New-PSAdminException -ErrorID KeyVaultNotFound -ArgumentList $VaultName
        }

        $Result = Get-PSAdminComputer -VaultName $VaultName -ComputerName $ComputerName -Exact
        if ($Result)
        {
            Cleanup
            throw New-PSAdminException -ErrorID MachineExistsException -ArgumentList $VaultName, $ComputerName
        }

        $Id = [Guid]::NewGuid().ToString().Replace('-', '')
        $Created = [DateTime]::UTCNow
        $Updated = [DateTime]::UTCNow

        $DBQuery = @{
            Database        = $Database
            Keys            = $Script:ComputerConfig.TableKeys
            Table           = $Script:ComputerConfig.TableName
            InputObject     = [PSCustomObject]@{
                Id                  = $Id
                VaultName           = $VaultName
                ComputerName        = $ComputerName
                Description         = $Description
                Created             = $Created
                Updated             = $Updated
                LastOnline          = $LastOnline
                AssetNumber         = $AssetNumber
                SerialNumber        = $SerialNumber
                DeviceSKU           = $DeviceSKU
                OSVersion           = $OSVersion
                Location            = $Location
                Building            = $Building
                Room                = $Room
                Rack                = $Rack
                Slot                = $Slot
                VMHost              = $VMHost
                BuildDefinition     = $BuildDefinition
                BuildState          = $BuildState
                BuildDesiredVersion = $BuildDesiredVersion
                BuildActualVersion  = $BuildActualVersion
                Domain              = $Domain
                Forest              = $Forest
                PublicFQDN          = $PublicFQDN
                LoadBalancer        = $LoadBalancer
                PublicIP            = $PublicIP
                LocalIP             = $LocalIP
                MACAddress          = $MACAddress
                Tags                = $Tags
                Notes               = $Notes
            }
        }
        
        $Result = New-PSAdminSQliteObject @DBQuery
        if ($Result -eq -1)
        {
            Cleanup
            throw New-PSAdminException -ErrorID ExceptionUpdateDatabase
        }
        if ($PassThru) {
            [PSAdminComputer]@($DBQuery.InputObject)
        }

    }

    end
    {
        Cleanup
    }
}