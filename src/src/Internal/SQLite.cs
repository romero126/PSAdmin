using System;
using System.Data;
using System.Data.SQLite;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Management.Automation;


namespace PSAdmin.Internal {
    public static class SQLiteDB {

        public static T ConvertToType<T>(object item) where T : class
        {
            T result;
            LanguagePrimitives.TryConvertTo<T>(item, out result);
            return result;
        }
        public static bool NonQuery(string QueryString)
        {
            bool result = false;
            using (
                SQLiteConnection Database = new SQLiteConnection(Config.SQLConnectionString)
            )
            {
                Database.Open();
                using ( SQLiteCommand Command = new SQLiteCommand(QueryString, Database))
                {
                    int ItemsChanged = 0;
                    try {
                        ItemsChanged = Command.ExecuteNonQuery();                        
                    }
                    catch (SQLiteException  error) {
                        throw new SQLiteException( String.Format("{0} from query: {1}", error.Message, QueryString), error);
                    }
                    if (ItemsChanged > -1) {
                        result = true;
                    }
                }
                Database.Close();
            }
            return result;
        }

        public static List<Hashtable> Query(string querystring)
        {
            List<Hashtable> Results = new List<Hashtable>();
            using (
                SQLiteConnection Database = new SQLiteConnection(Config.SQLConnectionString)
            )
            {
                Database.Open();

                using (SQLiteCommand Command = new SQLiteCommand(querystring, Database) )
                {
                    using (SQLiteDataReader Reader = Command.ExecuteReader())
                    {
                        while (Reader.Read())
                        {
                            Hashtable Hash = new Hashtable();

                            for (int i = 0; i <= (Reader.FieldCount -1); i++)
                            {
                                Hash.Add(Reader.GetName(i), Reader.IsDBNull(i) ? null : Reader.GetValue(i) );
                            }

                            Results.Add(Hash);
                        }
                    }
                }
                Database.Close();
            }
            return Results;
        }

        public static List<Hashtable> GetRow(string tablename, string filter)
        {
            
            String query = String.Format("SELECT * FROM `{0}`", tablename);
            if (!String.IsNullOrEmpty(filter))
            {
                query = String.Format("{0} WHERE {1}", query, filter);
            }
            return Query(query);
        }

        public static List<Hashtable> GetRow(string tablename, Hashtable filter, bool isexact)
        {
            String query = String.Format("SELECT * FROM `{0}` WHERE {1}", tablename, Filter(filter, isexact));
            return Query(query);
        }
        public static bool CreateRow(string TableName, Hashtable InputItem)
        {

            bool result = false;
            using (
                SQLiteConnection Database = new SQLiteConnection(Config.SQLConnectionString)
            )
            {
                Database.Open();
                using ( SQLiteCommand Command = new SQLiteCommand(Database))
                {
                    List<String> TableColumns = new List<String>();
                    List<String> TableParameters = new List<String>();

                    foreach (DictionaryEntry item in InputItem)
                    {
                        String itemname = String.Format("{0}", item.Key);
                        String itemparam = String.Format("@{0}", item.Key);

                        TableColumns.Add( itemname );
                        TableParameters.Add( itemparam );

                        Command.Parameters.AddWithValue(itemparam, item.Value);
                    }

                    Command.CommandText = String.Format(
                        "INSERT INTO {0} ({1}) VALUES ({2})",
                        TableName,
                        String.Join(",", TableColumns),
                        String.Join(",", TableParameters)
                    );
                    
                    int ItemsChanged = 0;
                    try {
                        ItemsChanged = Command.ExecuteNonQuery();                        
                    }
                    catch (SQLiteException  error) {
                        throw new SQLiteException( String.Format("{0} from query: {1}", error.Message, Command.CommandText), error);
                    }
                    if (ItemsChanged > -1) {
                        result = true;
                    }
                }
                Database.Close();
            }
            return result;
        }

        public static bool UpdateRow(string TableName, Hashtable InputItem, Hashtable filter, bool Exact)
        {
            return UpdateRow(TableName, InputItem, Filter(filter, Exact), Exact);
        }
        public static bool UpdateRow(string TableName, Hashtable InputItem, string filter, bool Exact)
        {
            bool result = false;

            using (
                SQLiteConnection Database = new SQLiteConnection(Config.SQLConnectionString)
            )
            {
                Database.Open();
                using ( SQLiteCommand Command = new SQLiteCommand(Database))
                {
                    List<String> TableParameters = new List<String>();

                    foreach (DictionaryEntry item in InputItem)
                    {
                        if (item.Value == null)
                            continue;
                        String itemparam = String.Format("{0} = @{0}", item.Key);
                        TableParameters.Add( itemparam );
                        Command.Parameters.AddWithValue(item.Key.ToString(), item.Value);
                    }

                    Command.CommandText = String.Format(
                        "UPDATE {0} SET {1} WHERE {2}",
                        TableName,
                        String.Join(",", TableParameters),
                        filter
                    );

                    int ItemsChanged = 0;
                    try {
                        ItemsChanged = Command.ExecuteNonQuery();                        
                    }
                    catch (SQLiteException  error) {
                        throw new SQLiteException( String.Format("{0} from query: {1}", error.Message, Command.CommandText), error);
                    }
                    if (ItemsChanged > -1) {
                        result = true;
                    }
                }
                Database.Close();
            }
            return result;
        }

