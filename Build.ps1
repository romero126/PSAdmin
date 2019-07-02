$ActionType = Split-Path -Path $MyInvocation.MyCommand.Path -Leaf
Split-Path -Path $MyInvocation.MyCommand.Path -Leaf

#$Config = Get-Content $PSScriptRoot/config.json | ConvertFrom-Json

#$DrawLine = ("-" * 50)


function Private:WriteAction
{
    param(
        [String]$Action,
        [String]$Message,
        [bool]$DrawLine = $false
    )

    if ($DrawLine)
    {
        $Line = ("-" * 50)
    }
    Write-Host "`nExecuting Action: ${Action}\${Message}`n${Line}`n" -ForegroundColor Green
    

}

#WriteAction("Build", "Cleanup-Files")
#WriteAction "Build" "Cleanup-Files" $true


#
#Action: Build\Cleanup-Files
#--------------------------------------------------
WriteAction "Build" "Cleanup-Files"
#Remove-Item $PSScriptRoot\Source\PSAdmin\obj -Recurse -ErrorAction 'SilentlyContinue' -Verbose

#
#Action: Build\Install-Dependencies
#--------------------------------------------------
WriteAction "Build" "Install-Dependencies"

#dotnet add $PSScriptRoot\Source\PSAdmin package System.Management.Automation --version 6.2.0
#dotnet add $PSScriptRoot\Source\PSAdmin package System.Management.Automation --version 6.1.0
#dotnet add $PSScriptRoot\Source\PSAdmin package System.Management.Automation --version 6.0.0
#dotnet add $PSScriptRoot\Source\PSAdmin package System.Data.SQLite --version 1.0.110
#dotnet add $PSScriptRoot\Source\PSAdmin package System.Data.SQLite.Core --version 1.0.110
#dotnet add package SQLite.Interop --version 1.0.0



#
#Action: Build\Build-Project
#--------------------------------------------------
WriteAction "Build" "Build-Project"
#Write-Host ("`nExecuting Action: {0}\{1}`n{2}`n" -f "Build", "Build-Project", $DrawLine) -ForeGroundColor Green
#dotnet build $PSScriptRoot\Source\PSAdmin

#
#Action: Build\Build-Module
#--------------------------------------------------
WriteAction "Build" "Build-Module"
Remove-Item -Path $PSScriptRoot/Module -Recurse -ErrorAction SilentlyContinue -Force
New-Item -Path $PSScriptRoot/Module/PSAdmin -ItemType Directory -ErrorAction SilentlyContinue -Force | Out-Null
Copy-Item "$PSScriptRoot/src/rc/*" -Recurse -Destination "$PSScriptRoot/Module/PSAdmin/" -Force

dotnet publish -o "$PSScriptRoot\Module\PSAdmin\" --self-contained
#start pwsh -Args "-noexit -command . { invoke-pester .\tests\PSAdmin.KeyVaultCertificate.Tests.ps1 }"
start powershell -Args "-noexit -command . { invoke-pester .\tests\PSAdmin.KeyVaultCertificate.Tests.ps1 }"
return











#
#Action: Build\Invoke-Pester
#--------------------------------------------------
WriteAction "Build" "Invoke-Pester"
#Invoke-Pester $PSScriptRoot\
