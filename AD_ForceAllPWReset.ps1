# Import the required module
Import-Module ActiveDirectory

# Get all users
$users = Get-ADUser -Filter {Enabled -eq $true}

# Loop through each user and force a password reset at next login
foreach($user in $users)
{
    Set-ADUser -Identity $user.SamAccountName -ChangePasswordAtLogon $true
}
