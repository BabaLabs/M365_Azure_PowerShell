###################################################################################################
# This Active Directory script will change all user accounts and disable never expiring passwords #
###################################################################################################

# Import the required module
Import-Module ActiveDirectory

# Get all users
$users = Get-ADUser -Filter {Enabled -eq $true}

# Loop through each user and set PasswordNeverExpires to false
foreach($user in $users)
{
    Set-ADUser -Identity $user.SamAccountName -PasswordNeverExpires $false
}
