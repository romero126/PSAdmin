Write-Log "SQLite.init.ps1" -Status Debug -Offset 2

#Throw "KevinException NotImplemented"
if ([System.Environment]::OSVersion.Platform -eq "Unix")
{
    $Libraries = Get-ChildItem -Path "$PSScriptRoot/mac/*.dll"
}
elseif ([System.Environment]::Is64BitProcess)
{
    $Libraries = Get-ChildItem -Path "$PSScriptRoot/x64/*.dll"
}
else 
{
    $Libraries = Get-ChildItem -Path "$PSScriptRoot/x86/*.dll"
}

Write-Log "Loading Dependencies" -Status Debug -Offset 3

#Load Libraries
foreach ($Lib in $Libraries) {
    try {
        Add-Type -Path $Lib.FullName
        Write-Log $Lib.BaseName -Status Debug -Offset 3
    }
    catch {
        Write-Log "Unable to load DLL: $($Lib.BaseName)" -Status Warning -Offset 3
        Write-Error [System.String]::Format("Unable to load DLL: {0}", $Lib.FullName)
    }
}