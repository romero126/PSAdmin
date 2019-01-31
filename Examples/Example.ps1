Import-Module "$PSScriptRoot\..\Source\PSAdmin.psm1"
Open-PSAdmin -Path "$PSScriptRoot\PSAdmin.xml"



# Create a New DB Item for local Computer
#New-PSAdminMachine -Name 
$NewPSAdminMachine = @{
    Name                    = (Hostname)
    SerialNumber            = Get-WmiObject win32_bios | ForEach-Object SerialNumber
    OSVersion               = Get-WmiObject win32_OperatingSystem | ForEach-Object Version
    PublicIP                = Invoke-WebRequest -Uri "http://ifconfig.co/ip" | ForEach-Object Content | ForEach-Object Trim
    IP                      = Get-NetIPAddress | Where-Object PrefixOrigin -eq Dhcp | Select-Object -first 1 | ForEach-Object IPAddress
    MacAddress              = Get-NetAdapter | Where-Object Name -eq (Get-NetIPAddress | Where-Object PrefixOrigin -eq Dhcp | Select-Object -first 1 | ForEach-Object InterfaceAlias) | ForEach-Object MacAddress
    Domain                  = Get-WmiObject -Class Win32_ComputerSystem | ForEach-Object Domain
}
New-PSAdminMachine @NewPSAdminMachine
$Location = Read-Host -Prompt "Please Speficy a Location: "
if ($Location) {
    Get-PSAdminMachine -Name (Hostname) | Set-PSAdminMachine -Location $Location
}

#Uncomment to Remove the Hostname from the Database
Remove-PSAdminMachine -Name (HostName)
#Remove Database Remove-Item PSAdmin.DB