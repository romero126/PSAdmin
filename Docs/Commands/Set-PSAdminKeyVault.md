# Set-PSAdminKeyVault
Module: PSAdmin

Sets KeyVault with Specified Values

``` powershell
Set-PSAdminKeyVault
        [-Id <String>]
        -VaultName <String>
        [-Location <String>]
        [-VaultURI <String>]
        [-SKU <String>]
        [-SoftDeleteEnabled <String>]
        [-Tags <String[]>]
```

## Description
Sets KeyVault with Specified Values

## Examples
### Example 1:   
***

``` powershell
Set-PSAdminKeyVault -VaultName "MyVaultName" -Location "Office"
```

## Parameters

### \-Id

```
Type:                       String  
Position:                   1  
Default Value:                
Accept pipeline input:      true (ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-VaultName

A Unique Name (Note this is Wildcard Searchable)
```
Type:                       String  
Position:                   2  
Default Value:                
Accept pipeline input:      true (ByValue, ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-Location

Specify a Location
```
Type:                       String  
Position:                   3  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-VaultURI

Specify a URI for Reference
```
Type:                       String  
Position:                   4  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-SKU

```
Type:                       String  
Position:                   5  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-SoftDeleteEnabled

Specify Soft Delete Enabled (Note: This feature is not enabled)
```
Type:                       String  
Position:                   6  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-Tags

Specify a Tag or Multiple Tags
```
Type:                       String[]  
Position:                   7  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
