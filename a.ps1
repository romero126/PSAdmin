Get-ChildItem $PSScriptRoot\Source\* -Include *.CS, *.PS1 -recurse | Get-Content | ? { $_ -ne "" } | Measure

Get-ChildItem $PSScriptRoot\Source\* -Include *.CS, *.PS1 -recurse | Get-Content | Measure

