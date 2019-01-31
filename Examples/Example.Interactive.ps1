Import-Module "$PSScriptRoot\..\Source\PSAdmin.psm1"
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
$AvailableCommands = Get-Command -Module "PSAdmin" | Where-Object Name -notlike "*SQLite*" | Sort Noun

foreach($Command in $AvailableCommands) {
 
    Write-Host ("{0}.  " -f ($AvailableCommands.IndexOf($Command)+1) ) -ForegroundColor Green -NoNewLine
    Write-host $Command.Name -ForegroundColor Yellow
}