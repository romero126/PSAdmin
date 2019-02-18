Open-PSAdmin -Path <PathOfXMLFile>
    Things to note: If you dont specify a full path for DataSource it will be relative to where the XML file is placed.


```
NAME
    Open-PSAdmin
    
SYNOPSIS
    Opens a database configuration file for connections to SQLite/SQL Databases.
    
    
SYNTAX
    Open-PSAdmin [-Path] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Opens database configuration file for connections to SQLite/SQL Database.
    

PARAMETERS
    -Path <String>
        Specify path to .xml configuration file
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Open-PSAdmin -Path "C:\MyDatabase\DBConfig.xml"
```