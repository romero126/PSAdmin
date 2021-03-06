﻿# Remove-PSAdminKeyVaultSecret
Module: PSAdmin

Removes Secret from from the KeyVaultSecret Store.

``` powershell
Remove-PSAdminKeyVaultSecret
        -VaultName <String>
        -Name <String>
        [-Id <String>]
        [-Match]
        [-WhatIf]
        [-Confirm]
```

## Description
Removes Secret from from the KeyVaultSecret Store.

## Examples
### Example 1:   
***

``` powershell
Remove-PSAdminKeyVaultSecret -VaultName "<VaultName>" -Name "<SecretName>"
```

### Example 2:   
***

``` powershell
Remove-PSAdminKeyVaultSecret -VaultName "<VaultName>" -Name "<SecretName>*"
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
Default Value:                
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
### \-Match

Specify for Match Search based on ID/Name
```
Type:                       SwitchParameter  
Position:                   named  
Default Value:              False  
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-WhatIf

```
Type:                       SwitchParameter  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-Confirm

```
Type:                       SwitchParameter  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
