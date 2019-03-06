# Set-PSAdminComputer
Module: PSAdmin

Sets a value for PSAdminComputer with Specified Matching Name.

``` powershell
Set-PSAdminComputer
        [-Id <String>]
        -VaultName <String>
        -ComputerName <String>
        [-Description <String>]
        [-LastOnline <Nullable`1>]
        [-AssetNumber <String>]
        [-SerialNumber <String>]
        [-DeviceSKU <String>]
        [-OSVersion <String>]
        [-Location <String>]
        [-Building <String>]
        [-Room <String>]
        [-Rack <String>]
        [-Slot <String>]
        [-VMHost <String>]
        [-BuildDefinition <String>]
        [-BuildState <String>]
        [-BuildDesiredVersion <String>]
        [-ActualVersion <String>]
        [-Domain <String>]
        [-Forest <String>]
        [-PublicFQDN <String>]
        [-LoadBalancer <String>]
        [-PublicIP <IPAddress>]
        [-LocalIP <IPAddress>]
        [-MACAddress <String>]
        [-Tags <String[]>]
        [-Notes <String>]
```

## Description
Sets a value for PSAdminComputer with Specified Matching Name.

## Examples
### Example 1:   
***

``` powershell
Set-PSAdminComputer -VaultName "<VaultName>" -Name "<HostName>" -<Parameter> "<Value>"
```

## Parameters

### \-Id

```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      true (ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-VaultName

Specify VaultName
```
Type:                       String  
Position:                   1  
Default Value:                
Accept pipeline input:      true (ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-ComputerName

```
Type:                       String  
Position:                   2  
Default Value:                
Accept pipeline input:      true (ByValue, ByPropertyName)  
Accept wildcard characters: Unknown  
```
### \-Description

Specify Description
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-LastOnline

Specify LastOnline
```
Type:                       Nullable`1  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-AssetNumber

Specify AssetNumber
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-SerialNumber

Specify SerialNumber
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-DeviceSKU

Specify DeviceSKU
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-OSVersion

Specify OSVersion
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-Location

Specify Location
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-Building

Specify Building
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-Room

Specify Room
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-Rack

Specify Rack
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-Slot

Specify Slot
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-VMHost

Specify VMHost
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-BuildDefinition

Specify BuildDefinition
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-BuildState

Specify BuildState
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-BuildDesiredVersion

Specify BuildDesiredVersion
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-ActualVersion

Specify ActualVersion
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-Domain

Specify Domain
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-Forest

Specify Forest
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-PublicFQDN

Specify PublicFQDN
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-LoadBalancer

Specify LoadBalancer
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-PublicIP

Specify PublicIP
```
Type:                       IPAddress  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-LocalIP

Specify LocalIP
```
Type:                       IPAddress  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-MACAddress

Specify MACAddress
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-Tags

Specify Tags
```
Type:                       String[]  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
### \-Notes

Specify Notes
```
Type:                       String  
Position:                   named  
Default Value:                
Accept pipeline input:      false  
Accept wildcard characters: Unknown  
```
