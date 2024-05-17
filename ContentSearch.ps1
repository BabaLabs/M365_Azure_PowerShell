#Prompts user for O365 admin account
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

#Connects to ExchangeOnline using the provided credentials, and prompts for password/MFA
Connect-ExchangeOnline -UserPrincipalName $AdminAccount

#Don't know why but the script makes you hit enter again after putting in the name so I let people know
Write-Host 'Press Enter to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#Put in the dates that you need, as well as the user mailbox affected in $User, and the recipient in $Domain. If you leave it *.domain.com it will wildcard search any sender in that domain.
#Subject field can have multiple values if comma-separated
$StartDate = "2013-01-01"
$EndDate = "2023-02-17"
$Domain = "*.domain.com"
$Subject = "subject"

#This command searches for all conversations between both $User and $Domain, accounting for inbound and outbound emails
New-ContentSearch -Name "Search for specific email" -SourceMailboxes "*" -StartDate $StartDate -EndDate $EndDate -SubjectContainsWords $Subject -SenderOrRecipientAddressContainsWords $Domain



#$User = "user@example.com"
#-SenderOrRecipientAddressContainsWords $User