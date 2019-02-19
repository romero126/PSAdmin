```
NAME
    Remove-PSAdminKeyVault

SYNOPSIS
    Removes KeyVault from Database


SYNTAX
    Remove-PSAdminKeyVault [[-Id] <String>] [-VaultName] <String> [-Match] [-WhatIf] [-Confirm] [<CommonParameters>]


DESCRIPTION
    Removes KeyVault from Database


PARAMETERS
    -Id <String>
        Unique Identifier for KeyVault

        Required?                    false
        Position?                    1
        Default value                *
        Accept pipeline input?       true (ByPropertyName)
        Accept wildcard characters?  false

    -VaultName <String>
        Unique Name for KeyVault

        Required?                    true
        Position?                    2
        Default value
        Accept pipeline input?       true (ByValue, ByPropertyName)
        Accept wildcard characters?  false

    -Match [<SwitchParameter>]
        Specify for Match Search based on ID/Name

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -WhatIf [<SwitchParameter>]

        Required?                    false
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Confirm [<SwitchParameter>]

        Required?                    false
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

INPUTS
    PSAdminKeyVault.PSAdmin.Module, or any specific object that contains Id, VaultName


OUTPUTS
    None. If Successful


    -------------------------- EXAMPLE 1 --------------------------

    PS C:\>#Example: Exact

    Remove-PSAdminKeyVault -VaultName "<VaultName>"




    -------------------------- EXAMPLE 2 --------------------------

    PS C:\>#Example: Matching

    Remove-PSAdminKeyVault -VaultName "Vault*" -Match
```