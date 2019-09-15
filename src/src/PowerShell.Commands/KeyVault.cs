using System;
using PSAdmin;
using PSAdmin.Internal;
using System.Management.Automation;
using System.Collections;
using System.Collections.Generic;

using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;

namespace PSAdmin.PowerShell.Commands {
    #region New
    /// <summary>
    /// Creates a PSAdmin KeyVault.
    /// </summary>
    [Cmdlet(VerbsCommon.New, "PSAdminKeyVault")]
    [OutputType(typeof(System.String))]
    public sealed class NewPSAdminKeyVault : PSCmdlet
    {
        /// <summary>
        /// Specify VaultName
        /// </summary>
        [Parameter(Mandatory = true, ValueFromPipeline = true, Position = 0)]
        public string VaultName { get; set; }

        /// <summary>
        /// Specify a Location
        /// </summary>
        [Parameter()]
        public string Location { get; set; }

        /// <summary>
        /// Specify a VaultURI
        /// </summary>
        [Parameter()]
        public string VaultURI { get; set; }

        /// <summary>
        /// Specify SoftDeleteEnabled
        /// </summary>
        [Parameter()]
        public SwitchParameter SoftDeleteEnabled { get; set; }

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
                    (new PSAdminException(PSAdminExceptionType.DatabaseNotOpen)).GetErrorRecord()
                );
            }
        }

        /// <summary>
        /// Process Record
        /// </summary>
        protected override void ProcessRecord()
        {
            String Id = Guid.NewGuid().ToString().Replace("-", "");
            KeyVaultHelper.NewItemThrow(Id, VaultName, Location, VaultURI, SoftDeleteEnabled, Tags);
            
            if (Passthru)
            {
                Data.KeyVault result = KeyVaultHelper.GetItem(null, VaultName, true);
                WriteObject( result );
            }
        }

        /// <summary>
        /// End Processing
        /// </summary>
        protected override void EndProcessing()
        {

        }

    }
    #endregion

    #region Get
    /// <summary>
    /// Returns a PSAdmin KeyVault from the database.
    /// </summary>
    [Cmdlet(VerbsCommon.Get, "PSAdminKeyVault")]
    [OutputType(typeof(System.String))]
    public sealed class GetPSAdminKeyVault : PSCmdlet
    {

        /// <summary>
        /// Specify Id
        /// </summary>
        [Parameter(ValueFromPipelineByPropertyName = true)]
        public string Id { get; set; }

        /// <summary>
        /// Specify VaultName
        /// </summary>
        [Parameter(ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 0)]
        public string VaultName { get; set; }

        /// <summary>
        /// Specify search for exact variables
        /// </summary>
        [Parameter()]
        public SwitchParameter Exact { get; set; }

        /// <summary>
        /// Begin output
        /// </summary>
        protected override void BeginProcessing()
        {
            if (String.IsNullOrEmpty(Config.SQLConnectionString)) {
                ThrowTerminatingError(
                    (new PSAdminException(PSAdminExceptionType.DatabaseNotOpen)).GetErrorRecord()
                );
            }

        }

        /// <summary>
        /// Process Record
        /// </summary>
        protected override void ProcessRecord()
        {
            Data.KeyVault[] results = KeyVaultHelper.GetItems(Id, VaultName, Exact);
            // Unroll the object
            foreach (Data.KeyVault result in results)
                WriteObject( result );
        }

        /// <summary>
        /// End Processing
        /// </summary>
        protected override void EndProcessing()
        {

        }
    }
    #endregion

    #region Set
    /// <summary>
    /// Updates a PSAdmin KeyVault.
    /// </summary>
    [Cmdlet(VerbsCommon.Set, "PSAdminKeyVault")]
    [OutputType(typeof(System.String))]
    public sealed class SetPSAdminKeyVault : PSCmdlet
    {
        /// <summary>
        /// Specify Id
        /// </summary>
        [Parameter(ValueFromPipelineByPropertyName = true)]
        public string Id {get; set; }

        /// <summary>
        /// Specify VaultName
        /// </summary>
        [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 0)]
        public string VaultName { get; set; }

        /// <summary>
        /// Specify a Location
        /// </summary>
        [Parameter()]
        public string Location { get; set; }

        /// <summary>
        /// Specify a VaultURI
        /// </summary>
        [Parameter()]
        public string VaultURI { get; set; }

        /// <summary>
        /// Specify SoftDeleteEnabled
        /// </summary>
        [Parameter()]
        public bool SoftDeleteEnabled { get; set; }

        /// <summary>
        /// Specify Tags
        /// </summary>
        [Parameter()]
        public String[] Tags { get; set; }

        /// <summary>
        /// Exact Match
        /// </summary>
        [Parameter()]
        public SwitchParameter Exact { get; set; }

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
                    ( new PSAdminException(PSAdminExceptionType.DatabaseNotOpen) ).GetErrorRecord()
                );
            }
        }

        /// <summary>
        /// Process Record
        /// </summary>
        protected override void ProcessRecord()
        {
            bool Successful = KeyVaultHelper.SetItemsThrow(Id, VaultName, Location, VaultURI, SoftDeleteEnabled, Tags, Exact);
            
            if (Passthru)
            {
                Data.KeyVault[] results = KeyVaultHelper.GetItems(null, VaultName, true);

                // Unroll the object
                foreach (Data.KeyVault result in results)
                    WriteObject( result );
            }
        }

        /// <summary>
        /// End Processing
        /// </summary>
        protected override void EndProcessing()
        {

        }
    }
    #endregion

    #region Remove
    /// <summary>
    /// Removes a PSAdmin KeyVault from the database.
    /// </summary>
    [Cmdlet(VerbsCommon.Remove, "PSAdminKeyVault", SupportsShouldProcess = true, ConfirmImpact = ConfirmImpact.High)]
    [OutputType(typeof(System.String))]
    public sealed class RemovePSAdminKeyVault : PSCmdlet
    {

        /// <summary>
        /// Specify Id
        /// </summary>
        [Parameter(ValueFromPipelineByPropertyName = true)]
        public string Id { get; set; }

        /// <summary>
        /// Specify VaultName
        /// </summary>
        [Parameter(ValueFromPipelineByPropertyName = true, Position = 0)]
        public string VaultName { get; set; }

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
                    (new PSAdminException(PSAdminExceptionType.DatabaseNotOpen) ).GetErrorRecord()
                );
            }

        }

        /// <summary>
        /// Process Record
        /// </summary>
        protected override void ProcessRecord()
        {
            
            Data.KeyVault[] vaults = KeyVaultHelper.GetItemsThrow(Id, VaultName, !Match);

            // This should always remove item as exact values.
            foreach (Data.KeyVault vault in vaults)
            {
                if (!ShouldProcess(vault.VaultName, "Remove"))
                {
                    continue;
                }
                KeyVaultHelper.RemoveItems(vault.Id, vault.VaultName, true);
            }
        }

        /// <summary>
        /// End Processing
        /// </summary>
        protected override void EndProcessing()
        {

        }
    }
    #endregion
}