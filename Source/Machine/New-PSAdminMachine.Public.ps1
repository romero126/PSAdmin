function New-PSAdminMachine
{
    [CmdletBinding()]
    param(
        
    )
    dynamicParam
    {

        $dynamicParameters = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        #Get Parameters
        
        $Properties = $Script:PSAdminMachineSchema.DB.Table.ITEM | ForEach-Object { $_ }

        [Parameter()][System.String]$_paramHelper = $null

        foreach ($item in $Properties)
        {

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
        $Keys = "Name"
        
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
            Throw "You must specify a valid Searchable Key example:'Name'"
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

        if ([System.String]::IsNullOrEmpty($DBQuery.InputObject.Name))
        {
            Cleanup
            throw "A name must be specified"
        }

        $Guid = [Guid]::NewGuid().ToString()
        Add-Member -InputObject $DBQuery.InputObject -MemberType NoteProperty -Name "Id" -Value $Guid -Force
        Add-Member -InputObject $DBQuery.InputObject -MemberType NoteProperty -Name "SQLIdentity" -Value $Guid -Force
        Add-Member -InputObject $DBQuery.InputObject -MemberType NoteProperty -Name "Created" -Value ([DateTime]::UtcNow)
        Add-Member -InputObject $DBQuery.InputObject -MemberType NoteProperty -Name "Updated" -Value ([DateTime]::UtcNow)

        $Result = Get-PSAdminMachine -Name $DBQuery.InputObject.Name
        if ($Result)
        {
            Cleanup
            throw "Cannot create an object with Name '$($DBQuery.InputObject.Name)' already exists"
        }

        $Result = New-PSAdminSQliteObject @DBQuery

        if ($Result -eq -1)
        {
            Cleanup
            throw "Unable to Update Item"
        }

    }

    end
    {
        Cleanup
    }

}