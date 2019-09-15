using System;
using System.Collections;
using System.Collections.Generic;
using System.Management.Automation;
using PSAdmin.Internal;
using System.Security;

namespace PSAdmin.PowerShell.Commands
{

    #region New

	/// <summary>
	/// New-PSAdminKeyVaultSecret Cmdlet.
	/// </summary>
	[Cmdlet(VerbsCommon.New, "PSAdminKeyVaultSecret")]
	public sealed class NewPSAdminKeyVaultSecret : PSCmdlet
	{
	
		/// <summary>
		/// Sets value for VaultName
		/// </summary>
		[Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true)]
		public String VaultName { get; set; }
		
		/// <summary>
		/// Sets value for Name
		/// </summary>
		[Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true)]
		public String Name { get; set; }
		
		/// <summary>
		/// Sets value for Version
		/// </summary>
		[Parameter(ValueFromPipelineByPropertyName = true)]
		public String Version { get; set; }
		
		/// <summary>
		/// Sets value for Enabled
		/// </summary>
		[Parameter(ValueFromPipelineByPropertyName = true)]
		[ValidateSet("true", "false")]
		public String Enabled { get; set; }
		
		/// <summary>
		/// Sets value for Expires
		/// </summary>
		[Parameter(ValueFromPipelineByPropertyName = true)]
		public Nullable<DateTime> Expires { get; set; }
		
		/// <summary>
		/// Sets value for NotBefore
		/// </summary>
		[Parameter(ValueFromPipelineByPropertyName = true)]
		public Nullable<DateTime> NotBefore { get; set; }
		
		/// <summary>
		/// Sets value for ContentType
		/// </summary>
		[Parameter(ValueFromPipelineByPropertyName = true)]
		[ValidateSet("txt", "blob")]
		public String ContentType { get; set; }
		
		/// <summary>
		/// Sets value for Tags
		/// </summary>
		[Parameter(ValueFromPipelineByPropertyName = true)]
		public String[] Tags { get; set; }
		
		/// <summary>
		/// Sets value for SecretValue
		/// </summary>
		[Parameter(ValueFromPipelineByPropertyName = true)]
		public string SecretValue { get; set; }
		
		/// <summary>
		/// BeginProcessing
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
		/// ProcessRecord
		/// </summary>
		protected override void ProcessRecord()
		{
			if (string.IsNullOrEmpty(ContentType) )
			{
				ContentType = "txt";
			}
			if (string.IsNullOrEmpty(Enabled))
			{
				Enabled = "true";
			}
			string Id = Guid.NewGuid().ToString().Replace("-", "");
			KeyVaultSecretHelper.NewItemThrow(Id, VaultName, Name, Version, Enabled, Expires, NotBefore, ContentType, Tags, SecretValue);
		}

		/// <summary>
		/// EndProcessing
		/// </summary>
		protected override void EndProcessing()
		{

		}
	}

    #endregion

    #region Get

	/// <summary>
	/// Get-PSAdminKeyVaultSecret Cmdlet.
	/// </summary>
	[Cmdlet(VerbsCommon.Get, "PSAdminKeyVaultSecret")]
	public sealed class GetPSAdminKeyVaultSecret : PSCmdlet
	{
	
		/// <summary>
		/// Sets value for Id
		/// </summary>
		[Parameter(ValueFromPipelineByPropertyName = true)]
		public String Id { get; set; }

		/// <summary>
		/// Sets value for VaultName
		/// </summary>
		[Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 0)]
		public String VaultName { get; set; }
		
		/// <summary>
		/// Sets value for Name
		/// </summary>
		[Parameter(ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 1)]
		public String Name { get; set; }
				
		/// <summary>
		/// Sets value for Tags
		/// </summary>
		[Parameter(ValueFromPipelineByPropertyName = true)]
		public String[] Tags { get; set; }
		
		/// <summary>
		/// Sets value for Decrypt
		/// </summary>
		[Parameter()]
		public SwitchParameter Decrypt { get; set; }
		
		/// <summary>
		/// Sets value for Exact
		/// </summary>
		[Parameter()]
		public SwitchParameter Exact { get; set; }
		
		/// <summary>
		/// BeginProcessing
		/// </summary>
		protected override void BeginProcessing()
		{

		}

		/// <summary>
		/// ProcessRecord
		/// </summary>
		protected override void ProcessRecord()
		{
			Data.KeyVaultSecret[] results = KeyVaultSecretHelper.GetItems(Id, VaultName, Name, Tags, Decrypt, Exact);

            // Unroll the object
            foreach (Data.KeyVaultSecret result in results)
                WriteObject( result );

		}

		/// <summary>
		/// EndProcessing
		/// </summary>
		protected override void EndProcessing()
		{

		}
	}

    #endregion

    #region Set

	/// <summary>
	/// Set-PSAdminKeyVaultSecret Cmdlet.
	/// </summary>
	[Cmdlet(VerbsCommon.Set, "PSAdminKeyVaultSecret")]
	public sealed class SetPSAdminKeyVaultSecret : PSCmdlet
	{
	
		/// <summary>
		/// Sets value for VaultName
		/// </summary>
		[Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true)]
		public System.String VaultName { get; set; }
		
		/// <summary>
		/// Sets value for Name
		/// </summary>
		[Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true)]
		public System.String Name { get; set; }
		
		/// <summary>
		/// Sets value for Id
		/// </summary>
		[Parameter(ValueFromPipelineByPropertyName = true)]
		public System.String Id { get; set; }
		
		/// <summary>
		/// Sets value for Version
		/// </summary>
		[Parameter()]
		public System.String Version { get; set; }
		
		/// <summary>
		/// Sets value for Enabled
		/// </summary>
		[Parameter()]
		[ValidateSet("true", "false")]
		public System.String Enabled { get; set; }
		
		/// <summary>
		/// Sets value for Expires
		/// </summary>
		[Parameter()]
		public Nullable<DateTime> Expires { get; set; }
		
		/// <summary>
		/// Sets value for NotBefore
		/// </summary>
		[Parameter()]
		public Nullable<DateTime> NotBefore { get; set; }
		
		/// <summary>
		/// Sets value for ContentType
		/// </summary>
		[Parameter()]
		[ValidateSet("txt", "blob")]
		public System.String ContentType { get; set; }
		
		/// <summary>
		/// Sets value for Tags
		/// </summary>
		[Parameter()]
		public String[] Tags { get; set; }
		
		/// <summary>
		/// Sets value for SecretValue
		/// </summary>
		[Parameter()]
		public String SecretValue { get; set; }
		
		/// <summary>
		/// Sets value for Exact
		/// </summary>
		[Parameter()]
		public SwitchParameter Exact { get; set; }

		/// <summary>
		/// BeginProcessing
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
		/// ProcessRecord
		/// </summary>
		protected override void ProcessRecord()
		{
			KeyVaultSecretHelper.SetItemsThrow(Id, VaultName, Name, Version, Enabled, Expires, NotBefore, ContentType, Tags, SecretValue, Exact);
		}

		/// <summary>
		/// EndProcessing
		/// </summary>
		protected override void EndProcessing()
		{

		}

	}

    #endregion

    #region Remove

	/// <summary>
	/// Remove-PSAdminKeyVaultSecret Cmdlet.
	/// </summary>
	[Cmdlet(VerbsCommon.Remove, "PSAdminKeyVaultSecret", SupportsShouldProcess = true, ConfirmImpact = ConfirmImpact.High)]
	public sealed class RemovePSAdminKeyVaultSecret : PSCmdlet
	{
		/// <summary>
		/// Sets value for Id
		/// </summary>
		[Parameter(ValueFromPipelineByPropertyName = true)]
		public String Id { get; set; }

		/// <summary>
		/// Sets value for VaultName
		/// </summary>
		[Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true)]
		public String VaultName { get; set; }
		
		/// <summary>
		/// Sets value for Name
		/// </summary>
		[Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true)]
		public String Name { get; set; }
		
		/// <summary>
		/// Sets value for Match
		/// </summary>
		[Parameter()]
		public SwitchParameter Match { get; set; }
		
		/// <summary>
		/// BeginProcessing
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
		/// ProcessRecord
		/// </summary>
		protected override void ProcessRecord()
		{
			KeyVaultSecretHelper.ThrowIfItemNotExists(Id, VaultName, Name, null, false, !Match);

			Data.KeyVaultSecret[] KeyVaultSecrets = KeyVaultSecretHelper.GetItems(Id, VaultName, Name, null, false, !Match);

			// Unroll the object
			foreach (Data.KeyVaultSecret Secret in KeyVaultSecrets) 
			{
                if (!ShouldProcess(Secret.Name, "Remove"))
                {
                    continue;
                }
				KeyVaultSecretHelper.RemoveItemThrow(Secret.Id, Secret.VaultName, Secret.Name, !Match);
			}
		}

		/// <summary>
		/// EndProcessing
		/// </summary>
		protected override void EndProcessing()
		{

		}

	}

    #endregion

}