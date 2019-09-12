$ActionType = Split-Path -Path $MyInvocation.MyCommand.Path -Leaf
Split-Path -Path $MyInvocation.MyCommand.Path -Leaf

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



#
#Action: Build\Cleanup-Files
#--------------------------------------------------
#WriteAction "Build" "Cleanup-Files"
#Remove-Item $PSScriptRoot\Source\PSAdmin\obj -Recurse -ErrorAction 'SilentlyContinue' -Verbose




#
#Action: Build\Build-Module
#--------------------------------------------------
WriteAction "Build" "Build-Module"
Remove-Item -Path $PSScriptRoot/Module -Recurse -ErrorAction SilentlyContinue -Force
New-Item -Path $PSScriptRoot/Module/PSAdmin -ItemType Directory -ErrorAction SilentlyContinue -Force | Out-Null
Copy-Item "$PSScriptRoot/src/rc/*" -Recurse -Destination "$PSScriptRoot/Module/PSAdmin/" -Force

dotnet publish -o "$PSScriptRoot\Module\PSAdmin\" --self-contained

#
#Action: Build\Invoke-Pester
#--------------------------------------------------
WriteAction "Build" "Invoke-Pester"
WriteAction "Invoke-Pester" "Powershell"
Start-Process powershell -Args "-command . .\Test.ps1" -NoNewWindow -Wait
WriteAction "Invoke-Pester" "PWSH"
Start-Process pwsh -Args "-command . .\Test.ps1" -NoNewWindow -Wait
