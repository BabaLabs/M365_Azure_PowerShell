#This script is used to disable Quarantine notifications in O365/Exchange

#This prompts the user for the O365 Admin email address and begins a sign-in request for that account to Connect to Exchange Online PowerShell
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

Connect-ExchangeOnline -UserPrincipalName $AdminAccount

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#This creates a variable called $AllUserMailboxes and searches for all UserMailbox recipients. The results are stored in the variable
$AllUserMailboxes = Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq 'UserMailbox'}

#This command runs through every mailbox stored in the $AllUserMailboxes variable, and disables Quarantine notifications for each one
foreach ($UserMailbox in $AllUserMailboxes) {
    Set-QuarantineNotification -Identity $UserMailbox.PrimarySmtpAddress -Enabled $false
}

#This is a prompt for the user to press Enter and close the script
#This is so they can confirm no errors before closing the script
Read-Host -Prompt "Press Enter to exit"
