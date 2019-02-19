##What is a KeyVault?

A Keyvault is a safe and secure way to store your Secret data at rest.

##How does it work?

A Keyvault will create a VaultKey (a Randomly Generated Value) that will be used to Secure your data.

This Key is stored plainly inside the database for safekeeping. This can be encrypted further by a certificate from the Certificate Store to actually make the data secure.

NOTE:
Certificates are not stored Encrypted.
KeyVaultSecrets are stored Encrypted.

Ok so it really wasnt that technical.



##Available Commands
1. [Get-PSAdminKeyVault][GetCommand] Gets a PSAdmin KeyVault.
2. [New-PSAdminKeyVault][NewCommand] Creates a PSAdmin KeyVault.
3. [Set-PSAdminKeyVault][SetCommand] Sets a Value in PSAdmin KeyVault.
4. [Remove-PSAdminKeyVault][RemoveCommand] Remove a PSAdmin KeyVault.
5. [Protect-PSAdminKeyVault][ProtectCommand] Protects a PSAdmin KeyVault.
6. [Unprotect-PSAdminKeyVault][UnprotectCommand] Unprotects PSAdmin KeyVault.
[GetCommand]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/PSAdminKeyVault/Get-PSAdminKeyVault.md
[NewCommand]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/PSAdminKeyVault/New-PSAdminKeyVault.md
[SetCommand]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/PSAdminKeyVault/Set-PSAdminKeyVault.md
[RemoveCommand]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/PSAdminKeyVault/Remove-PSAdminKeyVault.md
[ProtectCommand]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/PSAdminKeyVault/Protect-PSAdminKeyVault.md
[UnprotectCommand]: https://github.com/romero126/PSAdmin/blob/master/Docs/Commands/PSAdminKeyVault/Unprotect-PSAdminKeyVault.md