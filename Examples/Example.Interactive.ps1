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

$AvailableCommands | Out-Host