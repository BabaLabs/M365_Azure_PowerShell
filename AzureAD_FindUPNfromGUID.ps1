############################################################################################################
#   This PowerShell script connects to Azure AD, retrieves a user based on the provided ObjectId,          #
#   and outputs the UserPrincipalName.                                                                     #
############################################################################################################

# Import the AzureAD module
Write-Host "Importing the AzureAD module..."
try {
    Import-Module AzureAD -ErrorAction Stop
} catch {
    Write-Host "Failed to import the AzureAD module. Please ensure it is installed and try again."
    exit
}

# Connect to Azure AD. It will prompt for credentials
Write-Host "Connecting to Azure AD..."
try {
    Connect-AzureAD -ErrorAction Stop
} catch {
    Write-Host "Failed to connect to Azure AD. Please check your credentials and try again."
    exit
}

# Prompt the user to enter the ObjectId
$objectId = Read-Host "Please enter the ObjectId of the Azure AD user"

# Validate the ObjectId format (basic validation for a GUID)
if ($objectId -notmatch '^[\w-]{8}-[\w-]{4}-[\w-]{4}-[\w-]{4}-[\w-]{12}$') {
    Write-Host "Invalid ObjectId format. Please enter a valid GUID."
    exit
}

# Get the Azure AD user associated with the ObjectId
Write-Host "Retrieving the Azure AD user for ObjectId: $objectId..."
try {
    $user = Get-AzureADUser -ObjectId $objectId -ErrorAction Stop
    if ($null -eq $user) {
        Write-Host "No user found with ObjectId: $objectId."
        exit
    }
} catch {
    Write-Host "Failed to retrieve the user. Please check the ObjectId and try again."
    exit
}

# Output the UserPrincipalName
Write-Host "The UserPrincipalName for the user with ObjectId $objectId is: $($user.UserPrincipalName)"

# Pause at the end of the script to allow the user to view the output
Write-Host "Press Enter to exit."
Read-Host -Prompt "Press Enter to exit"
