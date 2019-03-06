function Invoke-PSAdminCommand
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String]$VaultName,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias("Name", "TargetMachine")]
        [System.String]$ComputerName,

        [Parameter(Mandatory, ParameterSetName="ScriptBlock")]
        [ScriptBlock]$ScriptBlock,

        [Parameter(Mandatory, ParameterSetName="Command")]
        [String]$Command,

        [Parameter()]
        [Switch]$UsePublicIP,

        [Parameter()]
        [Object[]]$ArgumentList,

        [Parameter()]
        [Switch]$HideComputerName
    )

    begin
    {
        if ($Command) {
            $SB = Get-Command -Name $Command | Select -First 1 | ForEach-Object ScriptBlock
            if ( $SB ) {
                $ScriptBlock = [ScriptBlock]::Create( $SB.ToString() )
            }
        }
    }
    process
    {


        $Computer = Get-PSAdminComputer -VaultName $VaultName -ComputerName $ComputerName

        if ($Computer.Tags -NotContains "RemoteAdmin") {

            Write-Error "Remote Admin not Installed on machine"
            return
        }

        if (!$Computer.LocalIP) {
            Write-Error "Computer does not have LocalIP Setup on this machine"
            return
        }

        $TargetIP = $Computer.LocalIP
        if ($UsePublicIP) {
            $TargetIP = $Computer.PublicIP
        }

        $Credential = Get-PSAdminComputerSecret -VaultName $Computer.VaultName -ComputerName $Computer.ComputerName -Tag "RemoteAdmin" -ExportCred | ForEach-Object Credential
        if (!$Credential) {
            Write-Error ("Secret for '{0}' with the name of '{1}' not found" -f $Computer.Name, $Name)
            return
        }

        if (!$HideComputerName) {
            Write-Host "* Executing Remote Command on $($Computer.Name) *"  -ForegroundColor Yellow
        }

        $Session = New-PSSession -ComputerName $TargetIP -Credential $Credential

        Invoke-Command -Session $Session -ScriptBlock { Set-Variable -Name $args[0] -Value $args[1] } -ArgumentList 'PSAdminComputer', $Computer

        Invoke-Command -Session $Session -ScriptBlock $ScriptBlock -ArgumentList $ArgumentList

        Remove-PSSession -ComputerName $TargetIP | Out-Null
        
        if (!$HideComputerName) {
            Write-Host "* Finished Executing Remote Command on $($Computer.Name) *" -ForegroundColor Yellow
        }
    }
    end
    {

    }
}