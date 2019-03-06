function Open-PSAdmin
{
    <#
        .SYNOPSIS
            Opens a database configuration file for connections to SQLite/SQL Databases.

        .DESCRIPTION
            Opens database configuration file for connections to SQLite/SQL Database.
        
        .PARAMETER Path
            Specify path to .xml configuration file

        .EXAMPLE
        
            ``` powershell
            Open-PSAdmin -Path "C:\MyDatabase\DBConfig.xml"
            ```
        .INPUTS
            None. You cannot pipe objects to Open-PSAdmin

        .OUTPUTS
            None. Upon successful completion.

        .NOTES

        .LINK

    #>
    [CmdletBinding()]

    param(
        [Parameter(Mandatory)]
        [ValidateScript({ return Test-Path -Path $_ -PathType Leaf })]
        [System.String]$Path
    )

    begin
    {

        Write-Debug "Begin Open-PSAdmin"

    }

    process
    {
        Write-Debug "Loading XML File"
        $Script:PSAdminConfig = [XML](Get-Content $Path)

        Write-Debug "Storing DB Connection String"
        $Script:PSAdminDBConfig = @{}
        $Script:PSAdminDBConfig["Path"] = Get-Item -Path $Path | ForEach-Object Directory

        $Script:PSAdminConfig.CONFIG.Database.ChildNodes | ForEach-Object { $Script:PSAdminDBConfig[$_.Name] = $_.'#Text' }

        $Database = Connect-PSAdminSQlite @Script:PSAdminDBConfig
        foreach ($cfg in $Script:Config.GetEnumerator() )
        {
            $Null = New-PSAdminSQLiteTable -Database $Database -Table $cfg.Value.TableName -PSCustomObject $cfg.Value.TableSchema
        }
        Disconnect-PSAdminSQLite -Database $Database
        #Todo: Remove ScriptBlock for cleaner building
        #!_ScriptBlock_
    }

    end
    {

        Write-Debug "End Open-PSAdmin"

    }
}
