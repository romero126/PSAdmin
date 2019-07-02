using System;
using System.IO;
using System.Management.Automation;
/// Need to be in SQLite
using System.Data;
using System.Data.SQLite;
using PSAdmin;
using System.Collections.Generic;
using System.Collections;

namespace PSAdmin.Internal {

    public static class Config {
        public static string SQLConnectionString { get; set; }
        public static bool IsLocalDatabase { get;set; }

        internal static Dictionary<String, Type> SQLTables = new Dictionary<string, Type>()
        {
            { "PSAdminKeyVault",                typeof(Data.KeyVault) },
            { "PSAdminKeyVaultCertificate",     typeof(Data.KeyVaultCertificate) },
            { "PSAdminKeyVaultSecret",          typeof(Data.KeyVaultSecret) },
            { "PSAdminComputer",                typeof(Data.Computer) }
        };

    }
    
}

