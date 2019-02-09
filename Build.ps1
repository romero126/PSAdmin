[CmdletBinding()]
param(
    [ValidateSet("Build", "Test", "Execute", "Example","Example.Interactive")]
    [String]$Action
)

$Menu = @(
    [PSCustomObject]@{
        Name            = "Build"
        Description     = "*** Nothing to do here ***"
        ScriptBlock     = {
            Write-Warning 'Build action not created yet.'

            $ModulePath = "$PSScriptRoot/Module/PSAdmin/PSAdmin.psm1"

            Remove-Item -Path $PSScriptRoot/Module -Recurse -ErrorAction SilentlyContinue -Force -Confirm:$false | Out-Null
            #Remove-item -Path $ModulePath -Recurse -Force
            New-Item -Path $PSScriptRoot/Module/PSAdmin -ItemType Directory -ErrorAction SilentlyContinue -Force | Out-Null
            Copy-Item -Path $PSScriptRoot/Source/Bin/* -Destination $PSScriptRoot/Module/PSAdmin -Recurse

            function Local:Build {
                [CmdletBinding()]
                param(
                    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
                    [System.String]$FullName,
                    [Parameter(Mandatory, ValueFromPipelineByPropertyName)] 
                    [System.String]$BaseName,
                    [Parameter(Mandatory)]
                    [System.String]$ModulePath,
                    [Parameter(Mandatory)]
                    [System.String]$Type,
                    [Parameter()]
                    [Switch]$Passthru
                )

                begin
                {

                }

                process
                {
                    $Content = Get-ChildItem -Path ("{0}\*.{1}.ps1" -f $FullName, $Type) -Recurse | Get-Content
                    if ($Content)
                    {
                        $Data = & {
                            $BaseInfo = "{0}\{1}" -f $Type.ToUpper(),$BaseName
                            ("#---------------------------------------------------------[{0,-30}]--------------------------------------------------------" -f $BaseInfo)
                            $Content
                        }
                        if ($Passthru) {
                            ". {"
                            $Data | ForEach-Object { "`t" + $_ }
                            "}"
                        }
                        else {
                            $Data | Out-File -FilePath $ModulePath -Append                            
                        }

                    }

                }

                end
                {

                }
            }
            Get-ChildItem $PSScriptRoot/Source -Directory | Local:Build -ModulePath $ModulePath -Type "Begin"
            Get-ChildItem $PSScriptRoot/Source -Directory | Local:Build -ModulePath $ModulePath -Type "Init"
            Get-ChildItem $PSScriptRoot/Source -Directory | Local:Build -ModulePath $ModulePath -Type "Private"
            Get-ChildItem $PSScriptRoot/Source -Directory | Local:Build -ModulePath $ModulePath -Type "Public"

            $DBPub = Get-ChildItem $PSScriptRoot/Source/*.BasePublic.ps1 -Recurse | Get-Content -Raw
            $Data = Get-ChildItem $PSScriptRoot/Source -Directory | Local:Build -ModulePath $ModulePath -Type "OnLoad" -PassThru

            $DBPub.Replace("!_ScriptBlock_", ($Data -join "`r`n`t")) | Out-File -FilePath $ModulePath -Append

            Get-ChildItem $PSScriptRoot/Source -Directory | Local:Build -ModulePath $ModulePath -Type "End"

            $Children = Get-ChildItem -Path $PSScriptRoot/Source/*.Public.ps1 -Recurse | ForEach-Object { "'{0}'" -f $_.BaseName.Replace('.Public', '') }
            "Export-ModuleMember -Function 'Open-PSAdmin',{0}" -f ($Children -Join ',') | Out-File -FilePath $ModulePath -Append
        }
    },
    
    [PSCustomObject]@{
        Name            = "Test"
        Description     = "Pester Tests"
        ScriptBlock     = {
            Write-Warning "Beginning Unit Tests for PSAdmin"
            $PesterItems = Get-ChildItem $PSScriptRoot/Tests/*.Tests.ps1
            Invoke-Pester $PesterItems
        }
    },
    [PSCustomObject]@{
        Name            = "Execute"
        Description     = "*** Nothing to do here ***"
        ScriptBlock     = {
            Write-Warning "Nothing to Execute"
        }
    },
    [PSCustomObject]@{
        Name            = "Example"
        Description     = "Adds your computer to the database."
        ScriptBlock     = {
            Write-Warning "Starting Example"
            . "$PSScriptRoot\Examples\Example.ps1"
        }
    },
    [PSCustomObject]@{
        Name            = "Example.Interactive"
        Description     = "Ineractive Powershell Window to interact with the database."
        ScriptBlock     = {
            $null = Start-Process powershell ("-noexit -command . $PSScriptRoot/Examples/Example.Interactive.ps1") -PassThru
        }       
    }
)


if (!$Action) {
    Write-Warning "Cannot Determine Desired Action"
    Write-Warning "Opening a Window"

    $Action = $Menu | Select Name, Description | Out-GridView -Title "Select an Option" -PassThru | ForEach-Object Name
}


$MenuItem = $Menu | Where-Object Name -eq $Action

#Write-Host $MenuItem
#$MenuItem | Select Name, Description

Write-Host "Calling Action", $MenuItem.Action

if ($MenuItem.ScriptBlock) {
    . $MenuItem.ScriptBlock
}



#Begin Notes
<#

Generate a cert and save it
Run as administrator
$Password = "123456"
$Cert = New-SelfSignedCertificate -Subject "PSAdminKeyVault.Module" -KeyUsage DataEncipherment -KeyAlgorithm RSA -KeyLength 2048 -KeyProtection None -KeyExportPolicy Exportable -KeySpec Signature
$certraw = $cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, $Password)
$certraw | Set-Content -Path .\cert.pfx -Encoding Byte


$CertRaw = Get-Content -Path .\Cert.pfx -Encoding Byte
$x509 = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new([byte[]]$certraw, "123456")


#Validate Cert
$NewCertRaw = $x509.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::SerializedCert )
$x5092 = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new([byte[]]$NewCertRaw)
$x5092.HasPrivateKey




function DecryptFromCert
{
    param(
        $text,
        $cert
    )
}

#Encrypt Data
$ToEncryptString = "Herro World"
$ToEncryptString = [System.Text.Encoding]::UTF8.GetBytes($ToEncryptString)

$EncData = $Cert.PublicKey.Key.Encrypt($ToEncryptString, $True)
$encData

#Decrypt
$Cert.PublicKey.Key.Decrypt([byte[]]$EncData,$false)


$ToEncryptString = "Herro World"
$ToEncryptString = [System.Text.Encoding]::UTF8.GetBytes($ToEncryptString)
$pubcer.PublicKey.Key.Encrypt($byteval,$true)

$decryptedBytes = $Cert.PrivateKey.Decrypt($EncData,$true)


function DecryptFromCert
{
    param(
        [Parameter(Mandatory)]
        [System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate,

        [Parameter()]
        [String]$InputString

        [Parameter(Mandatory)]
        [ValidateSet("Encrypt", "Decrypt")]
        [String]$Action
    )

    begin
    {

    }

    process
    {

    }

    end 
    {

    }
}


#>