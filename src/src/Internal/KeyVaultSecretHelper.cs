using System;
using System.Collections;


namespace PSAdmin.Internal
{
    public static class KeyVaultSecretHelper
    {
        private static string TableName = "PSAdminKeyVaultSecret";

        // (string Id, string VaultName, string Name, string Version, string Enabled, Nullable<DateTime> Expires, Nullable<DateTime> NotBefore, Nullable<DateTime> Created, Nullable<DateTime> Updated, string ContentType, string[] Tags, string SecretValue)
        #region New
        public static bool NewItem(string Id, string VaultName, string Name, string Version, string Enabled, Nullable<DateTime> Expires, Nullable<DateTime> NotBefore, string ContentType, string[] Tags, string SecretValue)
        {
            bool ItemExists = KeyVaultSecretHelper.ItemExists(null, VaultName, Name, null, false, true);
            if (ItemExists)
            {
                return false;
            }

			// Create Item
			byte[] Key = KeyVaultHelper.GetVaultKey(VaultName);
			Hashtable table = new Hashtable {
                { "Id",                     Id },
                { "VaultName",              VaultName },
                { "Name",            		Name },
                { "Version",                Version },
                { "Enabled",                Enabled },
                { "Expires",             	Expires },
                { "NotBefore",           	NotBefore },
                { "Created",           		DateTime.UtcNow },
				{ "Updated",           		DateTime.UtcNow },
                { "ContentType",            ContentType },
				{ "SecretValue", 			Crypto.ConvertToKeyVaultSecret(SecretValue, Key) }
            };

            if (Tags != null)
                table.Add("Tags",                 string.Join(";", Tags));

            return SQLiteDB.CreateRow(TableName, table);
        }

        public static bool NewItemThrow(string Id, string VaultName, string Name, string Version, string Enabled, Nullable<DateTime> Expires, Nullable<DateTime> NotBefore, string ContentType, string[] Tags, string SecretValue)
        {
            KeyVaultHelper.ThrowIfItemNotExists(null, VaultName, true);
            ThrowIfItemExists(null, VaultName, Name, null, false, true);

            bool IsSuccessful = NewItem(Id, VaultName, Name, Version, Enabled, Expires, NotBefore, ContentType, Tags, SecretValue);
            if (!IsSuccessful)
            {
                throw new PSAdminException(PSAdminExceptionType.RowCreate);
            }
            return true;
        }
        #endregion

        #region Get
        public static Data.KeyVaultSecret GetItem(string Id, string VaultName, string Name, string[] Tags, bool Decrypt, bool Exact)
        {
            Data.KeyVaultSecret[] result = GetItems(Id, VaultName, Name, Tags, Decrypt, Exact);
            if (result.Length == 1)
            {
                return result[0];
            }
            return null;
        }
        internal static Data.KeyVaultSecret GetItemThrow(string Id, string VaultName, string Name, string[] Tags, bool Decrypt, bool Exact)
        {
            Data.KeyVaultSecret[] result = GetItems(Id, VaultName, Name, Tags, Decrypt, Exact);

            if (result.Length > 1)
            {
                throw new PSAdminException(PSAdminExceptionType.QuotaExceeded, Name, "Name");
            }

            if (result.Length == 0)
            {
                throw new PSAdminException(PSAdminExceptionType.ItemNotFoundLookup, Name, "Name");
            }

            return result[0];
        }

        public static Data.KeyVaultSecret[] GetItems(string Id, string VaultName, string Name, string[] Tags, bool Decrypt, bool Exact) {
            return GetItems(Id, VaultName, Name, Tags, Decrypt, Exact, false);
        }

        public static Data.KeyVaultSecret[] GetItems(string Id, string VaultName, string Name, string[] Tags, bool Decrypt, bool Exact, bool WithoutSecret)
        {
            string filter;

            Hashtable filterTable = new Hashtable {
                { "Id",         Id },
                { "VaultName",  VaultName },
                { "Name",		Name }
            };

            filter = SQLiteDB.Filter(filterTable, Exact);
            
            string filterTags = SQLiteDB.Filter("Tags", Tags, false);

            if (!String.IsNullOrEmpty(filterTags)) {
                filter = String.Format("{0} AND {1}", filter, filterTags);
            }

            Data.KeyVaultSecret[] result = SQLiteDB.ConvertToType<Data.KeyVaultSecret[]>(
                SQLiteDB.GetRow(TableName, filter)
            );
        
            foreach (Data.KeyVaultSecret i in result)
            {
                //Todo: Remove Version Check
                if (i.Version == "-1") {
                    continue;
                }
                byte[] Key = KeyVaultHelper.GetVaultKey(i.VaultName);

                if(!WithoutSecret)
                {
                    // Decrypt Data to respective content type
                    if ((Decrypt) && (i.ContentType == "txt"))
                    {
                        i.SecretValue = Crypto.ConvertFromKeyVaultSecret( (byte[])i.SecretValue, Key);
                    }
                    else if (Decrypt)
                    {
                        i.SecretValue = Crypto.ConvertFromKeyVaultSecretAsBytes( (byte[])i.SecretValue, Key);
                    }
                    else
                    {
                        i.SecretValue = Crypto.ConvertFromKeyVaultSecretAsSecureString( (byte[])i.SecretValue, Key);
                    }
                } else {
                    i.SecretValue = null;
                }
			}

            
            return result;
        }

        internal static Data.KeyVaultSecret[] GetItemsThrow(string Id, string VaultName, string Name, string[] Tags, bool Decrypt, bool Exact)
        {
            Data.KeyVaultSecret[] result = GetItems(Id, VaultName, Name, Tags, Decrypt, Exact);

            if ((Exact) && (result.Length == 0))
            {
                throw new PSAdminException(PSAdminExceptionType.ItemNotFoundLookup, Name, "Name");
            }

            return result;
        }

