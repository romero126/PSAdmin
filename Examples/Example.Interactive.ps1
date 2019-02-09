#Import-Module "$PSScriptRoot/../Source/PSAdmin.psm1"

. .\Build.ps1 -Action Build
Import-Module "$PSScriptRoot/../Module/PSAdmin/PSAdmin.psm1" -Force
Get-Module *PSAdmin*

Write-Host ""
Write-Host "Loading Database" -ForegroundColor Yellow

Open-PSAdmin -Path "$PSScriptRoot\PSAdmin.xml"

Write-Host ""
Write-Host ""
Write-Host "Welcome to PSAdmin Interactive Mode" -Foregroundcolor Green
Write-Host ""
Write-Host "Available Commands" -Foregroundcolor Yellow
Write-Host ""

$AvailableCommands = Get-Command -Module "PSAdmin" | Sort-Object Noun | Group-Object Noun | Select @{n="Cmdlet#";e={ $_.Count } }, @{n='Noun';e={ $_.Name }}

$AdailableCommands | ft -a

New-PSAdminKeyVaultSecret -VaultName "Default" -Name "Test" -SecretValue "Waffles"

<#
$Pass = "MyPassword" | ConvertTo-SecureString -AsPlainText -Force
Remove-PSAdminKeyVault -VaultName "Default"

New-PSAdminKeyVault -VaultName "Default"
Import-PSAdminKeyVaultCertificate -VaultName "Default" -Name "Default" -FilePath .\cert2.pfx -Password $Pass

$Data = @{
	Thumbprint		= Get-PSAdminKeyVaultCertificate -VaultName "Default" -Name "Default" | ForEach-Object Thumbprint
	VaultKeyOrigional	= Get-PSAdminKeyVault -VaultName "Default" | ForEach-Object VaultKey
	VaultKeyEncrypted	= "N/A"
	
}
Write-Warning "Protecting Vault"
Get-PSAdminKeyVault -VaultName "Default" | Protect-PSAdminKeyVault -Thumbprint $Data.Thumbprint
$Data.VaultKeyEncrypted = Get-PSAdminKeyVault -VaultName "Default" | ForEach-Object VaultKey

write-host $Data.Thumbprint
try {
    Write-Warning "Unprotecting Vault"
    Get-PSAdminKeyVault -VaultName "Default" | UnProtect-PSAdminKeyVault -Thumbprint $Data.Thumbprint
}
catch {
    Write-Error $_
}
$Data
#>
return

$Data
#Get-PSAdminKeyVault -VaultName "Default"
return
foreach($Command in $AvailableCommands)
{
    Write-Host ("{0}.  " -f ($AvailableCommands.IndexOf($Command)+1) ) -ForegroundColor Green -NoNewLine
    Write-host $Command.Name -ForegroundColor Yellow
}