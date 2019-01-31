function Disconnect-PSAdminSQLite() {
	param(
		[Parameter(Mandatory)]
		[System.Data.SQLite.SQLiteConnection]$Database
	)
	Write-Debug ("{0}: {1}" -f $MyInvocation.MyCommand, "Disconnecting from database.")
	$Database.Dispose()
}