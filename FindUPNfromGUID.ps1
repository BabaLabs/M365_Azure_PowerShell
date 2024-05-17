# Import the AzureAD module
Import-Module AzureAD

# Connect to Azure AD. It will prompt for credentials
Connect-AzureAD

# Specify the ObjectId
$objectId = "your-object-id-here"

# Get the Azure AD user associated with the ObjectId
$user = Get-AzureADUser -ObjectId $objectId

# Output the UserPrincipalName
$user.UserPrincipalName
