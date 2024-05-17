#This script is used to get a list of all mailboxes that have a specific domain as the primary SMTP address
#
#This prompts the user for the O365 Admin email address and begins a sign-in request for that account to Connect to Exchange Online PowerShell
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

Connect-ExchangeOnline -UserPrincipalName $AdminAccount

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#This prompts the user for the domain they are wanting to search for with the Primary SMTP address
$AliasDomain = Read-Host "Please enter the domain of the alias you're searching"

#This runs a search on the provided domain above, searching for all accounts where the Primary SMTP address includes the domain
$users = Get-Mailbox -ResultSize Unlimited | Where-Object { $_.PrimarySmtpAddress -like "*@$AliasDomain" } | Export-Csv -Path "C:\temp\aliasdomain.csv" -NoTypeInformation

#This lets the user know that the list has been exported to a CSV file
Write-Host "Here are the accounts that have that domain as an alias:"

#This lists all of the addresses immediately for reference, can help to determine if it worked or not
$users