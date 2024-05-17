#This script is used to get a list of all mailboxes that have a specific domain as the primary SMTP address
#
#This prompts the user for the O365 Admin email address and begins a sign-in request for that account to Connect to Exchange Online PowerShell
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

Connect-ExchangeOnline -UserPrincipalName $AdminAccount

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

Get-Mailbox -Identity * | Where-Object {$_.EmailAddresses -like 'smtp:email@domain.com'} | Format-List Identity, EmailAddresses