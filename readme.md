## What is PSAdmin
PSAdmin is a PowerShell Designed toolkit for System Administrators to Easily Deploy and manage their Computer Systems.

## What it is now
Currently PSAdmin is a Database tool designed to handle your assets as cleanly and dynamically as possible.

### It's Experimental!
By far this is no where a complete project as it should evolve since the ambition for the project clearly outweighs what a single person's ambition can do on his spare time after work.

## Examples of use
```sh
Import-Module $PWD\Source\PSAdmin.psm1
Open-PSAdmin -Path "$pwd\MyDatabase\MyDatabase.xml"
New-PSAdminMachine -Name "MyName" -Description "MyDescription' -IP "YourIP"
Set-PSAdminMachine -Name "MyName" -Location "MyLocation"
Get-PSAdminMachine -Name "MyName"
Remove-PSAdminMachine -Name "Myname"
```

## PSAdmin Command List

Note this is always changing and will change as features get added.
[Open-PSAdmin]: https://github.com/romero126/PSAdmin/blob/master/Docs/PSAdmin.md
[Get-PSAdminMachine]: https://github.com/romero126/PSAdmin/blob/master/Docs/PSAdminMachine.md
[Set-PSAdminMachine]: https://github.com/romero126/PSAdmin/blob/master/Docs/PSAdminMachine.md
[New-PSAdminMachine]: https://github.com/romero126/PSAdmin/blob/master/Docs/PSAdminMachine.md
[Remove-PSAdminMachine]: https://github.com/romero126/PSAdmin/blob/master/Docs/PSAdminMachine.md

## Upcoming Features / Wish List
1. Automated Workflows
2. Store SecureValues
3. Blob Storage
4. Remote Invoke/PSSession
5. Easy and Automated Ingestion of Log files to tools like Kibana/Elastisearch
6. This is just brainstorming.
