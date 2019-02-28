function Set-PSAdminMachineSecret
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String]$VaultName,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias("ComputerName", "TargetMachine")]
        [System.String]$Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [PSCredential]$Credential,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String]$Description,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String]$Tag,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Switch]$Apply,

        [Parameter(ValueFromRemainingArguments)]
        [Object[]]$InputData

    )
    begin
    {

    }
    process
    {

        $Machine = Get-PSAdminMachine -VaultName $VaultName -Name $Name
        if (!$Machine) {
            throw "Cant process this because Machine doesnt exist"
        }
        if ($Machine.Tags -Contains $Tag) {

        }
        if ($Credential)
        {
            $SecretExists = Get-PSAdminKeyVaultSecret -VaultName $Machine.VaultName -Name ("{0}\{1}\{2}" -f $Machine.LocalIP, $Tag, 0) -Exact

            $SecretData = @{
                VaultName   = $Machine.VaultName
                Name        = "{0}\{1}\{2}" -f $Machine.LocalIP, $Tag, 0
                SecretValue = "USERNAME={0}&PASSWORD={1}" -f $Credential.UserName, $Credential.GetNetworkCredential().Password
                Enabled     = "True"
            }

            if ($SecretExists) {
                Set-PSAdminKeyVaultSecret @SecretData
            } else {
                New-PSAdminKeyVaultSecret @SecretData
            }
        }
        if ($Apply) {
            $Secrets = Get-PSAdminKeyVaultSecret -VaultName $Machine.VaultName -Name ("{0}\{1}\*" -f $Machine.LocalIP, $Tag) -Decrypt | Sort-Object -Property Name
            Remove-PSAdminKeyVaultSecret -VaultName $Machine.VaultName -Name ("{0}\{1}\*" -f $Machine.LocalIP, $Tag) -Match -Confirm:$false

            foreach ($Secret in $Secrets)
            {
                $Index = @($Secrets).IndexOf($Secret) + 1

                $SecretData = @{
                    VaultName       = $Secret.VaultName
                    Name            = ("{0}\{1}\{2}" -f $Machine.LocalIP, $Tag, $Index)
                    Version         = $Secret.Version
                    Enabled         = "False"
                    Expires         = if ($Secret.Expires -gt [DateTime]::UTCNow) {
                        [DateTime]::UTCNow
                    } else { $Secret.Expires }
                    NotBefore       = $Secret.NotBefore
                    ContentType     = $Secret.ContentType                 
                    Tags            = $Secret.Tags
                    SecretValue     = $Secret.SecretValue
                }

                New-PSAdminKeyVaultSecret @SecretData
            }
        }

    }
    end
    {

    }

}