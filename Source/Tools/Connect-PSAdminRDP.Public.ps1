function Connect-PSAdminRDP
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [System.String]$VaultName,

        [Parameter(Mandatory)]
        [Alias("Name")]
        [System.String]$ComputerName,

        [Switch]$UsePublicIP

    )

    begin
    {

    }
    process
    {
        $Computer = Get-PSAdminComputer -VaultName $VaultName -ComputerName $ComputerName

        if ($Computer.Tags -NotContains "RemoteAdmin") {
            throw "Remote Admin not Installed on machine"
        }

        if (!$Computer.LocalIP) {
            throw "Computer does not have LocalIP Setup on this machine"
        }

        $TargetIP = $Computer.LocalIP
        if ($UsePublicIP) {
            $TargetIP = $Computer.PublicIP
        }

        $Credential = Get-PSAdminComputerSecret -VaultName $Computer.VaultName -ComputerName $Computer.ComputerName -Tag "RemoteAdmin" -ExportCred | ForEach-Object Credential
        if (!$Credential) {
            Write-Error ("Secret for '{0}' with the name of '{1}' not found" -f $Computer.ComputerName, $ComputerName)
            return
        }
        $Username, $Password = $Credential.UserName, $Credential.GetNetworkCredential().Password
        cmdkey.exe /Generic:$TargetIP /User:$UserName /pass:$Password | out-null

        $PassStr = $null
        $UserName, $Password = $null, $null

        Write-Host "* Connecting Remotely to $($Computer.ComputerName) *"  -ForegroundColor Yellow
        mstsc -v $TargetIP

    }
    end
    {

    }
}