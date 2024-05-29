#This script is used to mass remove Retention Holds in O365/Exchange
#
#Prompts User for O365 Admin credentials
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

Connect-ExchangeOnline -UserPrincipalName $AdminAccount

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#This command pulls a list of all UserMailbox in a tenant that also has a Retention Hold and then disables it
Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize unlimited | Where-Object { ($_.RetentionHoldEnabled -eq $true) } | Set-Mailbox -RetentionHoldEnabled $false
