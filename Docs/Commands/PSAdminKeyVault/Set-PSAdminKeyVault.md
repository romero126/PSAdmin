```
NAME
    Set-PSAdminKeyVault
    
SYNOPSIS
    Sets KeyVault with Specified Values
    
    
SYNTAX
    Set-PSAdminKeyVault [[-Id] <String>] [-VaultName] <String> [[-Location] <String>] [[-VaultURI] <String>] [[-SKU] 
    <String>] [[-SoftDeleteEnabled] <String>] [[-Tags] <String[]>] [<CommonParameters>]
    
    
DESCRIPTION
    Sets KeyVault with Specified Values
    

PARAMETERS
    -Id <String>
        
        Required?                    false
        Position?                    1
        Default value                
        Accept pipeline input?       true (ByPropertyName)
        Accept wildcard characters?  false
        
    -VaultName <String>
        A Unique Name (Note this is Wildcard Searchable)
        
        Required?                    true
        Position?                    2
        Default value                
        Accept pipeline input?       true (ByValue, ByPropertyName)
        Accept wildcard characters?  false
        
    -Location <String>
        Specify a Location
        
        Required?                    false
        Position?                    3
        Default value                
        Accept pipeline input?       true (ByPropertyName)
        Accept wildcard characters?  false
        
    -VaultURI <String>
        Specify a URI for Reference
        
        Required?                    false
        Position?                    4
        Default value                
        Accept pipeline input?       true (ByPropertyName)
        Accept wildcard characters?  false
        
    -SKU <String>
        
        Required?                    false
        Position?                    5
        Default value                
        Accept pipeline input?       true (ByPropertyName)
        Accept wildcard characters?  false
        
    -SoftDeleteEnabled <String>
        Specify Soft Delete Enabled (Note: This feature is not enabled)
        
        Required?                    false
        Position?                    6
        Default value                
        Accept pipeline input?       true (ByPropertyName)
        Accept wildcard characters?  false
        
    -Tags <String[]>
        Specify a Tag or Multiple Tags
        
        Required?                    false
        Position?                    7
        Default value                
        Accept pipeline input?       true (ByPropertyName)
        Accept wildcard characters?  false
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
INPUTS
    PSAdminKeyVault.PSAdmin.Module, or any specific object that contains Id, Name
    
    
OUTPUTS
    None.
    
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Set-PSAdminKeyVault -VaultName "MyVaultName" -Location "Office"

```