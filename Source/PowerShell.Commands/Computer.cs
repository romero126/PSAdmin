using System;
using PSAdmin;
using PSAdmin.Internal;

using System.Management.Automation;
using System.Collections;
using System.Collections.Generic;
using System.Net;

namespace PSAdmin.PowerShell.Commands {

    #region New
    /// <summary>
    /// Creates a PSAdmin KeyVault.
    /// </summary>
    [Cmdlet(VerbsCommon.New, "PSAdminComputer")]
    [OutputType(typeof(System.String))]
    public sealed class NewPSAdminComputer : PSCmdlet
    {

        /// <summary>
        /// Specify VaultName
        /// </summary>
        [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 0)]
        public string VaultName { get; set; }

        /// <summary>
        /// Specify VaultName
        /// </summary>
        [Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 1)]
        public string ComputerName { get; set; }

        /// <summary>
        /// Specify a Description
        /// </summary>
        [Parameter()]
        public string Description { get; set; }

        /// <summary>
        /// Specify a LastOnline
        /// </summary>
        [Parameter()]
        public Nullable<DateTime> LastOnline { get; set; }

        /// <summary>
        /// Specify an AssetNumber
        /// </summary>
        [Parameter()]
        public string AssetNumber { get; set; }

        /// <summary>
        /// Specify an SerialNumber
        /// </summary>
        [Parameter()]
        public string SerialNumber { get; set; }

        /// <summary>
        /// Specify an DeviceSKU
        /// </summary>
        [Parameter()]
        public string DeviceSKU { get; set; }

        /// <summary>
        /// Specify an OSVersion
        /// </summary>
        [Parameter()]
        public string OSVersion { get; set; }

        /// <summary>
        /// Specify an Location
        /// </summary>
        [Parameter()]
        public string Location { get; set; }

        /// <summary>
        /// Specify an Building
        /// </summary>
        [Parameter()]
        public string Building { get; set; }

        /// <summary>
        /// Specify an Room
        /// </summary>
        [Parameter()]
        public string Room { get; set; }

        /// <summary>
        /// Specify an Rack
        /// </summary>
        [Parameter()]
        public string Rack { get; set; }

        /// <summary>
        /// Specify an Slot
        /// </summary>
        [Parameter()]
        public string Slot { get; set; }

        /// <summary>
        /// Specify an VMHost
        /// </summary>
        [Parameter()]
        public string VMHost { get; set; }

        /// <summary>
        /// Specify an BuildDefinition
        /// </summary>
        [Parameter()]
        public string BuildDefinition { get; set; }

        /// <summary>
        /// Specify an Location
        /// </summary>
        [Parameter()]
        public string BuildState { get; set; }

        /// <summary>
        /// Specify an Location
        /// </summary>
        [Parameter()]
        public string BuildDesiredVersion { get; set; }

        /// <summary>
        /// Specify an BuildActualVersion
        /// </summary>
        [Parameter()]
        public string BuildActualVersion { get; set; }

        /// <summary>
        /// Specify a Domain
        /// </summary>
        [Parameter()]
        public string Domain { get; set; }

        /// <summary>
        /// Specify a Forest
        /// </summary>
        [Parameter()]
        public string Forest { get; set; }

        /// <summary>
        /// Specify a PublicFQDN
        /// </summary>
        [Parameter()]
        public string PublicFQDN { get; set; }

        /// <summary>
        /// Specify a LoadBalancer
        /// </summary>
        [Parameter()]
        public string LoadBalancer { get; set; }

        /// <summary>
        /// Specify a PublicIP
        /// </summary>
        [Parameter()]
        public IPAddress PublicIP { get; set; }

        /// <summary>
        /// Specify a LocalIP
        /// </summary>
        [Parameter()]
        public IPAddress LocalIP { get; set; }

        /// <summary>
        /// Specify a MACAddress
        /// </summary>
        [Parameter()]
        public string MACAddress { get; set; }

        /// <summary>
        /// Specify a Notes
        /// </summary>
        [Parameter()]
        public string Notes { get; set; }

        /// <summary>
        /// Specify Exact
        /// </summary>
        [Parameter()]
        public SwitchParameter Exact { get; set; }

        /// <summary>
        /// Specify Tags
        /// </summary>
        [Parameter()]
        public String[] Tags { get; set; }

        /// <summary>
        /// Specify Passthru
        /// </summary>
        [Parameter()]
        public SwitchParameter Passthru { get; set; }

        /// <summary>
        /// Begin output
        /// </summary>
        protected override void BeginProcessing()
        {
            if (String.IsNullOrEmpty(Config.SQLConnectionString)) {
                    ThrowTerminatingError(
                        (new KevinBlumenfeldException(KevinBlumenfeldExceptionType.DatabaseNotOpen) ).GetErrorRecord()
                    );
            }   
        }

        /// <summary>
        /// Process Record
        /// </summary>
        protected override void ProcessRecord()
        {

            Data.KeyVault KeyVault = KeyVaultHelper.GetItem(null, VaultName, true);

            Data.Computer[] searchcomputer = GetPSAdminComputer.Call(null, VaultName, ComputerName, null, true);
            if (searchcomputer.Length > 0)
            {
                WriteError(
                    (new KevinBlumenfeldException(KevinBlumenfeldExceptionType.ItemExists, ComputerName, "ComputerName")).GetErrorRecord()
                );
                return;
            }
            
            Hashtable item = new Hashtable {
                { "Id",                     Guid.NewGuid().ToString().Replace("-", "") },
                { "VaultName",              VaultName },
                { "ComputerName",           ComputerName },
                { "Description",            Description },
                { "Created",                DateTime.UtcNow },
                { "Updated",                DateTime.UtcNow },
                { "LastOnline",             LastOnline },
                { "AssetNumber",            AssetNumber },
                { "SerialNumber",           SerialNumber },
                { "DeviceSKU",              DeviceSKU },
                { "OSVersion",              OSVersion },
                { "Location",               Location },
                { "Building",               Building },
                { "Room",                   Room },
                { "Rack",                   Rack },
                { "Slot",                   Slot },
                { "VMHost",                 VMHost },
                { "BuildDefinition",        BuildDefinition },
                { "BuildState",             BuildState },
                { "BuildDesiredVersion",    BuildDesiredVersion },
                { "BuildActualVersion",     BuildActualVersion },
                { "Domain",                 Domain },
                { "Forest",                 Forest },
                { "PublicFQDN",             PublicFQDN },
                { "LoadBalancer",           LoadBalancer },
                { "PublicIP",               PublicIP },
                { "LocalIP",                LocalIP },
                { "MACAddress",             MACAddress },
                { "Notes",                  Notes }
            };
            if (Tags != null)
                item.Add("Tags",            String.Join(";", Tags));

            bool issuccessful = Call(item);
            
            if (!issuccessful)
            {
                WriteError(
                    (new KevinBlumenfeldException(KevinBlumenfeldExceptionType.RowCreate)).GetErrorRecord()
                );
            }
            if (Passthru)
            {
                Data.Computer[] results = GetPSAdminComputer.Call(null, VaultName, ComputerName, null, true);

                // Unroll the object
                foreach (Data.Computer result in results)
                    WriteObject( result );
            }
        }

        /// <summary>
        /// End Processing
        /// </summary>
        protected override void EndProcessing()
        {

        }
        public static bool Call(Hashtable Properties)
        {
            return SQLiteDB.CreateRow("PSAdminComputer", Properties);
        }
    }
    #endregion

    #region Get
    /// <summary>
    /// Returns a PSAdmin Computer from the database.
    /// </summary>
    [Cmdlet(VerbsCommon.Get, "PSAdminComputer")]
    [OutputType(typeof(System.String))]
    public sealed class GetPSAdminComputer : PSCmdlet
    {
        
        /// <summary>
        /// Specify Id
        /// </summary>
        [Parameter(ValueFromPipelineByPropertyName = true)]
        public string Id { get; set; }

        /// <summary>
        /// Specify VaultName
        /// </summary>
        [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 0)]
        public string VaultName { get; set; }

        /// <summary>
        /// Specify ComputerName
        /// </summary>
        [Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 1)]
        public String ComputerName { get; set; }

        /// <summary>
        /// Specify Tags to search by
        /// </summary>
        [Parameter(ValueFromPipelineByPropertyName = true)]
        public String[] Tags { get; set; }

        /// <summary>
        /// Specify search for exact variables
        /// </summary>
        [Parameter()]
        public SwitchParameter Exact { get; set; }

        /// <summary>
        /// Searches PSAdminComputer for an machine with Specified Matching Name
        /// </summary>
        protected override void BeginProcessing()
        {
            if (String.IsNullOrEmpty(Config.SQLConnectionString)) {
                ThrowTerminatingError(
                    (new KevinBlumenfeldException(KevinBlumenfeldExceptionType.DatabaseNotOpen) ).GetErrorRecord()
                );
            }
        }

        /// <summary>
        /// Process Record
        /// </summary>
        protected override void ProcessRecord()
        {
            Data.Computer[] results = Call(Id, VaultName, ComputerName, Tags, Exact);

            // Unroll the object
            foreach (Data.Computer result in results)
                WriteObject( result );

        }

        /// <summary>
        /// End Processing
        /// </summary>
        protected override void EndProcessing()
        {

        }
        
        public static Data.Computer[] Call(string Id, string VaultName, string ComputerName, string[] Tags, bool Exact)
        {
            string filter;

            Hashtable filterTable = new Hashtable {
                { "Id",         Id },
                { "VaultName",  VaultName },
                { "ComputerName", ComputerName }
            };

            filter = SQLiteDB.Filter(filterTable, Exact);
            
            string filterTags = SQLiteDB.Filter("Tags", Tags, false);
            if (!String.IsNullOrEmpty(filterTags)) {
                filter = String.Format("{0} AND {1}", filter, filterTags);
            }

            Data.Computer[] result = SQLiteDB.ConvertToType<Data.Computer[]>(
                SQLiteDB.GetRow("PSAdminComputer", filter)
            );

            return result;
        }
    }
    #endregion

    #region Set
    /// <summary>
    /// Creates a PSAdmin KeyVault.
    /// </summary>
    [Cmdlet(VerbsCommon.Set, "PSAdminComputer")]
    [OutputType(typeof(System.String))]
    public sealed class SetPSAdminComputer : PSCmdlet
    {
        /// <summary>
        ///
        /// </summary>
        [Parameter(ValueFromPipelineByPropertyName = true)]
        public string Id {get; set; }

        /// <summary>
        /// Specify VaultName
        /// </summary>
        [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 0)]
        public string VaultName { get; set; }

        /// <summary>
        /// Specify VaultName
        /// </summary>
        [Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 1)]
        public string ComputerName { get; set; }

        /// <summary>
        /// Specify a Description
        /// </summary>
        [Parameter()]
        public string Description { get; set; }

        /// <summary>
        /// Specify a LastOnline
        /// </summary>
        [Parameter()]
        public Nullable<DateTime> LastOnline { get; set; }

        /// <summary>
        /// Specify an AssetNumber
        /// </summary>
        [Parameter()]
        public string AssetNumber { get; set; }

        /// <summary>
        /// Specify an SerialNumber
        /// </summary>
        [Parameter()]
        public string SerialNumber { get; set; }

        /// <summary>
        /// Specify an DeviceSKU
        /// </summary>
        [Parameter()]
        public string DeviceSKU { get; set; }

        /// <summary>
        /// Specify an OSVersion
        /// </summary>
        [Parameter()]
        public string OSVersion { get; set; }

        /// <summary>
        /// Specify an Location
        /// </summary>
        [Parameter()]
        public string Location { get; set; }

        /// <summary>
        /// Specify an Building
        /// </summary>
        [Parameter()]
        public string Building { get; set; }

        /// <summary>
        /// Specify an Room
        /// </summary>
        [Parameter()]
        public string Room { get; set; }

        /// <summary>
        /// Specify an Rack
        /// </summary>
        [Parameter()]
        public string Rack { get; set; }

        /// <summary>
        /// Specify an Slot
        /// </summary>
        [Parameter()]
        public string Slot { get; set; }

        /// <summary>
        /// Specify an VMHost
        /// </summary>
        [Parameter()]
        public string VMHost { get; set; }

        /// <summary>
        /// Specify an BuildDefinition
        /// </summary>
        [Parameter()]
        public string BuildDefinition { get; set; }

        /// <summary>
        /// Specify an Location
        /// </summary>
        [Parameter()]
        public string BuildState { get; set; }

        /// <summary>
        /// Specify an Location
        /// </summary>
        [Parameter()]
        public string BuildDesiredVersion { get; set; }

        /// <summary>
        /// Specify an BuildActualVersion
        /// </summary>
        [Parameter()]
        public string BuildActualVersion { get; set; }

        /// <summary>
        /// Specify a Domain
        /// </summary>
        [Parameter()]
        public string Domain { get; set; }

        /// <summary>
        /// Specify a Forest
        /// </summary>
        [Parameter()]
        public string Forest { get; set; }

        /// <summary>
        /// Specify a PublicFQDN
        /// </summary>
        [Parameter()]
        public string PublicFQDN { get; set; }

        /// <summary>
        /// Specify a LoadBalancer
        /// </summary>
        [Parameter()]
        public string LoadBalancer { get; set; }

        /// <summary>
        /// Specify a PublicIP
        /// </summary>
        [Parameter()]
        public IPAddress PublicIP { get; set; }

        /// <summary>
        /// Specify a LocalIP
        /// </summary>
        [Parameter()]
        public IPAddress LocalIP { get; set; }

        /// <summary>
        /// Specify a MACAddress
        /// </summary>
        [Parameter()]
        public string MACAddress { get; set; }

        /// <summary>
        /// Specify a Notes
        /// </summary>
        [Parameter()]
        public string Notes { get; set; }

        /// <summary>
        /// Specify Exact
        /// </summary>
        [Parameter()]
        public SwitchParameter Exact { get; set; }

        /// <summary>
        /// Specify Tags
        /// </summary>
        [Parameter()]
        public String[] Tags { get; set; }

        /// <summary>
        /// Specify Passthru
        /// </summary>
        [Parameter()]
        public SwitchParameter Passthru { get; set; }


        /// <summary>
        /// Begin output
        /// </summary>
        protected override void BeginProcessing()
        {
            if (String.IsNullOrEmpty(Config.SQLConnectionString)) {
                    
                ThrowTerminatingError(
                    (new KevinBlumenfeldException(KevinBlumenfeldExceptionType.DatabaseNotOpen)).GetErrorRecord()
                );
            }
        }

        /// <summary>
        /// Process Record
        /// </summary>
        protected override void ProcessRecord()
        {
            Data.KeyVault[] searchvaults = KeyVaultHelper.GetItemsThrow(null, VaultName, true);

            Data.Computer[] searchcomputer = GetPSAdminComputer.Call(null, VaultName, ComputerName, null, Exact);
            if (searchcomputer.Length == 0)
            {
                WriteError(
                    (new KevinBlumenfeldException(KevinBlumenfeldExceptionType.ItemNotFoundLookup, ComputerName, "ComputerName")).GetErrorRecord()
                );
                return;
            }

            Hashtable filter = new Hashtable {
                {"Id",                  Id },
                {"VaultName",           VaultName },
                { "ComputerName",       ComputerName }
            };

            Hashtable item = new Hashtable {
                { "Description",            Description },
                { "Updated",                DateTime.UtcNow },
                { "LastOnline",             LastOnline },
                { "AssetNumber",            AssetNumber },
                { "SerialNumber",           SerialNumber },
                { "DeviceSKU",              DeviceSKU },
                { "OSVersion",              OSVersion },
                { "Location",               Location },
                { "Building",               Building },
                { "Room",                   Room },
                { "Rack",                   Rack },
                { "Slot",                   Slot },
                { "VMHost",                 VMHost },
                { "BuildDefinition",        BuildDefinition },
                { "BuildState",             BuildState },
                { "BuildDesiredVersion",    BuildDesiredVersion },
                { "BuildActualVersion",     BuildActualVersion },
                { "Domain",                 Domain },
                { "Forest",                 Forest },
                { "PublicFQDN",             PublicFQDN },
                { "LoadBalancer",           LoadBalancer },
                { "PublicIP",               PublicIP },
                { "LocalIP",                LocalIP },
                { "MACAddress",             MACAddress },
                { "Notes",                  Notes }
            };
            if (Tags != null)
                item.Add("Tags",            String.Join(";", Tags));

            bool issuccessful = Call(item, filter, Exact);
            
            if (!issuccessful)
            {
                WriteError(
                    (new KevinBlumenfeldException(KevinBlumenfeldExceptionType.RowUpdate)).GetErrorRecord()
                );
            }
            if (Passthru)
            {
                Data.Computer[] results = GetPSAdminComputer.Call(null, VaultName, ComputerName, null, true);

                // Unroll the object
                foreach (Data.Computer result in results)
                    WriteObject( result );
            }
        }

        /// <summary>
        /// End Processing
        /// </summary>
        protected override void EndProcessing()
        {

        }
        
        public static bool Call(Hashtable table, Hashtable filter, bool Exact)
        {
            return SQLiteDB.UpdateRow("PSAdminComputer", table, filter, Exact);
        }
    }
    #endregion

    #region Remove
    /// <summary>
    /// Returns a PSAdmin KeyVault from the database.
    /// </summary>
    [Cmdlet(VerbsCommon.Remove, "PSAdminComputer", SupportsShouldProcess = true, ConfirmImpact = ConfirmImpact.High)]
    [OutputType(typeof(System.String))]
    public sealed class RemovePSAdminComputer : PSCmdlet
    {

        /// <summary>
        /// Specify Id
        /// </summary>
        [Parameter(ValueFromPipelineByPropertyName = true)]
        public string Id { get; set; }

        /// <summary>
        /// Specify VaultName
        /// </summary>
        [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 0)]
        public string VaultName { get; set; }

        /// <summary>
        /// Specify ComputerName
        /// </summary>
        [Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 1)]
        public string ComputerName { get; set; }

        /// <summary>
        /// Specify search for exact variables
        /// </summary>
        [Parameter()]
        public SwitchParameter Match { get; set; }

        /// <summary>
        /// Begin output
        /// </summary>
        protected override void BeginProcessing()
        {
            if (String.IsNullOrEmpty(Config.SQLConnectionString)) {
                ThrowTerminatingError(
                    (new KevinBlumenfeldException(KevinBlumenfeldExceptionType.DatabaseNotOpen) ).GetErrorRecord()
                );
            }

        }

        /// <summary>
        /// Process Record
        /// </summary>
        protected override void ProcessRecord()
        {
            Data.KeyVault[] vaults = KeyVaultHelper.GetItemsThrow(null, VaultName, !Match);
            
            Data.Computer[] computers = GetPSAdminComputer.Call(Id, VaultName, ComputerName, null, !Match);

            if ((Match == false) && (computers.Length < 1)) {
                WriteError(
                    (new KevinBlumenfeldException(KevinBlumenfeldExceptionType.ItemNotFoundLookup, ComputerName, "ComputerName") ).GetErrorRecord()
                );
                return;
            }

            // Unroll the object
            foreach (Data.Computer computer in computers)
            {
                if (!ShouldProcess(computer.ComputerName, "Remove"))
                {
                    continue;
                }

                bool IsSuccessful = Call(computer.Id, computer.VaultName, computer.ComputerName, !Match);
                if (!IsSuccessful)
                {
                    WriteError(
                      (new KevinBlumenfeldException(KevinBlumenfeldExceptionType.RowDelete) ).GetErrorRecord()
                    );
                }

            }
        }

        /// <summary>
        /// End Processing
        /// </summary>
        protected override void EndProcessing()
        {

        }
        
        public static bool Call(string Id, string VaultName, string ComputerName, bool Exact)
        {
            string filter;

            Hashtable filterTable = new Hashtable {
                {"Id",                  Id },
                {"VaultName",           VaultName },
                {"ComputerName",        ComputerName }
            };

            filter = SQLiteDB.Filter(filterTable, Exact);

            return SQLiteDB.RemoveRow("PSAdminComputer", filter);
        }
    }
    #endregion
}