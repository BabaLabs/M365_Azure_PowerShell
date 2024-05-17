#This script is used to give Editor Delegation to a Calendar in O365/Exchange

#This prompts the user for the O365 Admin email address and begins a sign-in request for that account to Connect to Exchange Online PowerShell
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

Connect-ExchangeOnline -UserPrincipalName $AdminAccount

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#This prompts the user for the email address of the account being shared with others
$TargetCalendar = Read-Host "Please enter the email address of the calendar that is BEING SHARED"

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#This prompts the user for the email address of the account that is getting the delegate access
$DelegateAccount = Read-Host "Please enter the email address of the user GETTING ACCESS to the calendar"

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#This command changes the calendar permissions of the account provided so the delegate can have Editor rights to the mailbox
Add-MailboxFolderPermission -Identity ${TargetCalendar}:\Calendar -User $DelegateAccount -AccessRights Editor -SharingPermissionFlags -Delegate

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#This serves just as a visible confirmation that the command worked
Write-Output 'Delegate access for mailbox '${TargetCalendar}' has been given to '${DelegateAccount}''

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
