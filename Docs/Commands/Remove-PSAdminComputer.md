# Remove-PSAdminComputer
Module: PSAdmin

Removes PSAdminComputer and removes Specified Matching item.

``` powershell
Remove-PSAdminComputer
        [-Id <String>]
        -VaultName <String>
        -ComputerName <String>
        [-Match]
        [-WhatIf]
        [-Confirm]
```

## Description
Removes PSAdminComputer and removes Specified Matching item.

## Examples
### Example 1:   
***

``` powershell
Remove-PSAdminComputer -VaultName "<VaultName>" -Name "<HostName>" 
```

### Example 2:   
***

``` powershell
Remove-PSAdminComputer -VaultName "<VaultName>" -Name "<HostName>" -Match
```

## Parameters

### \-Id

Specify identifier
```
Type:                       String  
Position:                   1  
Default Value:              *  
Accept pipeline input:      true (ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-VaultName

Specify VaultName
```
Type:                       String  
Position:                   2  
Default Value:                
Accept pipeline input:      true (ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-ComputerName

Specify Machine Name
```
Type:                       String  
Position:                   3  
Default Value:                
Accept pipeline input:      true (ByValue, ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-Match

Specify Match Search Mode
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
