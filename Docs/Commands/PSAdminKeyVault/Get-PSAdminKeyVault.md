```
NAME
    Get-PSAdminKeyVault

SYNOPSIS
    Searches KeyVault for an Item with the specified Id/Name and returns results.


SYNTAX
    Get-PSAdminKeyVault [-Id <String>] [[-VaultName] <String>] [-Exact] [<CommonParameters>]


DESCRIPTION
    Searches KeyVault for an Item with the specified Id/Name and returns results.


PARAMETERS
    -Id <String>
        Unique Identifier for KeyVault

        Required?                    false
        Position?                    named
        Default value                *
        Accept pipeline input?       true (ByPropertyName)
        Accept wildcard characters?  false

    -VaultName <String>
        Unique Name for KeyVault

        Required?                    false
        Position?                    1
        Default value                *
        Accept pipeline input?       true (ByPropertyName)
        Accept wildcard characters?  false

    -Exact [<SwitchParameter>]
        Specify for Exact Search based on ID/Name

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

INPUTS
    PSAdminKeyVault.PSAdmin.Module, or any specific object that contains Id, Name


OUTPUTS
    PSAdminKeyVault.PSAdmin.Module.


    -------------------------- EXAMPLE 1 --------------------------

    Get-PSAdminKeyVault -VaultName "<VaultName>"
```