function Request-PSAdminSQLiteQuery() {
	[CmdletBinding()]
    param(
		[Parameter(Mandatory)]
		[System.Data.SQLite.SQLiteConnection]$Database,
		[Parameter(Mandatory)]
		[String]$Query
	)
	begin
	{
		$Database.Open()
	}

	process
	{

		$cmd = [System.Data.SQLite.SQLiteCommand]::new($Query, $Database)

		$reader = $cmd.ExecuteReader()

		while ($reader.Read()) {
			
			$Result = [PSCustomObject]@{}

			foreach ($i in (0..$($reader.FieldCount - 1))) {
				$Result | Add-Member -MemberType NoteProperty -Name $reader.GetName($i) -Value (. ({$reader.GetValue($i)}, { $null } )[$reader.IsDBNull($i)])
			}

			$Result
		}
		
	}

	end
	{
		$Database.Close()
	}
}

