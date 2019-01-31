function Connect-PSAdminSQLite {
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]$ConnectionType,
        [Parameter()]
        [System.String]$ConnectionString    = "Data Source='{0}';Pooling={1};FailIfMissing={2};Synchronous={3};",
        [Parameter()]
        [System.String]$DataSource          = "PSAdmin.DB",
        [Parameter()]
        [ValidateSet("True", "False")]
        [System.String]$Pooling                      = $True,
        [Parameter()]
        [ValidateSet("True", "False")]
        [System.String]$FailIfMissing                = $False,
        [Parameter()]
        [ValidateSet("Full")]
        [System.String]$Synchronous                  = "Full",
        [Parameter()]
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [System.String]$Path
    )

    [System.IO.Directory]::SetCurrentDirectory($Path)
    $ConnectionString = $ConnectionString -f $DataSource, $Pooling, $FailIfMissing, $Synchronous
    Write-Debug ("{0}: {1}" -f $MyInvocation.MyCommand, "Connecting to Database.")

    return [System.Data.SQLite.SQLiteConnection]::new($ConnectionString)
}