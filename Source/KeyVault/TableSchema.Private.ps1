class PSAdminKeyVault
{
    [System.String]         $Id
    [System.String]         $VaultName
    [System.String]         $Location
    [System.String]         $VaultURI
    [System.String]         $SKU
    [System.String]         $SoftDeleteEnabled
    [System.String]         $Thumbprint
    [byte[]]                $VaultKey
    [System.String]         $ResourceGroup
    [System.String]         $ResourceID
    [System.String[]]       $Tags    
}

$Script:KeyVaultConfig = @{
    TableName           = "PSAdminKeyVault"
    TableKeys           = @("VaultName", "Id")
    TableSchema         = [PSAdminKeyVault]@{}
}