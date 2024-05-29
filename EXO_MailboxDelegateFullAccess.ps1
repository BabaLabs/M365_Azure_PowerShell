#This script is used to give Full Access Delegation to a Mailbox in O365/Exchange

#This prompts the user for the O365 Admin email address and begins a sign-in request for that account to Connect to Exchange Online PowerShell
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

Connect-ExchangeOnline -UserPrincipalName $AdminAccount

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#This prompts the user for the email address of the mailbox that is being shared and stores it in the variable $TargetMailbox
$TargetMailbox = Read-Host "Please enter the email address of the mailbox that is BEING SHARED"

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#This prompts the user for the email address of the mailbox that is getting the delegate access and stores it in the variable $DelegateAccount
$DelegateAccount = Read-Host "Please enter the email address of the user GETTING ACCESS to the mailbox"

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#This command calls both variables created earlier and gives $DelegateAccount Full Access permissions to $TargetMailbox
Add-MailboxPermission -Identity ${TargetMailbox} -User $DelegateAccount -AccessRights FullAccess -InheritanceType All

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#This is visual confirmation that the command worked properly
Write-Output 'Delegate access for mailbox '${TargetMailbox}' has been given to '${DelegateAccount}''

#This prompts the user to press and key and close the script when ready
Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
