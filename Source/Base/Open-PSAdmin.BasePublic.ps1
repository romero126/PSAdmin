function Open-PSAdmin
{
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

        !_ScriptBlock_
    }

    end
    {

        Write-Debug "End Open-PSAdmin"

    }
}
