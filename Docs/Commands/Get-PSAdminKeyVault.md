# Get-PSAdminKeyVault
Module: PSAdmin

Searches KeyVault for an Item with the specified Id/Name and returns results.

``` powershell
Get-PSAdminKeyVault
        [-Id <String>]
        [-VaultName <String>]
        [-Exact]
```

## Description
Searches KeyVault for an Item with the specified Id/Name and returns results.

## Examples
### Example 1:   
***



## Parameters

### \-Id

Unique Identifier for KeyVault
```
Type:                       String  
Position:                   named  
Default Value:              *  
Accept pipeline input:      true (ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-VaultName

Unique Name for KeyVault
```
Type:                       String  
Position:                   1  
Default Value:              *  
Accept pipeline input:      true (ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-Exact

Specify for Exact Search based on ID/Name
```
Type:                       SwitchParameter  
Position:                   named  
Default Value:              False  
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
