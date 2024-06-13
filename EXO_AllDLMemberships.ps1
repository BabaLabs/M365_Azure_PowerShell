#############################################################################################################
#   This PowerShell script connects to Exchange Online, retrieves all distribution groups and their members #
#                              and exports the information to a CSV file.                                   #
#############################################################################################################

# Prompt the user for the O365 Admin email address and begin a sign-in request for that account
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

# Connect to Exchange Online PowerShell using the provided credentials, and prompt for password/MFA
Write-Host "Connecting to Exchange Online..."
try {
    Connect-ExchangeOnline -UserPrincipalName $AdminAccount -ErrorAction Stop
} catch {
    Write-Host "Failed to connect to Exchange Online. Please check your credentials and try again."
    exit
}

# Prepare an empty array to hold the results
$allDistributionsWithMembers = @()

# Retrieve all distribution groups
Write-Host "Retrieving all distribution groups..."
try {
    $allDistributionGroups = Get-DistributionGroup -ErrorAction Stop
} catch {
    Write-Host "Failed to retrieve distribution groups. Please check your connection and try again."
    Disconnect-ExchangeOnline -Confirm:$false
    exit
}

# Iterate over each group to get its members
foreach ($group in $allDistributionGroups) {
    Write-Host "Processing group: $($group.DisplayName)..."
    try {
        # Get the members of the current group
        $members = Get-DistributionGroupMember -Identity $group.Identity -ErrorAction Stop

        # Iterate over each member to create a custom object with necessary properties
        foreach ($member in $members) {
            $distroMemberInfo = New-Object PSObject -Property @{
                GroupName          = $group.DisplayName
                GroupEmailAddress  = $group.PrimarySmtpAddress
                MemberName         = $member.DisplayName
                MemberEmailAddress = $member.PrimarySmtpAddress
            }

            # Add the custom object to the array
            $allDistributionsWithMembers += $distroMemberInfo
        }
    } catch {
        Write-Host "Failed to retrieve members for group: $($group.DisplayName). Skipping..."
        continue
    }
}

# Define the path for the CSV file
$csvPath = "C:\temp\AllDLs.csv"

# Export the results to a CSV file
Write-Host "Exporting results to $csvPath..."
try {
    $allDistributionsWithMembers | Export-Csv -Path $csvPath -NoTypeInformation -ErrorAction Stop
    Write-Host "Export completed. The CSV file can be found at $csvPath"
} catch {
    Write-Host "Failed to export results to CSV. Please check the file path and try again."
    Disconnect-ExchangeOnline -Confirm:$false
    exit
}

# Disconnect the session
Write-Host "Disconnecting from Exchange Online..."
try {
    Disconnect-ExchangeOnline -Confirm:$false
} catch {
    Write-Host "Failed to disconnect from Exchange Online. Please close the session manually."
}

# Pause at the end of the script to allow the user to view the completion message
Write-Host "Press Enter to exit."
Read-Host -Prompt "Press Enter to exit"
