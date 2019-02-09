function Set-PSAdminMachine
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.String]$Name
    )
    dynamicParam
    {
        $SkipParam = "Name"
        $dynamicParameters = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        #Get Parameters
        
        $Properties = $Script:PSAdminMachineSchema.DB.Table.ITEM | ForEach-Object { $_ }

        [Parameter()][System.String]$_paramHelper = $null

        foreach ($item in $Properties)
        {
            if ($SkipParam -Contains $Item)
            {
                continue;
            }
            $itemCollection = @((Get-Variable '_paramHelper').Attributes)
            $itemParam = New-Object System.Management.Automation.RuntimeDefinedParameter($item, [System.String], $itemCollection)
            $dynamicParameters.Add($item, $itemParam)
            
        }
        
        Remove-Variable '_paramHelper'
        return $dynamicParameters
    }

    begin
    {
        function Cleanup {
            Disconnect-PSAdminSQLite -Database $Database
        }
        $Database = Connect-PSAdminSQLite @Script:PSAdminDBConfig
    }

    process
    {
        $Keys = $Script:PSAdminMachineSchema.DB.Table.KEY | ForEach-Object { $_ }
        $HasKey = foreach ($Param in $PSBoundParameters.GetEnumerator()) {
            if ($Keys -contains $Param.Key)
            {
                $true
                break
            }
        }

        if (!$HasKey)
        {
            Cleanup
            Throw "You must specify a valid Searchable Key Example:'$Keys'"
        }

        $DBQuery = @{
            Database        = $Database
            Keys            = $Script:PSAdminMachineSchema.DB.Table.KEY | ForEach-Object { $_ }
            Table           = $Script:PSAdminMachineSchema.DB.Table.Name
            InputObject     = [PSCustomObject]@{}
        }

        foreach ($Param in $PSBoundParameters.GetEnumerator())
        {
            Add-Member -InputObject $DBQuery.InputObject -MemberType NoteProperty -Name $Param.Key -Value $Param.Value
        }

        Add-Member -InputObject $DBQuery.InputObject -MemberType NoteProperty -Name "Updated" -Value ([DateTime]::UtcNow) -Force

        $Result = Set-PSAdminSQliteObject @DBQuery
        if ($Result -eq -1)
        {
            Cleanup
            Throw "Unable to update item"
        }

    }

    end
    {
        Cleanup
    }

}

