function Get-PSAdminMachine
{
    [OutputType([PSCustomObject[]])]
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position=0)]
        [System.String]$Name        = "*",
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Id          = "*",
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$SQLIdentity = "*",
        [Parameter()]
        [Switch]$Exact
    )

    begin
    {
        $Database = Connect-PSAdminSQLite @Script:PSAdminDBConfig
    
        $PSProperties = $Script:PSAdminMachineSchema.DB.Table.DefaultDisplayPropertySet.Split(",").Trim()
        $PSTypeName = $Script:PSAdminMachineSchema.DB.Table.TypeName
        $PSTypeData = Get-TypeData -TypeName $PSTypeName

        if (!$PSTypeData)
        {
            Update-TypeData -TypeName $PSTypeName -DefaultDisplayPropertySet $PSProperties
        }

    }

    process
    {
        $DBQuery = @{
            Database        = $Database
            Keys            = $Script:PSAdminMachineSchema.DB.Table.KEY | ForEach-Object { $_ }
            Table           = $Script:PSAdminMachineSchema.DB.Table.Name
            InputObject     = [PSCustomObject]@{
                SQLIdentity     = $SQLIdentity
                Id              = $Id
                Name            = $Name
            }
        }

        $Results = Get-PSAdminSQliteObject @DBQuery -Match:(!$Exact)

        foreach ($Result in $Results) {
            $Result.PSObject.TypeNames.Insert(0, $PSTypeName)            
            $Result
        }

    }

    end
    {
        Disconnect-PSAdminSQLite -Database $Database
    }
}