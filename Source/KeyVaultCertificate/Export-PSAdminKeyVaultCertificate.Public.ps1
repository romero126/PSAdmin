function Export-PSAdminKeyVaultCertificate
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = "ExportToString")]
        [Parameter(Mandatory, ParameterSetName = "ExportToFile")]
        [System.String]$VaultName,

        [Parameter(Mandatory, ParameterSetName = "ExportToString")]
        [Parameter(Mandatory, ParameterSetName = "ExportToFile")]
        [System.String]$Name,

        [Parameter(Mandatory, ParameterSetName = "ExportToFile")]
        [System.String]$FilePath,
        
        [Parameter(Mandatory, ParameterSetName = "ExportToString")]
        [Switch]$AsString,

        [Parameter(Mandatory, ParameterSetName = "ExportToString")]
        [Parameter(Mandatory, ParameterSetName = "ExportToFile")]
        [SecureString]$Password
        
    )

    begin
    {

    }

    process
    {
        $Certificate = Get-PSAdminKeyVaultCertificate -VaultName $VaultName -Name $Name -Exact -Export

        if (!$Certificate)
        {
            throw New-PSAdminException -ErrorID KeyVaultExceptionCertificateNotInstalled -ArgumentList $VaultName
        }

        $x509 = $Certificate.Certificate
        $CertificateByteArray = $x509.Export( [System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, $Password )

        switch ($PSCmdlet.ParameterSetName)
        {
            "ExportToFile" {
                $CertificateByteArray | Set-Content -Path $FilePath -Encoding Byte
            }
            "ExportToString" {
                [System.Convert]::ToBase64String($CertificateByteArray)
            }
        }

    }

    end
    {

    }

}
