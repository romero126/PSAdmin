function New-PSAdminKeyVault
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.String]$VaultName,
        
        [Parameter()]
        [System.String]$Location            = "",

        [Parameter()]
        [System.String]$VaultURI            = "",
        
        [Parameter()]
        [System.String]$SoftDeleteEnabled   = "True",

        [Parameter()]
        [System.String[]]$Tags              = ("")
    )

    begin
    {
        function Cleanup {
            Disconnect-PSAdminSQLite -Database $Database
        }
        $Database = Connect-PSAdminSQLite @Script:PSAdminDBConfig        
    }

    process
    {

        $VaultKey = new-object byte[](32)
        $null = [System.Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($VaultKey)

        $DBQuery = @{
            Database        = $Database
            Keys            = ("VaultName")
            Table           = "PSAdminKeyVault"
            InputObject     = [PSCustomObject]@{
                Id                              = [Guid]::NewGuid().ToString().Replace('-', '')
                VaultName                       = $VaultName
                Location                        = $Location
                VaultURI                        = $VaultURI
                SKU                             = ""
                SoftDeleteEnabled               = $SoftDeleteEnabled
                Tags                            = ($Tags -join ";")
                Thumbprint                      = ""
                VaultKey                        = $VaultKey
                ResourceGroup                   = ""
                ResourceID                      = ""
            }
        }

        $Result = Get-PSAdminKeyVault -VaultName $VaultName

        if ($Result)
        {
            Cleanup
            throw New-PSAdminException -ErrorID KeyVaultExceptionVaultNameExists -ArgumentList $VaultName
            
        }

        $Result = New-PSAdminSQliteObject @DBQuery

        if ($Result -eq -1)
        {
            Cleanup
            throw New-PSAdminException -ErrorID ExceptionUpdateDatabase
        }

    }

    end
    {
        Cleanup
    }
}

