function Set-PSAdminKeyVaultSecret
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String]$VaultName,
        
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String]$Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Version,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("True", "False")]
        [System.String]$Enabled,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [DateTime]$Expires,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [DateTime]$NotBefore = [DateTime]::UtcNow,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("txt", "blob")]
        [System.String]$ContentType,

        [Parameter(ValueFromPipelineByPropertyName)]
        [String[]]$Tags,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [PSObject]$SecretValue
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
        $Updated = [DateTime]::UTCNow
        $DBQuery = @{
            Database        = $Database
            Keys            = ("VaultName", "Name", "Id")
            Table           = "PSAdminKeyVaultSecret"
            InputObject     = [PSCustomObject]@{}
        }

        #Needs to be dynamically generated for it to work properly
        foreach ($Param in $PSBoundParameters.GetEnumerator())
        {
            if ( ($Param.Key -eq "SecretValue") -and (!([System.String]::IsNullOrEmpty($SecretValue))) )
            {
                $SecValue = ConvertTo-PSAdminKeyVaultSecretValue -VaultName $VaultName -InputData $SecretValue
                
                Add-Member -InputObject $DBQuery.InputObject -MemberType NoteProperty -Name $Param.Key -Value $SecValue
                continue;
            }
            Add-Member -InputObject $DBQuery.InputObject -MemberType NoteProperty -Name $Param.Key -Value $Param.Value
        }
        Add-Member -InputObject $DBQuery.InputObject -MemberType NoteProperty -Name "Updated" -Value ([DateTime]::UtcNow)

        $Result = Set-PSAdminSQliteObject @DBQuery

        if ($Result -eq -1)
        {
            Cleanup
            throw New-PSAdminException -ErrorID ExceptionUpdateDatabase
        }

    }
    
    end
    {
        Cleanup
    }

}