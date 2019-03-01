function Unprotect-PSAdminKeyVault
{
    <#
        .SYNOPSIS
            Unprotects the KeyVault VaultKey

        .DESCRIPTION
            Unprotects the KeyVault VaultKey

        .PARAMETER VaultName
            VaultName of Protected KeyVault
        
        .EXAMPLE

            ``` powershell
            Unprotect-PSAdminKeyVault -VaultName "<VaultName>"
            ```
        .INPUTS
            None. Unprotect-PSAdminKeyVault does not take Pipeline Input.

        .OUTPUTS
            None. If Successful

        .NOTES

        .LINK

    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [System.String]$VaultName
    )

    begin
    {

    }

    process
    {
        #Try Load
        $KeyVault = Get-PSAdminKeyVault -VaultName $VaultName -Exact

        #Check Returned KeyVault Count
        if (@($KeyVault).Count -ne 1)
        {
            throw New-PSAdminException -ErrorID KeyVaultExceptionResultCount -ArgumentList "VaultName", $VaultName, 1, @($KeyVault).Count
        }

        #Check if Thumbprint is already installed
        if (!$KeyVault.Thumbprint)
        {
            throw New-PSAdminException -ErrorID KeyVaultExceptionCertificateNotInstalled
        }


        $Certificate = Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Thumbprint $KeyVault.Thumbprint -Exact

        #Check Returned Certificate Count
        if (@($Certificate).Count -ne 1)
        {
            throw New-PSAdminException -ErrorID KeyVaultExceptionResultCount -ArgumentList "CertificateThumbprint", $KeyVault.Thumbprint, 1, @($KeyVault).Count
        }

        #Load Certificate
        $x509 = $Certificate.Certificate

        if ((!$x509.HasPrivateKey) -or (!$x509.PrivateKey)) {
            throw New-PSAdminException -ErrorID KeyVaultCertificateExceptionPrivateKey
        }

        try {
            
            $Database = Connect-PSAdminSQLite @Script:PSAdminDBConfig
            $DBQuery = @{
                Database        = $Database
                Keys            = ("VaultName", "Id")
                Table           = "PSAdminKeyVault"
                InputObject = [PSCustomObject]@{
                    VaultName               = $VaultName
                    Id                      = $KeyVault.Id
                    Thumbprint              = ""
                    VaultKey                = $x509.PrivateKey.Decrypt($KeyVault.VaultKey, $True)
                }
            }
            $Result = Set-PSAdminSQliteObject @DBQuery
            if ($Result -eq -1)
            {
                Cleanup
                throw New-PSAdminException -ErrorID ExceptionUpdateDatabase
            }

        }
        catch {
            Throw $_
        }
        finally {
            Disconnect-PSAdminSQLite -Database $Database
        }
    }

    end
    {

    }
}
