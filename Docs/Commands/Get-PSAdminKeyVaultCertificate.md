﻿# Get-PSAdminKeyVaultCertificate
Module: PSAdmin

Searches KeyVaultCertificate store for a specific Id/Name/Thumbprint and returns its results.

``` powershell
Get-PSAdminKeyVaultCertificate
        [-Id <String>]
        [-VaultName <String>]
        [-Name <String>]
        [-Thumbprint <String>]
        [-Tags <String[]>]
        [-Exact]
        [-Export]
```

## Description
Searches KeyVaultCertificate store for a specific Id/Name/Thumbprint and returns its results.

## Examples
### Example 1:   
***



## Parameters

### \-Id

Unique Identifier for Certificate
```
Type:                       String  
Position:                   named  
Default Value:              *  
Accept pipeline input:      true (ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-VaultName

Unique Name for the KeyVault
```
Type:                       String  
Position:                   1  
Default Value:              *  
Accept pipeline input:      true (ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-Name

Unique Name for the Certificate
```
Type:                       String  
Position:                   2  
Default Value:              *  
Accept pipeline input:      true (ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-Thumbprint

Unique Unique for the KeyVault
```
Type:                       String  
Position:                   named  
Default Value:              *  
Accept pipeline input:      true (ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-Tags

```
Type:                       String[]  
Position:                   named  
Default Value:                
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
### \-Export

```
Type:                       SwitchParameter  
Position:                   named  
Default Value:              False  
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
