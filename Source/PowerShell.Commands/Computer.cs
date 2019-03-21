using System;
using PSAdmin;
using PSAdmin.Internal;
using System.Management.Automation;
using System.Collections;
using System.Collections.Generic;


namespace PSAdmin.PowerShell.Commands {
 

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
        [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 1)]
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
                    
                    ArgumentException exception = new System.ArgumentException(
                        "Open-PSAdmin must be called first", "Any"
                    );
                    ErrorRecord errorRecord = new ErrorRecord(exception, "ErrorId", ErrorCategory.InvalidArgument, null);
                    ThrowTerminatingError(errorRecord);
            }

        }

        /// <summary>
        /// Process Record
        /// </summary>
        protected override void ProcessRecord()
        {
            Data.Computer[] results = GetPSAdminComputer.Query(Id, VaultName, ComputerName, Tags, Exact);

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
        
        public static Data.Computer[] Query(string Id, string VaultName, string ComputerName, string[] Tags, bool Exact)
        {
            string filter;

            Hashtable filterTable = new Hashtable();
            filterTable.Add("Id", Id);
            filterTable.Add("VaultName", VaultName);
            filterTable.Add("ComputerName", ComputerName);

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
}