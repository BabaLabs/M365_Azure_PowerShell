############################################################################################################
# This script is used to mass assign Editor calendar permissions to a mailbox in O365/Exchange             #
############################################################################################################

# Prompt the user for O365 Admin email address and begin a sign-in request for that account
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

# Connect to Exchange Online PowerShell using the provided credentials, and prompt for password/MFA
Write-Host "Connecting to Exchange Online..."
try {
    Connect-ExchangeOnline -UserPrincipalName $AdminAccount -ErrorAction Stop
} catch {
    Write-Host "Failed to connect to Exchange Online."
    exit
}

Write-Host 'Press any key to continue...'
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

# Prompt the user for the mailbox that is being shared and store it in the variable called $TargetMailbox
$TargetMailbox = Read-Host "Please enter the email address of the mailbox being shared with others"

# Validate the email format
if ($TargetMailbox -notmatch '^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$') {
    Write-Host "Invalid email format. Please enter a valid email address."
    Disconnect-ExchangeOnline -Confirm:$false
    exit
}

# Generate a list of all UserMailboxes that have a license
Write-Host "Retrieving all licensed user mailboxes..."
try {
    $Users = Get-User -Filter {(RecipientTypeDetails -eq 'UserMailbox') -and (IsLicensed -eq $true)} -ErrorAction Stop
} catch {
    Write-Host "Failed to retrieve user mailboxes."
    Disconnect-ExchangeOnline -Confirm:$false
    exit
}

# Check if there are any users found
if ($Users.Count -eq 0) {
    Write-Host "No licensed user mailboxes found."
    Disconnect-ExchangeOnline -Confirm:$false
    exit
}

# Run the Add-MailboxFolderPermission command on the $TargetMailbox variable for each person in the $Users list
Write-Host "Assigning Editor calendar permissions to $TargetMailbox for each user mailbox..."
foreach ($User in $Users) {
    try {
        $UserIdentity = $User.UserPrincipalName
        Write-Host "Assigning Editor permission to $UserIdentity..."
        Add-MailboxFolderPermission -Identity "${TargetMailbox}:\Calendar" -User $UserIdentity -AccessRights Editor -ErrorAction Stop
    } catch {
        Write-Host "Failed to assign permissions for $UserIdentity. Skipping..."
        continue
    }
}

# Confirmation message
Write-Host "Permissions assignment completed."

# Disconnect from Exchange Online
Write-Host "Disconnecting from Exchange Online..."
try {
    Disconnect-ExchangeOnline -Confirm:$false
} catch {
    Write-Host "Failed to disconnect from Exchange Online. Please close the session manually."
}

# Pause at the end of the script to allow the user to view the completion message
Write-Host "Press Enter to exit."
Read-Host -Prompt "Press Enter to exit"
