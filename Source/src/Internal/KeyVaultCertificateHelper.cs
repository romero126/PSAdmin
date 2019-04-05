using System;
using System.Collections;
using System.Collections.Generic;

using System.Management.Automation;

using System.Security;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;

namespace PSAdmin.Internal 
{
    public static class KeyVaultCertificateHelper {
        private static string TableName = "PSAdminKeyVaultCertificate";

        #region ImportItem

        #endregion

        #region ExportItem

        #endregion

        #region GetItem
        public static Data.KeyVaultCertificate GetItem(string Id, string VaultName, string Name, string Thumbprint, string[] Tags, bool Export, bool Exact)
        {
            Data.KeyVaultCertificate[] result = GetItems(Id, VaultName, Name, Thumbprint, Tags, Export, Exact);
            if (result.Length == 1)
            {
                return result[0];
            }
            return null;
        }
        
        public static Data.KeyVaultCertificate GetItemThrow(string Id, string VaultName, string Name, string Thumbprint, string[] Tags, bool Export, bool Exact)
        {
            Data.KeyVaultCertificate[] result = GetItems(Id, VaultName, Name, Thumbprint, Tags, Export, Exact);
            if (result.Length > 1)
            {
                throw new KevinBlumenfeldException(KevinBlumenfeldExceptionType.QuotaExceeded, Name, "Name");
            }

            if (result.Length == 0)
            {
                throw new KevinBlumenfeldException(KevinBlumenfeldExceptionType.ItemNotFoundLookup, Name, "Name");
            }

            return result[0];
        }

        public static Data.KeyVaultCertificate[] GetItems(string Id, string VaultName, string Name, string Thumbprint, string[] Tags, bool Export, bool Exact)
        {
            string filter;

            Hashtable filterTable = new Hashtable {
                { "Id",             Id },
                { "VaultName",      VaultName },
                { "Name",           Name },
                { "Thumbprint",     Thumbprint }
            };

            filter = SQLiteDB.Filter(filterTable, Exact);
            
            string filterTags = SQLiteDB.Filter("Tags", Tags, false);
            if (!String.IsNullOrEmpty(filterTags)) {
                filter = String.Format("{0} AND {1}", filter, filterTags);
            }

            Data.KeyVaultCertificate[] results = SQLiteDB.ConvertToType<Data.KeyVaultCertificate[]>(
                SQLiteDB.GetRow(TableName, filter)
            );

            foreach (Data.KeyVaultCertificate result in results)
            {
                if (Export)
                {
                    result.Certificate = new X509Certificate2((byte[])result.Certificate, result.Thumbprint, X509KeyStorageFlags.Exportable);
                }
                else
                {
                    result.Certificate = new X509Certificate2((byte[])result.Certificate, result.Thumbprint);
                }
            }
            return results;
        }

        internal static Data.KeyVaultCertificate[] GetItemsThrow(string Id, string VaultName, string Name, string Thumbprint, string[] Tags, bool Export, bool Exact)
        {
            Data.KeyVaultCertificate[] result = GetItems(Id, VaultName, Name, Thumbprint, Tags, Export, Exact);

            if ((Exact) && (result.Length == 0))
            {
                throw new KevinBlumenfeldException(KevinBlumenfeldExceptionType.ItemNotFoundLookup, Name, "Name");
            }

            return result;
        }

        public static bool ItemExists(string Id, string VaultName, string Name, string Thumbprint, string[] Tags, bool Export, bool Exact)
        {
            Data.KeyVaultCertificate[] result = GetItems(Id, VaultName, Name, Thumbprint, Tags, Export, Exact);
            if (result.Length == 0)
            {
                return false;
            }
            return true;
        }

        internal static bool ThrowIfItemExists(string Id, string VaultName, string Name, string Thumbprint, string[] Tags, bool Export, bool Exact)
        {
            if (ItemExists(Id, VaultName, Name, Thumbprint, Tags, Export, Exact))
            {
                throw new KevinBlumenfeldException(KevinBlumenfeldExceptionType.ItemExists, Name, "Name");
            }
            return true;
        }

        internal static bool ThrowIfItemNotExists(string Id, string VaultName, string Name, string Thumbprint, string[] Tags, bool Export, bool Exact)
        {
            if (!ItemExists(Id, VaultName, Name, Thumbprint, Tags, Export, Exact))
            {
                throw new KevinBlumenfeldException(KevinBlumenfeldExceptionType.ItemExists, Name, "Name");
            }
            return true;
        }
        #endregion

        #region SetItem
        

        #endregion

        #region RemoveItem
        public static bool RemoveItem(string Id, string VaultName, string Name, bool Exact)
        {
            Data.KeyVaultCertificate result = GetItem(Id, VaultName, Name, null, null, false, Exact);
            if (result == null) {
                return false;
            }
            return RemoveItems(Id, VaultName, Name, Exact);
        }

        internal static bool RemoveItemThrow(string Id, string VaultName, string Name, bool Exact)
        {
            Data.KeyVaultCertificate result = GetItemThrow(Id, VaultName, Name, null, null, false, Exact);
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
                throw new KevinBlumenfeldException(KevinBlumenfeldExceptionType.RowDelete);
            }
            return true;
        }

        #endregion

    }

}