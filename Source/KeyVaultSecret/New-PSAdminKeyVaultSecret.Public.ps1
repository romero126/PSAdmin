function New-PSAdminKeyVaultSecret
{

    #New-PSAdminKeyVaultSecret -VaultName "LocalAdministrator" -Name "127.0.0.1" -Enabled True -ContentType txt -SecretValue "12345"

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
        [System.String]$ContentType = "txt",

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
        $KeyVault = Get-PSAdminKeyVault -VaultName $VaultName -Exact

        if (@($KeyVault).Count -ne 1)
        {
            Cleanup
            throw New-PSAdminException -ErrorID KeyVaultExceptionResultCount -ArgumentList "VaultName", $VaultName, 1, $KeyVault.Count
        }

        $Result = Get-PSAdminKeyVaultSecret -Name $Name -VaultName $VaultName -Exact
        if ($Result)
        {
            Cleanup
            throw New-PSAdminException -ErrorID KeyVaultSecretExceptionExists -ArgumentList $VaultName, $Name
        }

        $Id = [Guid]::NewGuid().ToString().Replace('-', '')
        $Created = [DateTime]::UTCNow
        $Updated = [DateTime]::UTCNow

        $DBQuery = @{
            Database        = $Database
            Keys            = ("VaultName", "Name", "Id")
            Table           = "PSAdminKeyVaultSecret"
            InputObject     = [PSCustomObject]@{
                VaultName   = $VaultName
                Name        = $Name
                Version     = $Version
                Id          = $Id
                Enabled     = $Enabled
                Expires     = $Expires
                NotBefore   = $NotBefore
                Created     = $Created
                Updated     = $Updated
                ContentType = $ContentType
                Tags        = $Tags
                SecretValue = ConvertTo-PSAdminKeyVaultSecretValue -VaultName $VaultName -InputData $SecretValue
            }
        }
        
        $Result = New-PSAdminSQliteObject @DBQuery

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