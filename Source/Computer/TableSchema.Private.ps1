class PSAdminComputer {
    [String] $Id;
    [String] $VaultName;
    [String] $ComputerName;
    [String] $Description;
    [Nullable[Datetime]] $Created;
    [Nullable[Datetime]] $Updated;
    [Nullable[Datetime]] $LastOnline;

    [String] $AssetNumber;
    [String] $SerialNumber;
    [String] $DeviceSKU;
    [String] $OSVersion;

    [String] $Location;
    [String] $Building;
    [String] $Room;
    [String] $Rack;
    [String] $Slot;

    [String] $VMHost;

    [String] $BuildDefinition;
    [String] $BuildState;
    [String] $BuildDesiredVersion;
    [String] $BuildActualVersion;

    [String] $Domain;
    [String] $Forest;

    [String] $PublicFQDN;
    [String] $LoadBalancer;
    [IPAddress] $PublicIP;
    [IPAddress] $LocalIP;
    [String] $MACAddress;

    [String[]] $Tags;
    [String] $Notes;
}

$Script:Config["PSAdminComputer"] = @{
    TableName           = "PSAdminComputer"
    TableKeys           = @("VaultName", "ComputerName", "Id")
    TableSchema         = [PSAdminComputer]@{}    
}

$Script:ComputerConfig = $Script:Config["PSAdminComputer"]