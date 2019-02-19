```
NAME
    Protect-PSAdminKeyVault

SYNOPSIS
    Protects the KeyVault with a Certificate from the KeyVaultCertificate store.


SYNTAX
    Protect-PSAdminKeyVault [-VaultName] <String> [-Thumbprint] <String> [<CommonParameters>]


DESCRIPTION
    Protects the KeyVault with a Certificate from the KeyVaultCertificate store.


PARAMETERS
    -VaultName <String>
        VaultName of Existing Vault

        Required?                    true
        Position?                    1
        Default value
        Accept pipeline input?       true (ByPropertyName)
        Accept wildcard characters?  false

    -Thumbprint <String>
        Thumbprint of the KeyVaultCertificate you wish to protect the KeyVault VaultKey

        Required?                    true
        Position?                    3
        Default value
        Accept pipeline input?       true (ByPropertyName)
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

INPUTS
    None. Protect-PSAdminKeyVault does not take Pipeline Input.


OUTPUTS
    None. If Successful


    -------------------------- EXAMPLE 1 --------------------------

    Protect-PSAdminKeyVault -VaultName "<VaultName>" -Thumbprint "<GuidOfThumbprint>"
```