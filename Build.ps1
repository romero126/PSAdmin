[CmdletBinding()]
param(
    [ValidateSet("Build", "Test", "Execute", "Example","Example.Interactive")]
    [String]$Action
)



if (!$Action) {
    Write-Warning "Cannot Determine Desired Action"
    Write-Warning "Opening a Window"
#    $PossibleActions = "Build", "Test", "Execute", "Example" | ForEach-Object { [PSCustomObject]@{ Action = $_ } }
    $PossibleActions = @(
        [PSCustomObject]@{
            Action          = "Build"
            Description     = "*** Nothing to do here ***"
        },
        [PSCustomObject]@{
            Action          = "Test"
            Description     = "Pester Tests"
        },
        [PSCustomObject]@{
            Action          = "Execute"
            Description     = "*** Nothing to do here ***"
        },
        [PSCustomObject]@{
            Action          = "Example"
            Description     = "Adds your computer to the database."
        },
        [PSCustomObject]@{
            Action          = "Example.Interactive"
            Description     = "Ineractive Powershell Window to interact with the database."
        }
    )

    $Action = $PossibleActions | Out-GridView -Title "Select an Option" -PassThru | ForEach-Object Action
}
Write-Host $Action



Switch ($Action)
{

    "Build"  {
        Write-Warning 'Nothing to Build its Powershell'
    }
    "Test" {
        Write-Warning "Beginning Unit Tests for PSAdmin"
        $PesterItems = Get-ChildItem $PSScriptRoot/Tests/*.Tests.ps1
        Invoke-Pester $PesterItems
    }
    "Execute" {
        Write-Warning "Nothing to Execute"

    }
    "Example" {
        Write-Warning "Starting Example"
        . "$PSScriptRoot\Examples\Example.ps1"
    }
    "Example.Interactive" {
       Start-Process powershell ("-noexit -command . $PSScriptRoot/Examples/Example.Interactive.ps1") -PassThru
    }
}