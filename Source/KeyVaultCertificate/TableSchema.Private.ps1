class PSAdminKeyVaultCertificate
{
    [String] $Id;
    [String] $VaultName;
    [String] $Name;

    [String] $Version;

    [String] $Enabled;
    [String] $DeletedDate;

    [String] $RecoveryLevel;
    
    [Nullable[DateTime]] $Created;
    [Nullable[DateTime]] $Updated;

    [Nullable[DateTime]] $NotBefore;
    [Nullable[DateTime]] $Expires;

    [Nullable[DateTime]] $ScheduledPurgeDate;

    [String] $SecretId;
    [String] $KeyId;

    [PSObject] $Certificate;
    [String] $Thumbprint;
    
    [String] $Tags;
}

$Script:Config["PSAdminKeyVaultCertificate"] = @{
    TableName           = "PSAdminKeyVaultCertificate"
    TableKeys           = ("VaultName", "Name", "Id", "Thumbprint")
    TableSchema         = [PSAdminKeyVaultCertificate]@{}
}
$Script:KeyVaultCertificateConfig = $Script:Config["PSAdminKeyVaultCertificate"]