using System;
using System.Collections;
using System.Collections.Generic;
using System.Management.Automation;
using PSAdmin.Internal;



namespace PSAdmin.PowerShell.Commands
{
	/// <summary>
	/// New-PSAdminKeyVaultSecret2 Cmdlet.
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
		[ValidateSet()]
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
		[ValidateSet()]
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
		public Object SecretValue { get; set; }
		
		/// <summary>
		/// BeginProcessing
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
		/// ProcessRecord
		/// </summary>
		protected override void ProcessRecord()
		{
			Data.KeyVault KeyVault = KeyVaultHelper.GetItemThrow(null, VaultName, true);


			/*		
				$Result = Get-PSAdminKeyVaultSecret -Name $Name -VaultName $VaultName -Exact

				if ($Result)

				{

					Cleanup

					throw New-PSAdminException -ErrorID KeyVaultSecretExceptionExists -ArgumentList $VaultName, $Name

				}

		

				$Id = [Guid]::NewGuid().ToString().Replace('-', '')

				$Created = [DateTime]::UTCNow

				$Updated = [DateTime]::UTCNow

		

				$DBQuery = @{

					Database        = $Database

					Keys            = $Script:KeyVaultSecretConfig.TableKeys

					Table           = $Script:KeyVaultSecretConfig.TableName

					InputObject     = [PSCustomObject]@{

						VaultName   = $VaultName

						Name        = $Name

						Version     = $Version

						Id          = $Id

						Enabled     = $Enabled

						Expires     = $Expires

						NotBefore   = $NotBefore

						Created     = $Created

						Updated     = $Updated

						ContentType = $ContentType

						Tags        = $Tags

						SecretValue = ConvertTo-PSAdminKeyVaultSecretValue -VaultName $VaultName -InputData $SecretValue

					}

				}

				

				$Result = New-PSAdminSQliteObject @DBQuery

		

				if ($Result -eq -1)

				{

					Cleanup

					throw New-PSAdminException -ErrorID ExceptionUpdateDatabase

				}
			*/
		}

		/// <summary>
		/// EndProcessing
		/// </summary>
		protected override void EndProcessing()
		{

		}
	}
}
