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
        $DBInitScripts = Get-ChildItem $PSScriptRoot\..\*.OpenDB.ps1 -Recurse

        foreach ($Item in $DBInitScripts)
        {
            $ItemName = $Item.BaseName.Replace('.OpenDB', '')
            
            try {
                Write-Debug "Initializing DB $ItemName"
                . $Item.FullName
            }
            catch {
                Write-Error "Unable to load $ItemName"
                throw $_
                exit
            }
        }
    }
    end
    {
        Write-Debug "End Open-PSAdmin"
    }
}
