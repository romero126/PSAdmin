

## The Configuration File

The Database file is a flat XML that sets up a ConnectionString to a SQLite Database
Example:
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

## Commands
Open-PSAdmin -Path <PathOfXMLFile>
    Things to note: If you dont specify a full path for DataSource it will be relative to where the XML file is placed.
