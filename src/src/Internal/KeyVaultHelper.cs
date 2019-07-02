using System;
using System.Collections;
using System.Collections.Generic;
using System.Management.Automation;
using PSAdmin;

using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;

namespace PSAdmin.Internal 
{
    internal static class KeyVaultHelper {
        private static string TableName = "PSAdminKeyVault";

        #region NewItem
        public static bool NewItem(string Id, string VaultName, string Location, string VaultURI, bool SoftDeleteEnabled, string[] Tags)
        {
            bool ItemExists = KeyVaultHelper.ItemExists(null, VaultName, true);
            if (ItemExists)
            {
                return false;
            }

            // Generate Vault Key
            byte[] VaultKey = new byte[32];
            RNGCryptoServiceProvider.Create().GetBytes(VaultKey);

            Hashtable table = new Hashtable {
                {"Id",                  Id},
                {"VaultName",           VaultName },
                {"Location",            Location },
                {"VaultURI",            VaultURI },
                {"SoftDeleteEnabled",   SoftDeleteEnabled },
                {"VaultKey",            VaultKey}

            };

            if (Tags != null)
                table.Add("Tags",                 String.Join(";", Tags));

            return SQLiteDB.CreateRow("PSAdminKeyVault", table);
        }
        internal static bool NewItemThrow(string Id, string VaultName, string Location, string VaultURI, bool SoftDeleteEnabled, string[] Tags)
        {
            KeyVaultHelper.ThrowIfItemExists(null, VaultName, true);

            bool IsSuccessful = NewItem(Id, VaultName, Location, VaultURI, SoftDeleteEnabled, Tags);
            if (!IsSuccessful)
            {
                throw new PSAdminException(PSAdminExceptionType.RowCreate);
            }
            return true;
        }

        #endregion

        #region GetItem
        public static Data.KeyVault GetItem(string Id, string VaultName, bool Exact) {
            Data.KeyVault[] result = GetItems(Id, VaultName, Exact);
            if (result.Length == 1)
            {
                return result[0];
            }
            return null;
        }
        internal static Data.KeyVault GetItemThrow(string Id, string VaultName, bool Exact)
        {
            Data.KeyVault[] result = GetItems(Id, VaultName, Exact);
            if (result.Length > 1)
            {
                throw new PSAdminException(PSAdminExceptionType.QuotaExceeded, VaultName, "VaultName");
            }

            if (result.Length == 0)
            {
                throw new PSAdminException(PSAdminExceptionType.ItemNotFoundLookup, VaultName, "VaultName");
            }

            return result[0];
        }
        public static Data.KeyVault[] GetItems(string Id, string VaultName, bool Exact)
        {
            string filter;

            Hashtable filterTable = new Hashtable {
                {"Id",                  Id},
                {"VaultName",           VaultName },
            };

            filter = SQLiteDB.Filter(filterTable, Exact);
            Data.KeyVault[] result = SQLiteDB.ConvertToType<Data.KeyVault[]>(
                SQLiteDB.GetRow(TableName, filter)
            );

            return result;
        }

        internal static Data.KeyVault[] GetItemsThrow(string Id, string VaultName, bool Exact)
        {
            Data.KeyVault[] result = GetItems(Id, VaultName, Exact);

            if ((Exact) && (result.Length == 0))
            {
                throw new PSAdminException(PSAdminExceptionType.ItemNotFoundLookup, VaultName, "VaultName");
            }

            return result;
        }

        public static bool ItemExists(string Id, string VaultName, bool Exact)
        {
            Data.KeyVault[] result = GetItems(Id, VaultName, Exact);
            if (result.Length == 0)
            {
                return false;
            }
            return true;
        }
        
        internal static void ThrowIfItemExists(string Id, string VaultName, bool Exact)
        {
            if (ItemExists(Id, VaultName, Exact))
            {
                throw new PSAdminException(PSAdminExceptionType.ItemExists, VaultName, "VaultName");
            }
        }
        internal static void ThrowIfItemNotExists(string Id, string VaultName, bool Exact)
        {
            if (!ItemExists(Id, VaultName, Exact))
            {
                throw new PSAdminException(PSAdminExceptionType.ItemNotFoundLookup, VaultName, "VaultName");
            }
        }

        #endregion GetItem

