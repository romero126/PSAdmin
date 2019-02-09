function New-PSAdminException
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.String]$ErrorID,

        [Parameter()]
        [System.String[]]$ArgumentList
    )

    begin
    {

    }

    process
    {
        $Exception = $Script:PSAdminLocale.GetElementById($ErrorID)

        if (!$Exception)
        {
            throw "Invalid Exception Name"
        }
        if ($ArgumentList) {
            return New-Object -TypeName $Exception.TypeName -ArgumentList ($Exception.Value -f $ArgumentList)
        }
        return New-Object -TypeName $Exception.TypeName -ArgumentList ($Exception.Value)

    }

    end 
    {

    }
}