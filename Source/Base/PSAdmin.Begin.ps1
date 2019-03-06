<#

param(
    [Hashtable]$ArgumentList
)
if ($ArgumentList)
{
    if ($ArgumentList.VerbosePreference)
    {
        $VerbosePreference = $ArgumentList.VerbosePreference
    }
    if ($ArgumentList.DebugPreference)
    {
        $DebugPreference = $ArgumentList.DebugPreference
    }
}


#>

$Script:PSAdminConfig   = $null
$Script:PSAdminDB       = $null
$Script:PSAdminDBConfig = $null
$Script:Config = @{}

$Script:PSAdminLocale =  & {
    $Path = "{0}/Locale/{1}/globalization.xml" -f $PSScriptRoot, [System.Globalization.CultureInfo]::CurrentCulture.Name
    if ( Test-Path $Path ) {
        return [xml](Get-Content $Path)
    }
    $Path = "{0}/Locale/Default/globalization.xml" -f $PSScriptRoot
    if ( Test-Path $Path ) {
        return [xml](Get-Content $Path)
    }
    throw "cannot load language locale"
}


function Write-Log
{
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [System.String[]]$Message,
        [ValidateSet("Information", "Verbose", "Debug", "Message", "Warning", "Success", "Failed", "Error", "Unknown")]
        [System.String]$Status = "Information",
        [int]$Offset = 0

    )

    $Pref = Get-Variable "*Preference" | Where-Object Name -EQ "$($Status)Preference"
    if (($Pref) -and ($Pref.Value -ne "Continue")) {
        return
    }

    Write-Host ("[{0}] " -f [DateTime]::UTCNow.ToString("HH:mm:ss.ffff")) -NoNewline
    Write-Host ("[{0,11}]" -f $Status.ToUpper()) -NoNewline

    #(Get-PSCallStack)[1]
    Write-Host (" " * ($Offset * 2)), "*", $Message
}

$ModuleName = "PSAdmin"