        public static bool RemoveRow(string tablename, Hashtable filter, bool isexact)
        {
            return RemoveRow(tablename, Filter(filter, isexact) );
        }
        public static bool RemoveRow(string tablename, string filter)
        {
            String query = String.Format("DELETE FROM `{0}` WHERE {1}", tablename, filter);
            return NonQuery(query);
        }
        public static DbType ConvertToDbType(Type type)
        {
            var typeMap = new Dictionary<Type, DbType>();
            typeMap[typeof(object)]                                 = DbType.Byte;
            typeMap[typeof(string)]                                 = DbType.String;
            typeMap[typeof(string[])]                               = DbType.String;
            typeMap[typeof(int)]                                    = DbType.Int32;
            typeMap[typeof(Int32)]                                  = DbType.Int32;
            typeMap[typeof(Int16)]                                  = DbType.Int16;
            typeMap[typeof(Int64)]                                  = DbType.Int64;
            typeMap[typeof(Byte[])]                                 = DbType.Binary;
            typeMap[typeof(Boolean)]                                = DbType.Boolean;
            typeMap[typeof(DateTime)]                               = DbType.DateTime;
            typeMap[typeof(Nullable<System.DateTime>)]              = DbType.DateTime;
            typeMap[typeof(DateTimeOffset)]                         = DbType.DateTimeOffset;
            typeMap[typeof(Decimal)]                                = DbType.Decimal;
            typeMap[typeof(Double)]                                 = DbType.VarNumeric;
            typeMap[typeof(Byte)]                                   = DbType.Byte;
            typeMap[typeof(TimeSpan)]                               = DbType.Time;
            typeMap[typeof(System.Net.IPAddress)]                   = DbType.String;
            return typeMap[type];
        }

        private static Dictionary<String, String> ValidConnectionStrings = new Dictionary<String, String>()
        {
            { "Database"              , "([\\w\\W]*)"     },
            { "Data Source"           , "([\\w\\W]*)"     },
            { "Pooling"               , "(True|False)"    },
            { "Max Pool Size"         , "([\\d]*)"        },
            { "FailIfMissing"         , "(True|False)"    },
            { "Synchronous"           , "(Full)"          },
            { "Version"               , "([\\d]*)"        },
            { "New"                   , "(True|False)"    },
            { "UseUTF16Encoding"      , "(True|False)"    },
            { "Password"              , "([\\w\\W]*)"     },
            { "Legacy Format"         , "(True|False)"    },
            { "Read Only"             , "(True|False)"    },
            { "DateTimeFormat"        , "(Ticks)"         },
            { "BinaryGUID"            , "(True|False)"    },
            { "Cache Size"            , "([\\d]*)"        },
            { "Page Size"             , "([\\d]*)"        },
            { "Enlist"                , "(N)"             },
            { "Max Page Count"        , "([\\d]*)"        },
            { "Journal Mode"          , "(Off|Persist)"   }
        };
        
        public static bool ValidateConnectionString(string connectionstring)
        {
            bool IsValid = false;
            foreach (KeyValuePair<string,string> entry in ValidConnectionStrings)
            {   
                bool IsExists = Regex.Match(connectionstring, String.Format("{0}=", entry.Key) ).Success;

                if (IsExists) {
                    if ((entry.Key == "Database") || (entry.Key == "Data Source"))
                    {
                        IsValid = true;
                    }
                    bool iscorrectsyntax = Regex.Match(connectionstring, String.Format("{0}={1};", entry.Key, entry.Value) ).Success;
                    if (!iscorrectsyntax) {
                        return false;
                    }
                }
            }

            if (!IsValid)
                return false;

            return true;
        }

        public static String Filter(string Key, string Value, bool IsExact)
        {
            if (IsExact) {
                
                if ((String.IsNullOrEmpty(Value)) || (Value == "%"))
                {
                    return null;
                }

                return String.Format("`{0}` == '{1}'", Key, Value);
            }
            Value = Value.Replace("*", "%").Replace("\\", "\\\\").Replace("_", "\\_");
            return String.Format(
                "`{0}` LIKE '{1}' ESCAPE '\\'",
                Key,
                Value
            );
        }

        public static String Filter(string Key, string[] Values, bool IsExact)
        {
            if (Values == null) {
                return null;
            }
            List<String> outlist = new List<String>();
            foreach (String value in Values)
            {
                string itemFilter = Filter(Key, value, IsExact);

                if (String.IsNullOrEmpty(itemFilter))
                {
                    continue;
                }

                outlist.Add(
                    itemFilter
                );
            }
            return String.Join(" AND ", outlist.ToArray());
        }

        public static String Filter(Hashtable FilterItem) {
            return Filter(FilterItem, true);
        }
        public static String Filter(Hashtable FilterItem, bool IsExact)
        {
            List<String> outlist = new List<String>();
            foreach (DictionaryEntry item in FilterItem)
            {
                // Null values should not be processed
                if (item.Value == null)
                    continue;
                    
                string itemFilter = Filter(item.Key.ToString(), item.Value.ToString(), IsExact);
                
                // Null output should not be processed
                if (String.IsNullOrEmpty(itemFilter))
                {
                    continue;
                }

                outlist.Add(
                    itemFilter
                );
            }
            return String.Join(" AND ", outlist.ToArray());
        }

        public static bool CreateTable(string tablename, Type T, bool ifnotexists)
        {

            StringBuilder query = new StringBuilder();
            query.Append("CREATE TABLE " );
            query.AppendFormat("{0}", ifnotexists ? "IF NOT EXISTS " : "");
            query.AppendFormat("`{0}` ", tablename);
            query.Append("(");
            
            foreach (System.Reflection.FieldInfo field in T.GetFields() )
            {
                query.AppendFormat("`{0}` {1}, ", field.Name, ConvertToDbType(field.FieldType));
            }
            query.Remove(query.Length - 2, 2);
            query.Append(");");
            return NonQuery(query.ToString());
        }
    }
}

