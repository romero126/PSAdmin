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

#Get-Command -Module PSAdmin | Out-Host