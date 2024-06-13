# Import Active Directory Module in case they don't have it
Import-Module ActiveDirectory

# Prompt for user's email address that you are changing
$emailAddress = Read-Host -Prompt "Enter the email address of the user"

# Extract username from email address and store it in a variable to use later
$username = $emailAddress.Split('@')[0]

# Find the user based on email address in Active Directory
$user = Get-ADUser -Filter { EmailAddress -eq $emailAddress } -Properties EmailAddress

# Check if the user was found
if ($user) {
    # Modify the msExchHideFromAddressLists attribute and mailNickname attribute
    Set-ADUser -Identity $user.DistinguishedName -Replace @{msExchHideFromAddressLists=$true; mailNickname=$username}
    Write-Host "User $($user.SamAccountName) with email $emailAddress has been hidden from GAL and mailNickname set to $username."
} else {
    Write-Host "No user found with the email address: $emailAddress"
}

Write-Host "Script execution completed."

# Pause and wait for user input before closing script
Write-Host "Press any key to close the script..."
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
