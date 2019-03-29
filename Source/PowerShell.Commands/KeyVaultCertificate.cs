using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Management.Automation;
using PSAdmin.Internal;
using System.Security;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;

namespace PSAdmin.PowerShell.Commands {

    /// <summary>
    /// Creates a PSAdmin KeyVault.
    /// </summary>
    [Cmdlet(VerbsData.Import, "PSAdminKeyVaultCertificate")]
    [OutputType(typeof(System.String))]
    public sealed class ImportPSAdminKeyVaultCertificate : PSCmdlet
    {

        private const string ImportFromStringParameterSetName = "ImportFromStringParameterSetName";
        private const string ImportFromFileParameterSetName = "ImportFromFileParameterSetName";

        /// <summary>
        /// Specify VaultName
        /// </summary>
        [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 0)]
        public string VaultName { get; set; }

        /// <summary>
        /// Specify Name
        /// </summary>
        [Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 1)]
        public string Name { get; set; }


        /// <summary>
        /// ImportFromFile
        /// </summary>
        [Parameter(Mandatory = true, ParameterSetName = ImportFromFileParameterSetName, ValueFromPipelineByPropertyName = true)]
        [Alias("FilePath")]
        public string FileName { get; set; }

        /// <summary>
        /// ImportFromString
        /// </summary>
        [Parameter(Mandatory = true, ParameterSetName = ImportFromStringParameterSetName, ValueFromPipelineByPropertyName = true)]
        public string CertificateString { get; set; }

        /// <summary>
        /// Specify a password
        /// </summary>
        [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true)]
        public SecureString Password { get; set; }

        /// <summary>
        /// Specify Version
        /// </summary>
        [Parameter()]
        public String Version { get; set; }

        /// <summary>
        /// Specify RecoveryLevel
        /// </summary>
        [Parameter()]
        [ValidateSet("Default")]
        public String RecoveryLevel { get; set; }

        /// <summary>
        /// Specify ScheduledPurgeDate
        /// </summary>
        [Parameter()]
        public Nullable<DateTime> ScheduledPurgeDate { get; set; }

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

            Data.KeyVault searchvaults = KeyVaultHelper.GetItemThrow(null, VaultName, true);

            
            Data.KeyVaultCertificate[] SearchCertificate = GetPSAdminKeyVaultCertificate.Call(null, VaultName, Name, null, null, false, true);
            if (SearchCertificate.Length > 0)
            {
                WriteError(
                    (new KevinBlumenfeldException(KevinBlumenfeldExceptionType.ItemExists , Name, "Name") ).GetErrorRecord()
                );
                return;
            }

            byte[] CertificateByteArray;
            switch (ParameterSetName)
            {
                case ImportFromFileParameterSetName:
                    CertificateByteArray = File.ReadAllBytes(FileName);
                    break;
                case ImportFromStringParameterSetName:
                    CertificateByteArray = Convert.FromBase64String( CertificateString );
                    break;
                default:
                    WriteError(
                        (new KevinBlumenfeldException(KevinBlumenfeldExceptionType.ParameterSetNotFound, Name, "Name") ).GetErrorRecord()
                    );
                    return;
            }

            X509Certificate2 x509 = new X509Certificate2(CertificateByteArray, Password, X509KeyStorageFlags.Exportable);
            /*
            // Certificate should NOT throw if Private Key is not available.
            if (x509.HasPrivateKey)
            {
                x509.Dispose();
                WriteError(
                    KevinBlumenfeldException.Create(KevinExceptions.CertificateRequiresPrivateKey)
                );
            }
            */

            byte[] rawcert = x509.Export( X509ContentType.Pkcs12, x509.Thumbprint );

            Hashtable item = new Hashtable {
                { "Id",                     Guid.NewGuid().ToString().Replace("-", "")      },
                { "VaultName",              VaultName                                       },
                { "Name",                   Name                                            },
                { "Version",                Version                                         },
                { "Enabled",                true                                            },
                { "DeletedDate",            null                                            },
                { "RecoveryLevel",          RecoveryLevel                                   },
                { "Created",                DateTime.UtcNow                                 },
                { "Updated",                DateTime.UtcNow                                 },
                { "NotBefore",              x509.NotBefore                                  },
                { "Expires",                x509.NotAfter                                   },
                { "ScheduledPurgeDate",     ScheduledPurgeDate                              },
                { "SecretId",               x509.SerialNumber                               },
                { "KeyId",                  x509.SerialNumber                               },
                { "Certificate",            rawcert                                         },
                { "Thumbprint",             x509.Thumbprint                                 },
                { "Tags",                   (Tags != null) ? String.Join(";", Tags) : null  }
            };
            x509.Dispose();
            
            bool issuccessful = Call(item);
            
            if (!issuccessful)
            {
                WriteError(
                    (new KevinBlumenfeldException(KevinBlumenfeldExceptionType.RowCreate) ).GetErrorRecord()
                );
            }
            if (Passthru)
            {
                Data.KeyVaultCertificate[] results = GetPSAdminKeyVaultCertificate.Call(null, VaultName, Name, null, null, false, true);

                // Unroll the object
                foreach (Data.KeyVaultCertificate result in results)
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
            return SQLiteDB.CreateRow("PSAdminKeyVaultCertificate", Properties);
        }
    }

    /// <summary>
    /// Exports a PSAdmin KeyVault Certificate.
    /// </summary>
    [Cmdlet(VerbsData.Export, "PSAdminKeyVaultCertificate")]
    [OutputType(typeof(System.String))]
    public sealed class ExportPSAdminKeyVaultCertificate : PSCmdlet
    {

        private const string ImportFromStringParameterSetName = "ImportFromStringParameterSetName";
        private const string ImportFromFileParameterSetName = "ImportFromFileParameterSetName";

        /// <summary>
        /// Specify VaultName
        /// </summary>
        [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 0)]
        public string VaultName { get; set; }

        /// <summary>
        /// Specify Name
        /// </summary>
        [Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 1)]
        public string Name { get; set; }


        /// <summary>
        /// ImportFromFile
        /// </summary>
        [Parameter(Mandatory = true, ParameterSetName = ImportFromFileParameterSetName, ValueFromPipelineByPropertyName = true)]
        public string FileName { get; set; }

        /// <summary>
        /// ImportFromString
        /// </summary>
        [Parameter(Mandatory = true, ParameterSetName = ImportFromStringParameterSetName )]
        public SwitchParameter AsString { get; set; }

        /// <summary>
        /// Specify a password
        /// </summary>
        [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true)]
        public SecureString Password { get; set; }

        /// <summary>
        /// Specify Version
        /// </summary>
        [Parameter()]
        public String Version { get; set; }

        /// <summary>
        /// Specify RecoveryLevel
        /// </summary>
        [Parameter()]
        [ValidateSet("Default")]
        public String RecoveryLevel { get; set; }

        /// <summary>
        /// Specify ScheduledPurgeDate
        /// </summary>
        [Parameter()]
        public Nullable<DateTime> ScheduledPurgeDate { get; set; }

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

            Data.KeyVault KeyVault = KeyVaultHelper.GetItemThrow(null, VaultName, true);

            
            Data.KeyVaultCertificate[] SearchCertificate = GetPSAdminKeyVaultCertificate.Call(null, VaultName, Name, null, null, false, true);
            if (SearchCertificate.Length == 0)
            {
                WriteError(
                    (new KevinBlumenfeldException(KevinBlumenfeldExceptionType.ItemNotFoundLookup, Name, "Name") ).GetErrorRecord()
                );
                return;
            }


            // Note: This will only ever return one item
            foreach (Data.KeyVaultCertificate Certificate in SearchCertificate)
            {
                X509Certificate2 x509 = (X509Certificate2)Certificate.Certificate;
                byte[] CertificateByteArray = x509.Export( X509ContentType.Pkcs12, Password );
                x509.Dispose();
                switch (ParameterSetName)
                {
                    case ImportFromFileParameterSetName:
                        File.WriteAllBytes(FileName, CertificateByteArray);
                        break;
                    case ImportFromStringParameterSetName:
                        WriteObject(
                            Convert.ToBase64String(CertificateByteArray)
                        );
                        break;
                    default:
                        WriteError(
                            (new KevinBlumenfeldException(KevinBlumenfeldExceptionType.ParameterSetNotFound, Name, "Name") ).GetErrorRecord()
                        );
                        return;
                }
            }
        }

        /// <summary>
        /// End Processing
        /// </summary>
        protected override void EndProcessing()
        {

        }
        public static bool Call()
        {
            return true;
        }
    }
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
                        (new KevinBlumenfeldException(KevinBlumenfeldExceptionType.DatabaseNotOpen) ).GetErrorRecord()
                    );
            }

        }

        /// <summary>
        /// Process Record
        /// </summary>
        protected override void ProcessRecord()
        {
            Data.KeyVaultCertificate[] results = Call(Id, VaultName, Name, Thumbprint, Tags, Export, Exact);

            // Unroll the object
            foreach (Data.KeyVaultCertificate result in results)
            {
                WriteObject( result );
            }
        }

        /// <summary>
        /// End Processing
        /// </summary>
        protected override void EndProcessing()
        {

        }
        
        public static Data.KeyVaultCertificate[] Call(string Id, string VaultName, string Name, string Thumbprint, string[] Tags, bool Export, bool Exact)
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

            Data.KeyVaultCertificate[] results = SQLiteDB.ConvertToType<Data.KeyVaultCertificate[]>(
                SQLiteDB.GetRow("PSAdminKeyVaultCertificate", filter)
            );

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
            }
            return results;
        }
    }

    /// <summary>
    /// Returns a PSAdmin Computer from the database.
    /// </summary>
    [Cmdlet(VerbsCommon.Remove, "PSAdminKeyVaultCertificate", SupportsShouldProcess = true, ConfirmImpact = ConfirmImpact.High)]
    [OutputType(typeof(System.String))]
    public sealed class RemovePSAdminKeyVaultCertificate : PSCmdlet
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
        /// Specify search for exact variables
        /// </summary>
        [Parameter()]
        public SwitchParameter Match { get; set; }

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

            Data.KeyVault[] vaults = KeyVaultHelper.GetItemsThrow(null, VaultName, !Match);


            Data.KeyVaultCertificate[] certificates = GetPSAdminKeyVaultCertificate.Call(Id, VaultName, Name, Thumbprint, null, false, !Match);
            if ((Match == false) && (certificates.Length < 1)) {
                WriteError(
                    (new KevinBlumenfeldException(KevinBlumenfeldExceptionType.ItemNotFoundLookup, Name, "Name") ).GetErrorRecord()
                );
                return;
            }

            // Unroll the object
            foreach (Data.KeyVaultCertificate certificate in certificates)
            {
                if (!ShouldProcess(certificate.Name, "Remove"))
                {
                    continue;
                }

                bool IsSuccessful = Call(certificate.Id, certificate.VaultName, certificate.Name, !Match);
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
        
        public static bool Call(string Id, string VaultName, string Name, bool Exact)
        {
            string filter;

            Hashtable filterTable = new Hashtable {
                {"Id",                  Id },
                {"VaultName",           VaultName },
                {"Name",                Name }
            };

            filter = SQLiteDB.Filter(filterTable, Exact);

            return SQLiteDB.RemoveRow("PSAdminKeyVaultCertificate", filter);
        }
    }
}