# This script will iterate through the list of groups/mailboxes specified below, and show all Users that do not have a value for the "Office" field #

# Define the email addresses you want to search, with word wrap for readability
$emailAddresses = @(
    "group1@example.com",
    "group2@example.com",
    "group3@example.com",
    "user1@example.com", # Example of a user email
    "group4@example.com"
)

# Connect to Exchange Online
Write-Host "Connecting to Exchange Online..."
$UserCredential = Get-Credential
Connect-ExchangeOnline -Credential $UserCredential

# Initialize an array to hold users with blank "Office" field and their group info
$results = @()

foreach ($email in $emailAddresses) {
    Write-Host "Processing: $email..."

    try {
        # Try to get the user
        $user = Get-User -Identity $email -ErrorAction Stop

        if ($user) {
            if ($user.Office -eq $null -or $user.Office -eq "") {
                $results += [PSCustomObject]@{
                    GroupOrUser = $email
                    DisplayName = $user.DisplayName
                    UserPrincipalName = $user.UserPrincipalName
                    Office = $user.Office
                }
            }
        }
    } catch {
        try {
            # If it's not a user, try to get the group
            $group = Get-DistributionGroup -Identity $email -ErrorAction Stop

            if ($group) {
                # Get the members of the group
                $members = Get-DistributionGroupMember -Identity $email

                foreach ($member in $members) {
                    # Retrieve the user object to check the Office field
                    $groupMember = Get-User -Identity $member.Alias

                    if ($groupMember.Office -eq $null -or $groupMember.Office -eq "") {
                        $results += [PSCustomObject]@{
                            GroupOrUser = $email
                            DisplayName = $groupMember.DisplayName
                            UserPrincipalName = $groupMember.UserPrincipalName
                            Office = $groupMember.Office
                        }
                    }
                }
            }
        } catch {
            Write-Host "$email is not a valid user or group, skipping..."
        }
    }
}

# Specify the CSV file path
$csvFilePath = "C:\temp\UsersWithBlankOffice.csv"

# Export the results to CSV
Write-Host "Exporting results to CSV..."
$results | Export-Csv -Path $csvFilePath -NoTypeInformation

# Notify the user
Write-Host "Process completed."
Write-Host "Results have been exported to $csvFilePath"

# Disconnect from Exchange Online
Write-Host "Disconnecting from Exchange Online..."
Disconnect-ExchangeOnline -Confirm:$false

# Prompt to press enter to exit
Write-Host "Press Enter to exit."
[void][System.Console]::ReadLine()
