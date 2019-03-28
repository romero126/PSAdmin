
#Enable PSRemoting
#Enable-PSRemoting
#Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
#Set-Item WSMan:localhost\client\trustedhosts -value *


#Enable Ping 
get-netfirewallrule -DisplayName 'File*Echo Request*' | Set-netfirewallrule -Enabled True

#Enable RDP
#cscript C:\Windows\System32\SCregEdit.wsf /ar 0