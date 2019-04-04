[CmdletBinding()]
param(
    [ValidateSet("Build", "Test", "Execute", "Example","Example.Interactive")]
    [String]$Action,
    [String]$TestName = "*"
)

$Menu = @(
    [PSCustomObject]@{
        Name            = "Build"
        Description     = "*** Nothing to do here ***"
        ScriptBlock     = {
            $ModulePath = "$PSScriptRoot/Module/PSAdmin/PSAdmin.psm1"

            Remove-Item -Path $PSScriptRoot/Module -Recurse -ErrorAction SilentlyContinue -Force -Confirm:$false | Out-Null
            New-Item -Path $PSScriptRoot/Module/PSAdmin -ItemType Directory -ErrorAction SilentlyContinue -Force | Out-Null            
            Copy-Item "$PSScriptRoot/Source/*" -Exclude *.cs, "src" -Recurse -Destination "$PSScriptRoot/Module/PSAdmin/" -Force
            function Local:Compile {
                [CmdletBinding()]
                param (
                    [Parameter(Mandatory)]
                    [System.String]$Path,
                    [Parameter(Mandatory)]
                    [System.String]$Module,
                    [Parameter(Mandatory)]
                    [System.String]$Build
                )

                $ReferenceAssemblyManifest = @(
                    "System.Data"
                    "System.Data.Common"
                    "System.ComponentModel.Primitives"
                    "System.Management.Automation"
                    "System.Text.RegularExpressions"
                    "System.Collections"
                )
                
                $ObjectList = Get-ChildItem -Path $Path/*.cs -Recurse
                $ReferencedAssemblies = $ReferenceAssemblyManifest + (get-childitem -Path $PSScriptRoot/Module/$Module/$Build/*.dll)
                Write-Host "Compiling DLL for $Build" -ForegroundColor Cyan
                Add-Type -Path $ObjectList -OutputAssembly $PSScriptRoot/Module/$Module/$Build/$Module.dll -ReferencedAssemblies $ReferencedAssemblies
            }


            Compile -Path $PSScriptRoot/Source/ -Module "PSAdmin" -Build x64
            Compile -Path $PSScriptRoot/Source/ -Module "PSAdmin" -Build x86
            Compile -Path $PSScriptRoot/Source/ -Module "PSAdmin" -Build mac
        }
    },
    
    [PSCustomObject]@{
        Name            = "Test"
        Description     = "Pester Tests"
        ScriptBlock     = {
            Write-Warning "Beginning Unit Tests for PSAdmin"
            $PesterItems = Get-ChildItem ("{0}/Tests/{1}.Tests.ps1" -f $PSScriptRoot, $TestName)
            #$PesterItems = Get-ChildItem $PSScriptRoot/Tests/*.Tests.ps1
            Invoke-Pester $PesterItems
        }
    },
    [PSCustomObject]@{
        Name            = "Execute"
        Description     = "*** Nothing to do here ***"
        ScriptBlock     = {
            Write-Warning "Nothing to Execute"
        }
    },
    [PSCustomObject]@{
        Name            = "Example"
        Description     = "Adds your computer to the database."
        ScriptBlock     = {
            Write-Warning "Starting Example"
            . "$PSScriptRoot\Examples\Example.ps1"
        }
    },
    [PSCustomObject]@{
        Name            = "Example.Interactive"
        Description     = "Ineractive Powershell Window to interact with the database."
        ScriptBlock     = {
            $null = Start-Process powershell ("-noexit -command . $PSScriptRoot/Examples/Example.Interactive.ps1") -PassThru
        }       
    }
)

if (!$Action) {
    Write-Warning "Cannot Determine Desired Action"
    Write-host "Possible Options", $MenuItem.Name
}

$MenuItem = $Menu | Where-Object Name -eq $Action

Write-Host "Calling Action", $MenuItem.Action

if ($MenuItem.ScriptBlock) {
    . $MenuItem.ScriptBlock
}