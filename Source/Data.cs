using System;
using System.Net;
using System.Management.Automation;

namespace PSAdmin.Data
{
    public sealed class KeyVault
    {
        public System.String            Id;
        public System.String            VaultName;
        public System.String            Location;
        public System.String            VaultURI;
        public System.String            SKU;
        public System.String            SoftDeleteEnabled;
        public System.String            Thumbprint;
        public byte[]                   VaultKey;
        public System.String            ResourceGroup;
        public System.String            ResourceID;
        public System.String[]          Tags;
    }

    public sealed class KeyVaultCertificate
    {
        public String                   Id;
        public String                   VaultName;
        public String                   Name;
        public String                   Version;
        public String                   Enabled;
        public String                   DeletedDate;
        public String                   RecoveryLevel;
        public Nullable<DateTime>       Created;
        public Nullable<DateTime>       Updated;
        public Nullable<DateTime>       NotBefore;
        public Nullable<DateTime>       Expires;
        public Nullable<DateTime>       ScheduledPurgeDate;
        public String                   SecretId;
        public String                   KeyId;
        public Object                   Certificate;
        public String                   Thumbprint;   
        public String                   Tags;
    }

    public sealed class Computer
    {
        public String                   Id;
        public String                   VaultName;
        public String                   ComputerName;
        public String                   Description;
        public Nullable<DateTime>       Created;
        public Nullable<DateTime>       Updated;
        public Nullable<DateTime>       LastOnline;
        public String                   AssetNumber;
        public String                   SerialNumber;
        public String                   DeviceSKU;
        public String                   OSVersion;
        public String                   Location;
        public String                   Building;
        public String                   Room;
        public String                   Rack;
        public String                   Slot;
        public String                   VMHost;
        public String                   BuildDefinition;
        public String                   BuildState;
        public String                   BuildDesiredVersion;
        public String                   BuildActualVersion;
        public String                   Domain;
        public String                   Forest;
        public String                   PublicFQDN;
        public String                   LoadBalancer;
        public IPAddress                PublicIP;
        public IPAddress                LocalIP;
        public String                   MACAddress;
        public String[]                 Tags;
        public String                   Notes;
    }

}   