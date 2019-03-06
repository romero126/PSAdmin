## What is it?
PSAdminComputer is a Central Storage location to manage your Computers.

## An Inventory Tool

For Example its a birds eye view of your environment allowing you to see at a glance what you have.
```
PS C:\> get-psadminmachine -VaultName LAB

VaultName       Name                             LocalIP            ProvisioningState    Description    LastOnline
---------       ----                             -------            -----------------    -----------    ----------
LAB             WA01MGT01GW001                   172.16.1.1                             Remote Desk...
LAB             WA01MGT01LG001                   172.16.1.128
```

## Available Commands

* [Get-PSAdminComputer][1] Gets a PSAdmin Computer.
* [New-PSAdminComputer][2] Creates a PSAdmin Computer.
* [Set-PSAdminComputer][3] Sets a Value in PSAdmin Computer.
* [Remove-PSAdminComputer][4] Remove a PSAdmin Computer.
* [Get-PSAdminComputerSecret][5] Gets a PSAdminComputer Secret
* [Set-PSAdminComputerSecret][6] Sets a PSAdminComputer Secret

[1]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/Get-PSAdminComputer.md
[2]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/New-PSAdminComputer.md
[3]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/Set-PSAdminComputer.md
[4]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/Remove-PSAdminComputer.md
[5]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/Get-PSAdminComputerSecret.md
[6]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/Set-PSAdminComputerSecret.md