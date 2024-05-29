#This script is used to disable legacy email protocols in O365/Exchange. This should only be used when requested by customers

#This prompts the user for the O365 Admin email address and begins a sign-in request for that account to Connect to Exchange Online PowerShell
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

Connect-ExchangeOnline -UserPrincipalName $AdminAccount

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#This command pulls a list of all mailboxes in the tenant and then disables SMTP authentication, POP, and IMAP
Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -SmtpClientAuthenticationDisabled $true -PopEnabled $false -ImapEnabled $false
