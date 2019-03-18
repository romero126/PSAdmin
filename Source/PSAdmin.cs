using System;
using System.IO;
using System.Management.Automation;
/// Need to be in SQLite
using System.Data;
using System.Data.SQLite;

namespace PSAdmin.Internal {

    public static class Config {
        public static string SQLConnectionString { get; set; }
        public static bool IsLocalDatabase { get;set; }
        /*
        internal static Dictionary<String, String> TableList = new Dictionary<string, string>()
        {
            { "Computer", "PSAdminComputer" }
        }
        */
    }
    
}

