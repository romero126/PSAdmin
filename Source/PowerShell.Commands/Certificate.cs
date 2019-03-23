using System;
using System.Collections;
using System.Collections.Generic;
using System.Management.Automation;
using PSAdmin.Internal;
using System.Security;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
namespace PSAdmin.PowerShell.Commands {

    /// <summary>
    /// Returns a PSAdmin Computer from the database.
    /// </summary>
    [Cmdlet(VerbsCommon.Get, "PSAdminKeyVaultCertificate")]
    [OutputType(typeof(System.String))]
    public sealed class GetPSAdminKeyVaultCertificate : PSCmdlet
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
        /// Specify Name
        /// </summary>
        [Parameter(ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 1)]
        public String Name { get; set; }

        /// <summary>
        /// Specify Thumbprint
        /// </summary>
        [Parameter(ValueFromPipelineByPropertyName = true)]
        public String Thumbprint { get; set; }

        /// <summary>
        /// Specify Tags to search by
        /// </summary>
        [Parameter(ValueFromPipelineByPropertyName = true)]
        public String[] Tags { get; set; }

        
        /// <summary>
        /// Mark Certificate as Exportable
        /// </summary>
        [Parameter()]
        public SwitchParameter Export { get; set; }

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
                        KevinBlumenfeldException.Create(KevinExceptions.DatabaseNotOpen)
                    );
            }

        }

        /// <summary>
        /// Process Record
        /// </summary>
        protected override void ProcessRecord()
        {
            Data.KeyVaultCertificate[] results = Call(Id, VaultName, Name, Thumbprint, Tags, Exact);

            // Unroll the object
            foreach (Data.KeyVaultCertificate result in results)
            {
                if (Export)
                {
                    result.Certificate = new X509Certificate2((byte[])result.Certificate, result.Thumbprint, X509KeyStorageFlags.Exportable);
                }
                else
                {
                    result.Certificate = new X509Certificate2((byte[])result.Certificate, result.Thumbprint);
                }

                WriteObject( result );
            }
        }

        /// <summary>
        /// End Processing
        /// </summary>
        protected override void EndProcessing()
        {

        }
        
        public static Data.KeyVaultCertificate[] Call(string Id, string VaultName, string Name, string Thumbprint, string[] Tags, bool Exact)
        {
            string filter;

            Hashtable filterTable = new Hashtable {
                { "Id",             Id },
                { "VaultName",      VaultName },
                { "Name",           Name },
                { "Thumbprint",     Thumbprint }
            };

            filter = SQLiteDB.Filter(filterTable, Exact);
            
            string filterTags = SQLiteDB.Filter("Tags", Tags, false);
            if (!String.IsNullOrEmpty(filterTags)) {
                filter = String.Format("{0} AND {1}", filter, filterTags);
            }

            Data.KeyVaultCertificate[] result = SQLiteDB.ConvertToType<Data.KeyVaultCertificate[]>(
                SQLiteDB.GetRow("PSAdminKeyVaultCertificate", filter)
            );

            return result;
        }
    }


}