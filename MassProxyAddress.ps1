#This script is used to change the proxyAddress attribute in Active Directory for several accounts at once
#
# NOTE - THIS CAN ONLY BE RUN WHEN ON THE DOMAIN CONTROLLER. YOU WILL NEED TO COPY/PASTE THIS INTO NOTEPAD
#        AND SAVE AS A .PS1 FILE
#
#This imports the ActiveDirectory module to be used in the session
Import-Module ActiveDirectory

#This creates a variable called $users which contains all of the email addresses you add below
$users = @(
    'user1@domain.com',
    'user2@domain.com',
    'user3@domain.com'
    # ... add more users as needed
)

#This command runs through each user in the $users variable and changes the SMTP proxyAddress to what is added below
foreach ($userPrincipalName in $users) {
    $adUser = Get-ADUser -Filter "UserPrincipalName -eq '$userPrincipalName'" -Properties proxyAddresses

#   NOTE - YOU NEED TO UPDATE THE VALUE OF "@newdomain.com" TO BE THE DOMAIN OF THE CORRECT SMTP

    $newProxyAddress = "SMTP:" + $adUser.samAccountName + "@newdomain.com"
    Set-ADUser -Identity $adUser -Add @{proxyAddresses = $newProxyAddress}
}