        #region SetItem
        public static bool SetItem(string Id, string VaultName, string Location, string VaultURI, bool SoftDeleteEnabled, string[] Tags, bool Exact)
        {
            Data.KeyVault result = GetItem(Id, VaultName, Exact);
            if (result == null) {
                return false;
            }
            return SetItems(Id, VaultName, Location, VaultURI, SoftDeleteEnabled, Tags, Exact);
        }

        internal static bool SetItemThrow(string Id, string VaultName, string Location, string VaultURI, bool SoftDeleteEnabled, string[] Tags, bool Exact)
        {
            Data.KeyVault result = GetItemThrow(Id, VaultName, Exact);
            if (result == null) {
                return false;
            }
            return SetItemsThrow(Id, VaultName, Location, VaultURI, SoftDeleteEnabled, Tags, Exact);
        }
        public static bool SetItems(string Id, string VaultName, string Location, string VaultURI, bool SoftDeleteEnabled, string[] Tags, bool Exact)
        {
            Hashtable filter = new Hashtable {
                {"Id",                  Id },
                {"VaultName",           VaultName }
            };

            Hashtable table = new Hashtable {
                {"Location",            Location },
                {"VaultURI",            VaultURI },
                {"SoftDeleteEnabled",   SoftDeleteEnabled}
            };

            if (Tags != null)
                table.Add("Tags",                 String.Join(";", Tags));

            return SQLiteDB.UpdateRow(TableName, table, filter, Exact);
        }
        internal static bool SetItems(Hashtable row, Hashtable filter, bool Exact)
        {
            return SQLiteDB.UpdateRow(TableName, row, filter, Exact);
        }

        internal static bool SetItemsThrow(string Id, string VaultName, string Location, string VaultURI, bool SoftDeleteEnabled, string[] Tags, bool Exact)
        {
            bool issuccessful = SetItems(Id, VaultName, Location, VaultURI, SoftDeleteEnabled, Tags, Exact);
            if (!issuccessful)
            {
                throw new PSAdminException(PSAdminExceptionType.RowUpdate);
            }
            return true;
        }
        internal static bool SetItemsThrow(Hashtable row, Hashtable filter, bool Exact)
        {
            bool issuccessful = SQLiteDB.UpdateRow(TableName, row, filter, Exact);
            if (!issuccessful)
            {
                throw new PSAdminException(PSAdminExceptionType.RowUpdate);
            }
            return true;
        }
        #endregion SetItem

        #region RemoveItem
        public static bool RemoveItem(string Id, string VaultName, bool Exact)
        {
            Data.KeyVault result = GetItem(Id, VaultName, Exact);
            if (result == null) {
                return false;
            }
            return RemoveItems(Id, VaultName, Exact);
        }

        public static bool RemoveItemThrow(string Id, string VaultName, bool Exact)
        {
            Data.KeyVault result = GetItemThrow(Id, VaultName, Exact);
            if (result == null) {
                return false;
            }
            return RemoveItemsThrow(Id, VaultName, Exact);
        }
        public static bool RemoveItems(string Id, string VaultName, bool Exact)
        {
            string filter;

            Hashtable filterTable = new Hashtable {
                {"Id",                  Id},
                {"VaultName",           VaultName },
            };

            filter = SQLiteDB.Filter(filterTable, Exact);

            return SQLiteDB.RemoveRow(TableName, filter);
        }
        internal static bool RemoveItemsThrow(string Id, string VaultName, bool Exact)
        {
            bool IsSuccessful = RemoveItems(Id, VaultName, Exact);
            if (!IsSuccessful)
            {
                throw new PSAdminException(PSAdminExceptionType.RowDelete);
            }
            return true;
        }

        #endregion

        #region Other

        internal static byte[] GetVaultKey(string VaultName)
        {
            Data.KeyVault KeyVault = KeyVaultHelper.GetItemThrow(null, VaultName, true);

            if ( String.IsNullOrEmpty(KeyVault.Thumbprint) )
                return KeyVault.VaultKey;
            
            Data.KeyVaultCertificate Certificate = KeyVaultCertificateHelper.GetItemThrow(null, VaultName, null, KeyVault.Thumbprint, null, true, true);

            // Decrypt the Key
            X509Certificate2 x509 = (X509Certificate2)Certificate.Certificate;

            if ((x509.HasPrivateKey == false) || (x509.PrivateKey == null))
			{
                throw new InvalidOperationException("Certificate does not contain PrivateKey");
			}
            return ((RSACryptoServiceProvider)x509.PrivateKey).Decrypt(KeyVault.VaultKey, true);
        }

        #endregion
    }

}