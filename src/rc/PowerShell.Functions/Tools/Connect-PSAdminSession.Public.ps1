function Connect-PSAdminSession
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String]$VaultName = "*",

        [Parameter(Mandatory)]
        [System.String]$ComputerName,

        [Switch]$UsePublicIP

    )

    begin
    {

    }
    process
    {
        $Computer = Get-PSAdminComputer -VaultName $VaultName -ComputerName $ComputerName

        if ((Get-PSSession -Name $Computer.ComputerName -ErrorAction SilentlyContinue) -ne $null) {
            Write-Host "* Session already exists *" -ForegroundColor Yellow
            return
        }
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

        $Credential = Get-PSAdminComputerSecret -VaultName $Computer.VaultName -Name $Computer.ComputerName -Tag "RemoteAdmin" -ExportCred | ForEach-Object Credential
        if (!$Credential) {
            Write-Error ("Secret for '{0}' with the name of '{1}' not found" -f $Computer.ComputerName, $ComputerName)
            return
        }
        Write-Host "* Generating Session *" -ForegroundColor Yellow
        New-PSSession -ComputerName $TargetIP -Credential $Credential -Name $Computer.ComputerName | Out-Null
    }
    end
    {
        Write-Host "* Executing Remotely to $($Computer.ComputerName) *"  -ForegroundColor Yellow

        Enter-PSSession -Name $Computer.ComputerName
    }
}