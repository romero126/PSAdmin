## What is it?
PSAdminMachine is a Central Storage location to manage your machines.

## What is the Schema?
Before you run PSAdmin for the first time you can edit your MachineSchema So that you can hold various fields related to your environment.

In your PSAdmin Module folder there is a file DBSchema.XML edit this file

Adding ITEMS to this will add more DynamicParameters to your Database so you can add things like CPU clock speeds, or what the machine is used for or even many other options unique to your environment.

File: DBSchema.XML
```
<DB>
    <TABLE Name="PSAdminMachine">
        <TypeName>PSAdminMachine.PSAdmin.Module</TypeName>
        <DefaultDisplayPropertySet>Name, AssetNumber, SerialNumber, Location, Ip, Domain,  Description, MachineDefinition </DefaultDisplayPropertySet>
        
        <KEY>SQLIdentity</KEY>
        <KEY>Id</KEY>
        <KEY>Name</KEY>

        <ITEM>SQLIdentity</ITEM>
        <ITEM>Id</ITEM>
        <ITEM>Name</ITEM>
        <ITEM>Description</ITEM>
        <ITEM>Created</ITEM>
        <ITEM>Updated</ITEM>
        <ITEM>Location</ITEM>
    </TABLE>
</DB>
```

## Available Commands

1. [Get-PSAdminMachine][GetCommand] Gets a PSAdmin KeyVault Secret.
2. [New-PSAdminMachine][NewCommand] Creates a PSAdmin KeyVault Secret.
3. [Set-PSAdminMachine][SetCommand] Sets a Value in PSAdmin KeyVault Secret.
4. [Remove-PSAdminMachine][RemoveCommand] Remove a PSAdmin KeyVault Secret.

[GetCommand]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/Get-PSAdminMachine.md
[NewCommand]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/New-PSAdminMachine.md
[SetCommand]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/Set-PSAdminMachine.md
[RemoveCommand]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/Remove-PSAdminMachine.md