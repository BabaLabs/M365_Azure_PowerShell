# M365 Azure PowerShell Scripts

## Overview

This repository contains a collection of PowerShell scripts I've written to streamline operations within Microsoft 365, Azure, and Active Directory environments. The scripts are designed to automate common administrative tasks in a cloud operations setting.

## Features
- **Active Directory Automation**: Scripts for mass password resets, proxy address updates, and attribute retrieval.
- **Azure AD**: License management, UPN retrieval from GUIDs, and mass operations on user attributes.
- **Exchange Online**: Manage mailbox settings, delegation, retention policies, and calendar permissions.

## Scripts Included
- `AD_ForceAllPWExpire.ps1`: Force all Active Directory users' passwords to expire.
- `EXO_MailboxDelegateFullAccess.ps1`: Assign full mailbox delegation rights.
- `AzureAD_MassLicenseAssign.ps1`: Mass assign licenses to Azure AD users.

## Requirements
- PowerShell 7.0+
- AzureAD and ExchangeOnline PowerShell modules installed
  - To install: 
    ```bash
    Install-Module -Name AzureAD
    Install-Module -Name ExchangeOnlineManagement
    ```

## Usage
1. Clone this repository:
   ```bash
   git clone https://github.com/BabaLabs/M365_Azure_PowerShell.git
   ```
   Run the necessary script based on your operational needs. For example, to reset all AD passwords:
   ```bash
   ./AD_ForceAllPWReset.ps1
   ```

## Contributing
Feel free to open issues or submit pull requests to improve the scripts or add new features.
