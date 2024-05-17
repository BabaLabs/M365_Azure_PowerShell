#This script is used to mass assign Editor calendar delegation in O365/Exchange
#
#Prompts User for O365 Admin credentials
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

#Connecting to ExchangeOnline PowerShell
Connect-ExchangeOnline -UserPrincipalName $AdminAccount

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#Prompts the user for the mailbox that is being shared, and stores it in the variable called $TargetMailbox
$TargetMailbox = Read-Host "Please enter the email address of the mailbox being shared with others"

#Generates a list of all UserMailboxes that have a license
$Users = Get-User -Filter {(ReciplientTypeDetails -eq 'UserMailbox') -and (IsLicensed -eq 'True')}

#Runs the Add-MailboxFolderPermission command on the $TargetMailbox variable for each person in the $Users list
foreach ($User in $Users) {
        $UserIdentity = $User.UserPrincipalName
        Add-MailboxFolderPermission -Identity "${TargetMailbox}:\Calendar" -User $UserIdentity -AccessRights Editor
}