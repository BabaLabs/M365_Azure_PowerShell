###############################################################################################################
#        NOTE - Please make sure to read through the comments to see what additional actions are required     #
# This script is used to change the proxyAddress attribute in Active Directory for several accounts at once   #
#       ALSO NOTE - THIS CAN ONLY BE RUN WHEN ON THE DOMAIN CONTROLLER - DOES NOT CONNECT TO O365             #
###############################################################################################################

#This imports the ActiveDirectory module to be used in the session
Import-Module ActiveDirectory

# This creates a variable called $users which contains all of the email addresses you add below
# NOTE - You will need to add the list of uers down below, following the syntax as shown. Extra space given to add more

$users = @(
    'user1@domain.com',
    'user2@domain.com',
    'user3@domain.com'
    
)

# This command runs through each user in the $users variable and changes the SMTP proxyAddress to what is added below
foreach ($userPrincipalName in $users) {
    $adUser = Get-ADUser -Filter "UserPrincipalName -eq '$userPrincipalName'" -Properties proxyAddresses

#   NOTE - YOU NEED TO UPDATE THE VALUE OF "@newdomain.com" BELOW TO BE THE DOMAIN YOU ARE WANTING

    $newProxyAddress = "SMTP:" + $adUser.samAccountName + "@newdomain.com"
    Set-ADUser -Identity $adUser -Add @{proxyAddresses = $newProxyAddress}
}
