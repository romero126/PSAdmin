```

NAME
    Remove-PSAdminKeyVaultSecret
    
SYNOPSIS
    Removes Secret from from the KeyVaultSecret Store.
    
    
SYNTAX
    Remove-PSAdminKeyVaultSecret [-VaultName] <String> [-Name] <String> [[-Id] <String>] [-Match] [-WhatIf] [-Confirm] 
    [<CommonParameters>]
    
    
DESCRIPTION
    Removes Secret from from the KeyVaultSecret Store.
    

PARAMETERS
    -VaultName <String>
        Unique Name for KeyVault
        
    -Name <String>
        Unique Name for Secret
        
    -Id <String>
        Unique identifier for Secret
        
    -Match [<SwitchParameter>]
        Specify for Match Search based on ID/Name
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    Remove-PSAdminKeyVaultSecret -VaultName "<VaultName>" -Name "<SecretName>"
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    Remove-PSAdminKeyVaultSecret -VaultName "<VaultName>" -Name "<SecretName>*"
```