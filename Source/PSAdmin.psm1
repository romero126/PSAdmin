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

$Script:PSAdminConfig   = $null
$Script:PSAdminDB       = $null
$Script:PSAdminDBConfig = $null

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

$InitScripts        = Get-ChildItem -Path "$PSScriptRoot/bin/*.Init.ps1" -Recurse
$PublicScripts      = Get-ChildItem -Path "$PSScriptRoot/bin/*.Public.ps1" -Recurse
$PrivateScripts     = Get-ChildItem -Path "$PSScriptRoot/bin/*.Public.ps1" -Recurse

Write-Log "Initializing" -Status Verbose

foreach ($Item in $InitScripts)
{
    $ItemName = $Item.BaseName.Replace('Init', '')
#    $ItemPathing = $Item.FullName.Replace($PSScriptRoot, '').Split([System.IO.Path]::DirectorySeparatorChar) | Select-Object -Skip 2 | Select-Object -SkipLast 1
#    Write-Host $ItemPathing
#    Write-Verbose $ItemPathing
    Write-Log "$ItemName" -Status Verbose -Offset 1
    try {
        . $Item.FullName
    }
    catch {
        Write-Log "Unable to load $ItemName" -Status Warning -Offset 1
        throw $_
        exit
    }
}

Write-Log "Loading Private Functions" -Status Verbose

foreach ($Item in $PrivateScripts)
{
    $ItemName = $Item.BaseName.Replace('Private', '')
    #Write-Verbose "* $ItemName"
    try {
        . $Item.FullName
    }
    catch {
        Write-Log "Unable to load $ItemName" -Status Warning -Offset 1
        throw $_
        exit
    }
}

Write-Log "Loading Public Functions" -Status Verbose -Offset 1
foreach ($Item in $PublicScripts)
{
    $ItemName = $Item.BaseName.Replace('Public', '')
    #Write-Verbose "      * $ItemName"
    Write-Log $ItemName -Status Debug -Offset 2
    try {
        . $Item.FullName
    }
    catch {
        Write-Warning "Unable to load $ItemName"
        throw $_
        exit
    }
}

Write-Log "Exporting Public Functions" -Status Verbose
Export-ModuleMember -Function $PublicScripts.BaseName.Replace('.Public','') 

#Write-Log "Exporting Private Scripts" -Status Verbose
#Export-ModuleMember -Function $PrivateScripts.BaseName.Replace('Private','') 

if ($ArgumentList) {
    Open-PSAdmin -Path ("{0}{1}" -f $ArgumentList.Path, $ArgumentList.DBConfigFile)
#    write-host "Configuration Loaded for ", $ArgumentList.Path
}

write-host ($path | out-string)