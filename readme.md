## What is PSAdmin
PSAdmin is a PowerShell Designed toolkit for System Administrators to Easily Deploy and manage their Computer Systems.

## What it is now
Currently PSAdmin is a Database tool designed to handle your assets as cleanly and dynamically as possible.

### It's Experimental!
By far this is no where a complete project as it should evolve since the ambition for the project clearly outweighs what a single person's ambition can do on his spare time after work.

## PSAdmin Core Components

Note this is always changing and will change as features get added.

0. [PSAdmin][PSAdmin]
1. [PSAdminComputer][PSAdminComputer]
2. [PSAdminKeyVault][PSAdminKeyVault]
3. [PSAdminKeyVaultSecret][PSAdminKeyVaultSecret]
4. PSAdminKeyVaultCertificate (Documentation is coming)

[PSAdmin]: https://github.com/romero126/PSAdmin/blob/master/Docs/PSAdmin.md
[PSAdminComputer]: https://github.com/romero126/PSAdmin/blob/master/Docs/PSAdminComputer.md
[PSAdminKeyVault]: https://github.com/romero126/PSAdmin/blob/master/Docs/PSAdminKeyVault.md
[PSAdminKeyVaultSecret]: https://github.com/romero126/PSAdmin/blob/master/Docs/PSAdminKeyVaultSecret.md

## My Wishlist with this project
* [X] [KeyVault Storage][KeyVaultStorage] (Main Storage)
* [X] Certificate Storage
* [X] [Secret Storage][KeyVaultSecret]
* [X] [Computer Database][Computer]
    * [X] Store Credentials
    * [X] Remote Invoke / PSSession
    * [X] MSTSC / RDP
* [ ] Blob Storage
    * [ ] Should Storage be a thing?
* [ ] Key Storage
    * [ ] Store Environment Variables
* [ ] Workflow Execution for Automated Workflows
    * [ ] Ability to Quickly Audit Environment
    * [ ] Validate Service Health
    * [ ] Ingestion Tools for Loging
    * [ ] Ingestion
* [ ] Automated Dashboard 
* [ ] Automated Ingestion of Log Files to Tools like Kibana/Elstisearch
* [ ] This is brainstorming

[KeyVaultStorage]: https://github.com/romero126/PSAdmin/blob/master/Docs/PSAdminKeyVault.md
[KeyVaultSecret]: https://github.com/romero126/PSAdmin/blob/master/Docs/PSAdminKeyVaultSecret.md
[Computer]: https://github.com/romero126/PSAdmin/blob/master/Docs/PSAdminComputer.md