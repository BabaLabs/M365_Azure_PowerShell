#This script is used to disable OWA access for all users in a tenant

#Prompts User for O365 Admin credentials
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

Connect-ExchangeOnline -UserPrincipalName $AdminAccount

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#This command pulls a list of all mailboxes within the organization and disables OWA access
Get-Mailbox -ResultSize Unlimited | Set-CASMailbox -OWAEnabled $false

#This is just visual confirmation that the script ran
Write-Output 'OWA Access has been disabled for all users in the organization'
