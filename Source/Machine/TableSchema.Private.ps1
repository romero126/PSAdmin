class PSAdminMachine {
    [String] $Id;
    [String] $VaultName;
    [String] $Name;
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

    [String] $MachineDefinition;
    [String] $ProvisioningState;
    [String] $DesiredVersion;
    [String] $ActualVersion;

    [String] $Domain;
    [String] $Forest;

    [String] $PublicFQDN;
    [String] $LoadBalancer;
    [IPAddress] $PublicIP;
    [IPAddress] $LocalIP;
    [String] $MACAddress;

    [String] $Tags;
    [String] $Notes;
}

$Script:MachineConfig = @{
    TableName           = "PSAdminMachine"
    TableKeys           = @("VaultName", "Name", "Id")
    TableSchema         = [PSAdminMachine]@{}
}