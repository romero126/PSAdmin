#Set-PSAdminRemoteCommand
function Install-RemoteAdmin {
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String]$UserName = "_RemoteAdmin_",

        [Parameter()]
        [System.String]$Description = "Remote Administrator Account",

        [Parameter()]
        [System.String]$Password = [Char[]](1..45 | % { [char]( 33..62+64..91+93..95+97..123+125 | get-random ) }) -join ''
    )

    begin
    {

    }

    process
    {

        $UserData = @{
            Name            = $UserName
            Description     = $Description
            Password        = $Password | ConvertTo-SecureString -AsPlainText -Force
        }

        if ($User)
        {
            Set-LocalUser @UserData
        }
        else
        {
            New-LocalUser @UserData
        }

        #Adding LocalGroupMember
        $GroupMember = Get-LocalGroupMember -Group "Administrators" -Member "_RemoteAdmin_" -ErrorAction SilentlyContinue
        if (!$GroupMember)
        {
            Add-LocalGroupMember -Group "Administrators" -Member "_RemoteAdmin_"
        }

        return [PSCustomObject]@{
            VaultName           = $PSAdminComputer.VaultName
            Name                = $PSAdminComputer.Name
            Credential          = [PSCredential]::New($UserName, ($Password | ConvertTo-SecureString -AsPlainText -Force))
            Description         = $Description
            Tag                 = "RemoteAdmin"
        }
    }

    end
    {

    }
}