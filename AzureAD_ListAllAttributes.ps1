###################################################################################################
# This AzureAD/EntraID script will collect all attributes currently active/syncing to Azure and   #
#                                 export the results to a CSV file                                #
###################################################################################################

# Connect to Azure Active Directory
Connect-AzureAD

# Retrieve all Azure AD users
$Users = Get-AzureADUser -All $True

# Initialize an array to store the results
$Result = @()

# Loop through each user in the Users collection
for ($i=0; $i -lt $Users.Count; $i++) {
    $User = $Users[$i]

    # Display a progress bar in the console
    Write-Progress -Activity "Processing Users" -Status "Processing $($User.DisplayName)" -PercentComplete (($i / $Users.Count) * 100)

    # Get the manager's ObjectId for the current user
    $ManagerId = (Get-AzureADUserManager -ObjectId $User.ObjectId).ObjectId

    # If the user has a manager, retrieve the manager's details
    $ManagerDetails = if($ManagerId) { Get-AzureADUser -ObjectId $ManagerId }

    # Get the proxy addresses for the current user and join them into a single string
    $proxyAddresses = ($User | Select-Object -ExpandProperty ProxyAddresses) -join ", "

    # Create a custom PSObject with the desired properties and add it to the results array
    $Result += New-Object PSObject -Property @{
        ObjectId = $User.ObjectId
        ObjectType = $User.ObjectType
        DisplayName = $User.DisplayName
        UserPrincipalName = $User.UserPrincipalName
        Mail = $User.Mail
        MailNickName = $User.MailNickName
        Mobile = $User.Mobile
        GivenName = $User.GivenName
        Surname = $User.Surname
        AccountEnabled = $User.AccountEnabled
        UsageLocation = $User.UsageLocation
        StreetAddress = $User.StreetAddress
        City = $User.City
        State = $User.State
        PostalCode = $User.PostalCode
        Country = $User.Country
        JobTitle = $User.JobTitle
        Department = $User.Department
        Company = $User.Company
        ManagerDisplayName = $ManagerDetails.DisplayName
        ManagerUserPrincipalName = $ManagerDetails.UserPrincipalName
        ProxyAddresses = $proxyAddresses
    }
}

# Specify the CSV file path
$csvFilePath = "C:\Temp\Attributes.csv"

# Export the results array to a CSV file
$Result | Export-Csv -Path $csvFilePath -NoTypeInformation

# Notify the user that the process is complete and the file location
Write-Host "Process completed."
Write-Host "Results have been exported to $csvFilePath"

# Pause at the end of the script to allow the user to view the completion message
Write-Host "Press Enter to exit."
Read-Host -Prompt "Press Enter to exit"
