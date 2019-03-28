using System;

using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Security;
using System.Security.Cryptography;

namespace PSAdmin.Internal
{

    public static class Crypto {
        
        public static byte[] Combine(params byte[][] arrays)
        {
            byte[] result;
            using (MemoryStream ms = new MemoryStream())
            {
                foreach (byte[] array in arrays)
                {
                    ms.Write( array, 0, array.Length);                    
                }
                result = ms.ToArray();
            }
            return result;
        }

        public static byte[] SplitAt(byte[] array, int StartPos, int Length)
        {
            if (Length == -1) {
                Length = array.Length - StartPos;
            }
            byte[] result = new byte[Length];
            Array.Copy(array, StartPos, result, 0, Length);

            return result;
        }

        public static byte[] ConvertToKeyVaultSecret( string plainText, Byte[] Key)
        {
            // Check arguments.
            if (plainText == null || plainText.Length <= 0)
                throw new ArgumentNullException("plainText");
            if (Key == null || Key.Length <= 0)
                throw new ArgumentNullException("Key");
            byte[] encrypted;

            // Create an Aes object
            // with the specified key and IV.
            using (Aes aesAlg = Aes.Create())
            {
                aesAlg.Key = Key;
                aesAlg.GenerateIV();
                
                //aesAlg.BlockSize = 128;

                // Create an encryptor to perform the stream transform.
                ICryptoTransform encryptor = aesAlg.CreateEncryptor(aesAlg.Key, aesAlg.IV);

                // Create the streams used for encryption.
                using (MemoryStream msEncrypt = new MemoryStream())
                {
                    using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
                    {
                        using (StreamWriter swEncrypt = new StreamWriter(csEncrypt))
                        {
                            //Write all data to the stream.
                            swEncrypt.Write(plainText);
                        }
                        encrypted = Combine( aesAlg.IV, msEncrypt.ToArray() );
                    }
                }
            }

            // Return the encrypted bytes from the memory stream.
            return encrypted;
        }
        public static string ConvertFromKeyVaultSecret(byte[] encText, byte[] Key)
        {
            // Check arguments.
            if (encText == null || encText.Length <= 0)
                throw new ArgumentNullException("cipherText");
            if (Key == null || Key.Length <= 0)
                throw new ArgumentNullException("Key");

            byte[] IV = SplitAt(encText, 0, 16);
            byte[] cipherText = SplitAt(encText, 16, -1);


            // Declare the string used to hold
            // the decrypted text.
            string plaintext = null;

            // Create an Aes object
            // with the specified key and IV.
            using (Aes aesAlg = Aes.Create())
            {
                aesAlg.Key = Key;
                aesAlg.IV = IV;

                //aesAlg.BlockSize = 128;

                // Create a decryptor to perform the stream transform.
                ICryptoTransform decryptor = aesAlg.CreateDecryptor(aesAlg.Key, aesAlg.IV);

                // Create the streams used for decryption.
                using (MemoryStream msDecrypt = new MemoryStream(cipherText))
                {
                    using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
                    {
                        using (StreamReader srDecrypt = new StreamReader(csDecrypt))
                        {

                            // Read the decrypted bytes from the decrypting stream
                            // and place them in a string.
                            plaintext = srDecrypt.ReadToEnd();
                        }
                    }
                }

            }

            return plaintext;            
        }
    }
}