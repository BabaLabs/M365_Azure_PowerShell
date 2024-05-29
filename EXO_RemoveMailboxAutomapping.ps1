############################################################################################################
# This PowerShell script connects to Exchange Online, assigns FullAccess permissions to a delegate for     #
# a shared mailbox, and disables AutoMapping for the delegate.                                             #
############################################################################################################

# Prompt the user for the O365 Admin email address
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

# Connect to Exchange Online PowerShell using the provided credentials, and prompt for password/MFA
Write-Host "Connecting to Exchange Online..."
try {
    Connect-ExchangeOnline -UserPrincipalName $AdminAccount -ErrorAction Stop
} catch {
    Write-Host "Failed to connect to Exchange Online. Please check your credentials and try again."
    exit
}

Write-Host 'Press any key to continue...'
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

# Prompt the user for the mailbox that is being shared
$TargetMailbox = Read-Host "Please enter the email address of the mailbox that is BEING SHARED"

# Validate the email format for the target mailbox
if ($TargetMailbox -notmatch '^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$') {
    Write-Host "Invalid email format. Please enter a valid email address for the shared mailbox."
    Disconnect-ExchangeOnline -Confirm:$false
    exit
}

Write-Host 'Press any key to continue...'
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

# Prompt the user for the delegate's email address
$DelegateAccount = Read-Host "Please enter the email address of the user GETTING ACCESS to the mailbox"

# Validate the email format for the delegate account
if ($DelegateAccount -notmatch '^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$') {
    Write-Host "Invalid email format. Please enter a valid email address for the delegate."
    Disconnect-ExchangeOnline -Confirm:$false
    exit
}

Write-Host 'Press any key to continue...'
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

# Assign FullAccess permissions to the delegate and disable AutoMapping
Write-Host "Assigning FullAccess permissions to $DelegateAccount for $TargetMailbox and disabling AutoMapping..."
try {
    Add-MailboxPermission -Identity $TargetMailbox -User $DelegateAccount -AccessRights FullAccess -InheritanceType All -Automapping $false -ErrorAction Stop
    Write-Output "Outlook Auto-Mapping for mailbox '$TargetMailbox' has been disabled for '$DelegateAccount', and FullAccess permissions have been added."
} catch {
    Write-Host "Failed to assign permissions or disable Auto-Mapping. Please check the provided email addresses and try again."
    Disconnect-ExchangeOnline -Confirm:$false
    exit
}

Write-Host 'Press any key to continue...'
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

# Disconnect from Exchange Online
Write-Host "Disconnecting from Exchange Online..."
try {
    Disconnect-ExchangeOnline -Confirm:$false
} catch {
    Write-Host "Failed to disconnect from Exchange Online. Please close the session manually."
}

# Pause at the end of the script to allow the user to view the completion message
Write-Host "Press Enter to exit."
Read-Host -Prompt "Press Enter to exit"