        public static bool ItemExists(string Id, string VaultName, string Name, string[] Tags, bool Decrypt, bool Exact)
        {
            Data.KeyVaultSecret[] result = GetItems(Id, VaultName, Name, Tags, Decrypt, Exact);
            if (result.Length == 0)
            {
                return false;
            }
            return true;
        }
        internal static void ThrowIfItemExists(string Id, string VaultName, string Name, string[] Tags, bool Decrypt, bool Exact)
        {
            if (ItemExists(Id, VaultName, Name, Tags, Decrypt, Exact))
            {
                throw new PSAdminException(PSAdminExceptionType.ItemExists, Name, "Name");
            }
        }
        internal static void ThrowIfItemNotExists(string Id, string VaultName, string Name, string[] Tags, bool Decrypt, bool Exact)
        {
            if (!ItemExists(Id, VaultName, Name, Tags, Decrypt, Exact))
            {
                throw new PSAdminException(PSAdminExceptionType.ItemNotFoundLookup, Name, "Name");
            }

        }

        #endregion

        #region Set

        public static bool SetItem(string Id, string VaultName, string Name, string Version, string Enabled, Nullable<DateTime> Expires, Nullable<DateTime> NotBefore, string ContentType, string[] Tags, string SecretValue, bool Exact)
        {
            Data.KeyVaultSecret result = GetItem(Id, VaultName, Name, null, false, true);
            if (result == null) {
                return false;
            }
            return SetItems(Id, VaultName, Name, Version, Enabled, Expires, NotBefore, ContentType, Tags, SecretValue, Exact);
        }

        internal static bool SetItemThrow(string Id, string VaultName, string Name, string Version, string Enabled, Nullable<DateTime> Expires, Nullable<DateTime> NotBefore, string ContentType, string[] Tags, string SecretValue, bool Exact)
        {
            Data.KeyVaultSecret result = GetItemThrow(Id, VaultName, Name, null, false, true);
            if (result == null) {
                return false;
            }
            return SetItemsThrow(Id, VaultName, Name, Version, Enabled, Expires, NotBefore, ContentType, Tags, SecretValue, Exact);
        }
        public static bool SetItems(string Id, string VaultName, string Name, string Version, string Enabled, Nullable<DateTime> Expires, Nullable<DateTime> NotBefore, string ContentType, string[] Tags, string SecretValue, bool Exact)
        {
            Data.KeyVault KeyVault = KeyVaultHelper.GetItem(null, VaultName, true);
            if (KeyVault == null)
            {
                return false;
            }

            // Build the Key
            byte[] Key = KeyVaultHelper.GetVaultKey(KeyVault.VaultName);
            byte[] SecretData = null;
            if (!String.IsNullOrEmpty(SecretValue))
                SecretData = Crypto.ConvertToKeyVaultSecret(SecretValue, Key);

            Hashtable filter = new Hashtable {
                {"Id",                  Id },
                {"VaultName",           VaultName },
                {"Name",                Name }
            };

            Hashtable table = new Hashtable {
                { "Version",            Version },
                { "Enabled",            Enabled },
                { "Expires",            Expires },
                { "NotBefore",          NotBefore },
                { "ContentType",        ContentType },
                { "Tags",               Tags },
                { "SecretValue",        SecretData }
            };

            if (Tags != null)
                table.Add("Tags",       String.Join(";", Tags));

            return SQLiteDB.UpdateRow(TableName, table, filter, Exact);
        }

        public static bool SetItemsThrow(string Id, string VaultName, string Name, string Version, string Enabled, Nullable<DateTime> Expires, Nullable<DateTime> NotBefore, string ContentType, string[] Tags, string SecretValue, bool Exact)
        {
            KeyVaultHelper.GetItemThrow(null, VaultName, true);
            bool issuccessful = SetItems(Id, VaultName, Name, Version, Enabled, Expires, NotBefore, ContentType, Tags, SecretValue, Exact);
            if (!issuccessful)
            {
                throw new PSAdminException(PSAdminExceptionType.RowUpdate);
            }
            return true;
        }


        #endregion

        #region Remove

        public static bool RemoveItem(string Id, string VaultName, string Name, bool Exact)
        {
            Data.KeyVaultSecret result = GetItem(Id, VaultName, Name, null, false, Exact);
            if (result == null) {
                return false;
            }
            return RemoveItems(Id, VaultName, Name, Exact);
        }

        internal static bool RemoveItemThrow(string Id, string VaultName, string Name, bool Exact)
        {
            Data.KeyVaultSecret result = GetItemThrow(Id, VaultName, Name, null, false, Exact);
            if (result == null) {
                return false;
            }
            return RemoveItems(Id, VaultName, Name, Exact);
        }

        public static bool RemoveItems(string Id, string VaultName, string Name, bool Exact)
        {
            string filter;

            Hashtable filterTable = new Hashtable {
                {"Id",                  Id },
                {"VaultName",           VaultName },
                {"Name",                Name }
            };

            filter = SQLiteDB.Filter(filterTable, Exact);

            return SQLiteDB.RemoveRow(TableName, filter);
        }

        public static bool RemoveItemsThrow(string Id, string VaultName, string Name, bool Exact)
        {
            bool IsSuccessful = RemoveItems(Id, VaultName, Name, Exact);
            if (!IsSuccessful)
            {
                throw new PSAdminException(PSAdminExceptionType.RowDelete);
            }
            return true;
        }

        #endregion
    }

}