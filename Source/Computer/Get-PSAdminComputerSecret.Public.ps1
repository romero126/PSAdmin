function Get-PSAdminComputerSecret
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String]$VaultName,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias("Name", "TargetMachine")]
        [System.String]$ComputerName,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String]$Tag,

        [Parameter()]
        [Switch]$ExportCred,

        [Parameter()]
        [Switch]$All
    )

    begin
    {

    }

    process 
    {
        $Computer = Get-PSAdminComputer -VaultName $VaultName -ComputerName $ComputerName
        if (!$Computer) {
            throw "Cant process this because Machine doesnt exist"
        }
        $Target = 1
        if ($All) {
            $Target = "*"
        }
        $GetComputerSecrets = @{
            VaultName   = $Computer.VaultName
            Name        = "{0}\{1}\{2}" -f $Computer.LocalIP, $Tag, $Target
        }

        $Results = Get-PSAdminKeyVaultSecret @GetComputerSecrets -Decrypt | Sort-Object -Property Name
        foreach ($Result in $Results) {
            if ($ExportCred) {
                $Username, $Password = [regex]::Match($Result.SecretValue, '^USERNAME=([\w\w\S]+)&PASSWORD=([\w\W]+)$').Groups[1, 2].Value
                $Result = $Result | Select *, Credential
                $Result.Credential = [PSCredential]::New($UserName, ($Password | ConvertTo-SecureString -AsPlainText -Force))
                $Result.SecretValue = $Result.SecretValue | ConvertTo-SecureString -AsPlainText -Force
                $UserName, $Password = $Null, $Null
            }

            $Result
        }
    }

    end
    {

    }
}