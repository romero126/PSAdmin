﻿# Get-PSAdminKeyVaultSecret
Module: PSAdmin

Searches KeyVaultSecret Store for an Item with the Specified VaultName/Name and returns the results.

``` powershell
Get-PSAdminKeyVaultSecret
        -VaultName <String>
        [-Name <String>]
        [-Id <String>]
        [-Tags <String[]>]
        [-Decrypt]
        [-Exact]
```

## Description
Searches KeyVaultSecret Store for an Item with the Specified VaultName/Name and returns the results.

## Examples
### Example 1:   
***

``` powershell
Get-PSAdminKeyVaultSecret -VaultName "<VaultName>" -Name "<SecretName>"
```

### Example 2:   
***

``` powershell
Get-PSAdminKeyVaultSecret -VaultName "<VaultName>" -Name "<SecretName>" -Decrypt
```

## Parameters

### \-VaultName

Unique Name for KeyVault
```
Type:                       String  
Position:                   1  
Default Value:                
Accept pipeline input:      true (ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-Name

Unique Name for Secret
```
Type:                       String  
Position:                   2  
Default Value:              *  
Accept pipeline input:      true (ByValue, ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-Id

Unique identifier for Secret
```
Type:                       String  
Position:                   3  
Default Value:              *  
Accept pipeline input:      true (ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-Tags

```
Type:                       String[]  
Position:                   4  
Default Value:                
Accept pipeline input:      true (ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-Decrypt

Automatically Decrypt Value
```
Type:                       SwitchParameter  
Position:                   named  
Default Value:              False  
Accept pipeline input:      false  
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
