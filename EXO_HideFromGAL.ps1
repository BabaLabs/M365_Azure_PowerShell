#######################################################################################
# This script is used to hide a specific mailbox from the Global Address List in O365 #
#######################################################################################

# Prompt for the O365 admin email address
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

# Try to connect to Exchange Online using the provided admin email address
try {
    Write-Host "Attempting to connect to Exchange Online with the provided admin account..."
    Connect-ExchangeOnline -UserPrincipalName $AdminAccount -ErrorAction Stop
}
catch {
    Write-Host "An error occurred while connecting to Exchange Online: $_"
    Pause
    exit
}

# Once connected, prompt for the email address of the user to hide from GAL
$emailAddress = Read-Host -Prompt 'Enter the email address of the user you want to hide from GAL'

# Try to hide the specified user from GAL
try {
    Write-Host "Attempting to hide the user from the Global Address List..."
    Set-Mailbox -Identity $emailAddress -HiddenFromAddressListsEnabled $true -ErrorAction Stop
    Write-Host "Successfully hid the user from the Global Address List!"
}
catch {
    Write-Host "An error occurred while attempting to hide the user from the Global Address List: $_"
}

# Prompt to close the script
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
