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
        $Computer = Get-PSAdminMachine -VaultName $VaultName -Name $ComputerName

        if ((Get-PSSession -Name $Computer.Name -ErrorAction SilentlyContinue) -ne $null) {
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

        $Credential = Get-PSAdminMachineSecret -VaultName $Computer.VaultName -Name $Computer.Name -Tag "RemoteAdmin" -ExportCred | ForEach-Object Credential
        if (!$Credential) {
            Write-Error ("Secret for '{0}' with the name of '{1}' not found" -f $Computer.Name, $Name)
            return
        }
        Write-Host "* Generating Session *" -ForegroundColor Yellow
        New-PSSession -ComputerName $TargetIP -Credential $Credential -Name $Computer.Name | Out-Null
    }
    end
    {
        Write-Host "* Executing Remotely to $($Computer.Name) *"  -ForegroundColor Yellow

        Enter-PSSession -Name $Computer.Name
    }
}