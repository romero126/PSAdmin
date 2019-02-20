```

NAME
    Get-PSAdminKeyVaultSecret
    
SYNOPSIS
    Searches KeyVaultSecret Store for an Item with the Specified VaultName/Name and returns the results.
    
    
SYNTAX
    Get-PSAdminKeyVaultSecret [-VaultName] <String> [[-Name] <String>] [[-Id] <String>] [-Decrypt] [-Exact] 
    [<CommonParameters>]
    
    
DESCRIPTION
    Searches KeyVaultSecret Store for an Item with the Specified VaultName/Name and returns the results.
    

PARAMETERS
    -VaultName <String>
        Unique Name for KeyVault
        
    -Name <String>
        Unique Name for Secret
        
    -Id <String>
        Unique identifier for Secret
        
    -Decrypt [<SwitchParameter>]
        Automatically Decrypt Value
        
    -Exact [<SwitchParameter>]
        Specify for Exact Search based on ID/Name
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    Get-PSAdminKeyVaultSecret -VaultName "<VaultName>" -Name "<SecretName>"
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    Get-PSAdminKeyVaultSecret -VaultName "<VaultName>" -Name "<SecretName>" -Decrypt
```