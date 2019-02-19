```
NAME
    New-PSAdminKeyVault

SYNOPSIS
    Creates a new KeyVault with the specified Unique Name


SYNTAX
    New-PSAdminKeyVault [-VaultName] <String> [[-Location] <String>] [[-VaultURI] <String>] [[-SoftDeleteEnabled]
    <String>] [[-Tags] <String[]>] [<CommonParameters>]


DESCRIPTION
    Creates a new KeyVault with the specified Unique Name


PARAMETERS
    -VaultName <String>
        A Unique Name

        Required?                    true
        Position?                    1
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Location <String>
        Specify a Location

        Required?                    false
        Position?                    2
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -VaultURI <String>
        Specify a URI for Reference

        Required?                    false
        Position?                    3
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -SoftDeleteEnabled <String>
        Specify Soft Delete Enabled (Note: This feature is not enabled)

        Required?                    false
        Position?                    4
        Default value                True
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Tags <String[]>
        Specify a Tag or Multiple Tags

        Required?                    false
        Position?                    5
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

INPUTS
    None. New-PSAdminKeyVault does not take Pipeline Input.


OUTPUTS
    None. If Successful


    -------------------------- EXAMPLE 1 --------------------------

    PS C:\>New-PSAdminKeyVault -VaultName "MyVaultName" -Location "Office"
```