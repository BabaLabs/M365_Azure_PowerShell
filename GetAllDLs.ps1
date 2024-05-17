#This prompts the user for the O365 Admin email address and begins a sign-in request for that account to Connect to Exchange Online PowerShell
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

Connect-ExchangeOnline -UserPrincipalName $AdminAccount

# Prepare an empty array to hold the results
$allDistributionsWithMembers = @()

# Get all distribution groups
$allDistributionGroups = Get-DistributionGroup

# Iterate over each group to get its members
foreach ($group in $allDistributionGroups) {
    # Get the members of the current group
    $members = Get-DistributionGroupMember -Identity $group.Identity

    # Iterate over each member to create a custom object with necessary properties
    foreach ($member in $members) {
        $distroMemberInfo = New-Object PSObject -Property @{
            GroupName       = $group.DisplayName
            GroupEmailAddress = $group.PrimarySmtpAddress
            MemberName      = $member.DisplayName
            MemberEmailAddress = $member.PrimarySmtpAddress
        }

        # Add the custom object to the array
        $allDistributionsWithMembers += $distroMemberInfo
    }
}

# Define the path for the CSV file
$csvPath = "C:\temp\AllDLs.csv"

# Export the results to a CSV file
$allDistributionsWithMembers | Export-Csv -Path $csvPath -NoTypeInformation

# Confirmation message
Write-Host "Export completed. The CSV file can be found at $csvPath"

# Disconnect the session
Disconnect-ExchangeOnline -Confirm:$false