```

NAME
    Set-PSAdminKeyVaultSecret
    
SYNOPSIS
    Sets an property of an Existing Secret in the Vault
    
    
SYNTAX
    Set-PSAdminKeyVaultSecret [-VaultName] <String> [-Name] <String> [-Id] <String> [[-Version] <String>] [[-Enabled] 
    <String>] [[-Expires] <DateTime>] [[-NotBefore] <DateTime>] [[-ContentType] <String>] [[-Tags] <String[]>] 
    [[-SecretValue] <PSObject>] [<CommonParameters>]
    
    
DESCRIPTION
    Sets an property of an Existing Secret in the Vault
    

PARAMETERS
    -VaultName <String>
        Unique Name for KeyVault
        
    -Name <String>
        Unique Name for Secret
        
    -Id <String>
        Unique Id for Secret
        
    -Version <String>
        Version for Secret
        
    -Enabled <String>
        Specify if Secret is enabled
        
    -Expires <DateTime>
        Specify when Secret is expired
        
    -NotBefore <DateTime>
        Specify when Secret should take effect.
        
    -ContentType <String>
        Specify ContentType Text or Blob
        
    -Tags <String[]>
        Unique Tag Identifiers
        
    -SecretValue <PSObject>
        Secret Value to lock away in the KeyVault
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    Set-PSAdminKeyVaultSecret -VaultName "<VaultName>" -Name "<NameOfSecret>" -Enabled True -ContentType txt -SecretValue "My Secret Value"
```