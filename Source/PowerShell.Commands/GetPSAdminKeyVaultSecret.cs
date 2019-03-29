using System;
using System.Collections;
using System.Collections.Generic;
using System.Management.Automation;
using PSAdmin.Internal;

namespace PSAdmin.PowerShell.Commands
{
	/// <summary>
	/// Get-PSAdminKeyVaultSecret2 Cmdlet.
	/// </summary>
	[Cmdlet(VerbsCommon.Get, "PSAdminKeyVaultSecret")]
	public sealed class GetPSAdminKeyVaultSecret : PSCmdlet
	{
	
		/// <summary>
		/// Sets value for VaultName
		/// </summary>
		[Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true)]
		public String VaultName { get; set; }
		
		/// <summary>
		/// Sets value for Name
		/// </summary>
		[Parameter(ValueFromPipeline = true, ValueFromPipelineByPropertyName = true)]
		public String Name { get; set; }
		
		/// <summary>
		/// Sets value for Id
		/// </summary>
		[Parameter(ValueFromPipelineByPropertyName = true)]
		public String Id { get; set; }
		
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
			// If KeyVault Exists


			// If Certificate Exists		
			

			// 

			Data.KeyVaultSecret[] results = Call(Id, VaultName, Name, Tags, Decrypt, Exact);

            // Unroll the object
            foreach (Data.KeyVaultSecret result in results)
                WriteObject( result );

			/// Code is not Generated Automatically you still need to program
			/*
				$Results = Get-PSAdminSQliteObject @DBQuery -Match:(!$Exact)

				foreach ($Result in $Results) {

					$Result = [PSAdminKeyVaultSecret]$Result

					$Result.SecretValue = ConvertFrom-PSAdminKeyVaultSecretValue -VaultName $Result.VaultName -InputData ([System.Text.Encoding]::UTF8.GetString($Result.SecretValue)) -Decrypt:$Decrypt

					$Result
				}

				

			*/
		}

		public static Data.KeyVaultSecret[] Call(string Id, string VaultName, string Name, string[] Tags, bool Decrypt, bool Exact)
        {
            string filter;

            Hashtable filterTable = new Hashtable {
                { "Id",         Id },
                { "VaultName",  VaultName },
                { "Name",		Name }
            };

            filter = SQLiteDB.Filter(filterTable, Exact);
            
            string filterTags = SQLiteDB.Filter("Tags", Tags, false);

            if (!String.IsNullOrEmpty(filterTags)) {
                filter = String.Format("{0} AND {1}", filter, filterTags);
            }

            Data.KeyVaultSecret[] result = SQLiteDB.ConvertToType<Data.KeyVaultSecret[]>(
                SQLiteDB.GetRow("PSAdminKeyVaultSecret", filter)
            );
			if (Decrypt) {
				foreach (Data.KeyVaultSecret i in result)
				{
					byte[] Key = GetPSAdminKeyVault.GetVaultKey(i.VaultName);
					if (i.ContentType == "txt")
					{
						i.SecretValue = Crypto.ConvertFromKeyVaultSecret( (byte[])i.SecretValue, Key);
					}
					else
					{
						i.SecretValue = Crypto.ConvertFromKeyVaultSecretAsBytes( (byte[])i.SecretValue, Key);
					}

//					Crypto.ConvertFromKeyVaultSecret()

				}
			}
            return result;
        }

		/// <summary>
		/// EndProcessing
		/// </summary>
		protected override void EndProcessing()
		{

		}
	}
}
