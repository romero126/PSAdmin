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
            Write-Warning 'Build action not created yet.'

            $ModulePath = "$PSScriptRoot/Module/PSAdmin/PSAdmin.psm1"

            Remove-Item -Path $PSScriptRoot/Module -Recurse -ErrorAction SilentlyContinue -Force -Confirm:$false | Out-Null
            New-Item -Path $PSScriptRoot/Module/PSAdmin -ItemType Directory -ErrorAction SilentlyContinue -Force | Out-Null
            Copy-Item -Path $PSScriptRoot/Source/Bin/* -Destination $PSScriptRoot/Module/PSAdmin -Recurse
            
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
                $ReferencedAssemblies = $ReferenceAssemblyManifest + (get-childitem -Path $Path/bin/$Build/*.dll -Recurse)
                Write-Host "Compiling DLL for $Build" -ForegroundColor Cyan
                Add-Type -Path $ObjectList -OutputAssembly $PSScriptRoot/Module/$Module/$Build/$Module.dll -ReferencedAssemblies $ReferencedAssemblies
            }
            function Local:Build {
                [CmdletBinding()]
                param(
                    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
                    [System.String]$FullName,
                    [Parameter(Mandatory, ValueFromPipelineByPropertyName)] 
                    [System.String]$BaseName,
                    [Parameter(Mandatory)]
                    [System.String]$ModulePath,
                    [Parameter(Mandatory)]
                    [System.String]$Type,
                    [Parameter()]
                    [Switch]$Passthru
                )

                begin
                {

                }

                process
                {
                    $Content = Get-ChildItem -Path ("{0}\*.{1}.ps1" -f $FullName, $Type) -Recurse | Get-Content
                    if ($Content)
                    {
                        $Data = & {
                            $BaseInfo = "{0}\{1}" -f $Type.ToUpper(),$BaseName
                            ("#---------------------------------------------------------[{0,-30}]--------------------------------------------------------" -f $BaseInfo)
                            $Content
                        }
                        if ($Passthru) {
                            ". {"
                            $Data | ForEach-Object { "`t" + $_ }
                            "}"
                        }
                        else {
                            $Data | Out-File -FilePath $ModulePath -Append                            
                        }

                    }

                }

                end
                {

                }
            }
            Get-ChildItem $PSScriptRoot/Source -Directory | Local:Build -ModulePath $ModulePath -Type "Begin"
            Get-ChildItem $PSScriptRoot/Source -Directory | Local:Build -ModulePath $ModulePath -Type "Init"
            Get-ChildItem $PSScriptRoot/Source -Directory | Local:Build -ModulePath $ModulePath -Type "Private"
            Get-ChildItem $PSScriptRoot/Source -Directory | Local:Build -ModulePath $ModulePath -Type "Public"
            Get-ChildItem $PSScriptRoot/Source -Directory | Local:Build -ModulePath $ModulePath -Type "End"

            $Children = Get-ChildItem -Path $PSScriptRoot/Source/*.Public.ps1 -Recurse | ForEach-Object { "'{0}'" -f $_.BaseName.Replace('.Public', '') }

            $Cmdlets =  "Open-PSAdmin"                  ,
                "New-PSAdminKeyVault"                   ,
                "Get-PSAdminKeyVault"                   ,
                "Set-PSAdminKeyVault"                   ,
                "Remove-PSAdminKeyVault"                ,
                #"Protect-PSAdminKeyVault"               ,
                #"UnProtect-PSAdminKeyVault"             ,
                #"Import-PSAdminKeyVaultCertificate"     ,
                #"Export-PSAdminKeyVaultCertificate"     ,
                #"Get-PSAdminKeyVaultCertificate"        ,
                #"Remove-PSAdminKeyVaultCertificate"     ,
                #"New-PSAdminKeyVaultSecret"             ,
                #"Get-PSAdminKeyVaultSecret"             ,
                #"Set-PSAdminKeyVaultSecret"             ,
                #"Remove-PSAdminKeyVaultSecret"          ,
                #"ConvertFrom-PSAdminKeyVaultSecret"     ,
                #"ConvertTo-PSAdminKeyVaultSecret"       ,
                #"New-PSAdminComputer"                   ,
                "Get-PSAdminComputer"                   
                #"Set-PSAdminComputer"                   ,
                #"Remove-PSAdminComputer"

                
            "Export-ModuleMember -Function {0} -Cmdlet {1}" -f ($Children -Join ','), ($cmdlets -join ',') | Out-File -FilePath $ModulePath -Append

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