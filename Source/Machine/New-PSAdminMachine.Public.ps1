function New-PSAdminMachine
{
    <#
        .SYNOPSIS
            Searches PSAdminMachine for an machine with Specified Matching Name.

        .DESCRIPTION
            Searches PSAdminMachine for an machine with Specified Matching Name.
        
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

        .PARAMETER Exact
            Specify Search Mode

        .EXAMPLE
            New-PSAdminMachine -VaultName "<VaultName>" -Name "<HostName>"

        .EXAMPLE
            New-PSAdminMachine -VaultName "<VaultName>" -Name "<HostName>" -<Parameter> "Value"

        .INPUTS
            PSAdminMachine.PSAdmin.Module, or any specific object that contains Id, VaultName, Name

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
        [System.String]             $Name,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $Description,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.DateTime]           $LastOnline,
        
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
        [System.String]             $MachineDefinition,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $ProvisioningState,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $DesiredVersion,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]             $ActualVersion,
        
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

        $Result = Get-PSAdminMachine -VaultName $VaultName -Name $Name -Exact
        if ($Result)
        {
            Cleanup
            throw New-PSAdminException -ErrorID MachineExistsException -ArgumentList $VaultName, $Name
        }

        $Id = [Guid]::NewGuid().ToString().Replace('-', '')
        $Created = [DateTime]::UTCNow
        $Updated = [DateTime]::UTCNow

        $DBQuery = @{
            Database        = $Database
            Keys            = $Script:MachineConfig.TableKeys
            Table           = $Script:MachineConfig.TableName
            InputObject     = [PSCustomObject]@{
                Id                  = $Id
                VaultName           = $VaultName
                Name                = $Name
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
                MachineDefinition   = $MachineDefinition
                ProvisioningState   = $ProvisioningState
                DesiredVersion      = $DesiredVersion
                ActualVersion       = $ActualVersion
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
        if ($Passthru) {
            [PSAdminMachine]@($DBQuery.InputObject)
        }


    }

    end
    {
        Cleanup
    }
}