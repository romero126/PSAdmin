

## The Configuration File

The Config file is a simple XML that sets up a ConnectionString to a SQLite Database

Example:
DBConfig.xml
```sh
<CONFIG>
    <Database>
        <ConnectionType>SQLite</ConnectionType>
        <ConnectionString>Data Source={0};Pooling={1};FailIfMissing={2};Synchronous={3};</ConnectionString>
        <DataSource>PSAdmin.DB</DataSource>
        <Pooling>True</Pooling>
        <FailIfMissing>False</FailIfMissing>
        <Synchronous>Full</Synchronous>
    </Database>
</CONFIG>
```
Command to run
```sh
Open-PSAdmin -Path .\MyDatabase\DBConfig.xml
```

## Commands
1. [Open-PSAdmin][OpenPSAdmin] Opens PSAdmin Database.

[OpenPSAdmin]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/PSAdmin/Open-PSAdmin.md
