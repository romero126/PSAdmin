function Invoke-PSAdminSQLiteQuery
{
	[cmdletbinding()]
	param(
		[Parameter(Mandatory)]
		[System.Data.SQLite.SQLiteConnection]$Database,
		[String]$Query
	)
	begin
	{
		$Database.Open()
	}
	process
	{
		Write-Verbose ("{0}: {1}" -f $MyInvocation.MyCommand, $Query)
		$Call = [System.Data.SQLite.SQLiteCommand]::new($Query, $Database)

		$Result = -1
		try {
			$result = $call.ExecuteNonQuery()
		} catch {
			$result = -1
		}
		$Result
	}
	end
	{
		$Database.Close()
	}
}