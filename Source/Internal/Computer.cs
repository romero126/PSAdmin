using System;
using System.Collections;
using System.Collections.Generic;
using PSAdmin;
using PSAdmin.Internal;

namespace PSAdmin.Internal {
    public static class Computer {
        private static string TableName = "PSAdminComputer";
        private static Type TableType = typeof(Data.Computer);

        public static Data.Computer[] GetData()
        {
            string query = String.Format("SELECT * FROM {0}", TableName);

            return SQLiteDB.ConvertToType<Data.Computer[]>( SQLiteDB.Query(query) );
        }

    }
}