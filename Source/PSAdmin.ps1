$Files = Get-ChildItem "$PSScriptRoot/PowerShell.Functions/*.Public.ps1" -recurse

$PubliCFunctions = new-object System.Collections.Generic.List[String]
foreach ($File in $Files) {

    . $File

    if ($File.BaseName -match "Public") {
        $str = $File.BaseName.Replace(".Public", "")
        $PublicFunctions.Add($str)
    }

}

$OS = if (($PSEdition -eq "Desktop") -or ($IsWindows))
{
    if (([System.Environment]::Is64BitProcess))
    {
        "x64"
    }
    else
    {
        "x86"
    }
}
elseif (($IsMacOS) -or ($IsOSX))
{
    "mac"
}
else
{
    $ErrorMessage = "Cannot determine a compatable OSVersion to load an appropriate DLL `r`n{0}\{1}"
    $ErrorMessage = $ErrorMessage -f $PSVersionTable.PSEdition, $PSVersionTable.OS
    throw $ErrorMessage
}

Write-Verbose "Loading ${OS}"

Import-Module $PSScriptRoot/$OS/PSAdmin.dll

#$PublicFunctions