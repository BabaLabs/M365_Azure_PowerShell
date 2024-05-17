$AdminAccount = Read-Host "Please enter the O365 Admin email address"`

Connect-ExchangeOnline -UserPrincipalName $AdminAccount

Write-Host 'Press any key to continue...';`
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

$TargetMailbox = Read-Host "Please enter the email address of the mailbox that is BEING SHARED"`

Write-Host 'Press any key to continue...';`
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

$DelegateAccount = Read-Host "Please enter the email address of the user GETTING ACCESS to the mailbox"`

Write-Host 'Press any key to continue...';`
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

Add-MailboxPermission -Identity $TargetMailbox -User $DelegateAccount -AccessRights FullAccess -InheritanceType All -Automapping $false`

Write-Host 'Press any key to continue...';`
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

Write-Output 'Outlook Auto-Mapping for mailbox '${TargetMailbox}' has been disabled for '${DelegateAccount}''`

Write-Host 'Press any key to continue...';`
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');