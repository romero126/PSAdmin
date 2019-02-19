```

NAME
    Unprotect-PSAdminKeyVault
    
SYNOPSIS
    Unprotects the KeyVault VaultKey
    
    
SYNTAX
    Unprotect-PSAdminKeyVault [-VaultName] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Unprotects the KeyVault VaultKey
    

PARAMETERS
    -VaultName <String>
        VaultName of Protected KeyVault
        
        Required?                    true
        Position?                    1
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
INPUTS
    None. Unprotect-PSAdminKeyVault does not take Pipeline Input.
    
    
OUTPUTS
    None. If Successful
    
    
    -------------------------- EXAMPLE 1 --------------------------
    
    Unprotect-PSAdminKeyVault -VaultName "<VaultName>"
```