function Remove-PSAdminMachine
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, Position=0, ValueFromPipelineByPropertyName)]
        [System.String]$Name,
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Id,
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$SQLIdentity
    )

    begin
    {
        function Cleanup {
            Disconnect-PSAdminSQLite -Database $Database
        }
        $Database = Connect-PSAdminSQLite @Script:PSAdminDBConfig
    }

    process
    {
        $DBQuery = @{
            Database        = $Database
            Keys            = $Script:PSAdminMachineSchema.DB.Table.KEY | ForEach-Object { $_ }
            Table           = $Script:PSAdminMachineSchema.DB.Table.Name
            InputObject     = [PSCustomObject]@{}
        }

        $HasKey = foreach ($Param in $PSBoundParameters.GetEnumerator()) {
            if ($DBQuery.Keys -contains $Param.Key)
            {
                $true
                break
            }
        }

        if (!$HasKey)
        {
            Cleanup
            Throw "You must specify a valid Searchable Key example:'$Keys'"
        }

        foreach ($Param in $PSBoundParameters.GetEnumerator())
        {
            Add-Member -InputObject $DBQuery.InputObject -MemberType NoteProperty -Name $Param.Key -Value $Param.Value
        }

        $Result = Remove-PSAdminSQliteObject @DBQuery

        if ($Result -eq -1)
        {

            Cleanup
            Throw "Unable to remove Item"
        }

    }

    end
    {
        Cleanup
    }
}