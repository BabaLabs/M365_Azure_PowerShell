# Import Active Directory Module in case it's not already imported
Import-Module ActiveDirectory

# Prompt for the path of the CSV file containing user emails
$csvPath = Read-Host -Prompt "Enter the path of the CSV file containing user emails"

# Read the CSV file. Each line is treated as a single value (email address)
$emails = Get-Content -Path $csvPath

# Loop through each email address
foreach ($emailAddress in $emails) {
    # Skip empty lines
    if ([string]::IsNullOrWhiteSpace($emailAddress)) {
        continue
    }

    # Extract username from email address
    $username = $emailAddress.Split('@')[0]

    # Find the user based on email address in Active Directory
    $adUser = Get-ADUser -Filter { EmailAddress -eq $emailAddress } -Properties EmailAddress

    # Check if the user was found
    if ($adUser) {
        # Modify the msExchHideFromAddressLists attribute and mailNickname attribute
        Set-ADUser -Identity $adUser.DistinguishedName -Replace @{msExchHideFromAddressLists=$true; mailNickname=$username}
        Write-Host "User $($adUser.SamAccountName) with email $emailAddress has been hidden from GAL and mailNickname set to $username."
    } else {
        Write-Host "No user found with the email address: $emailAddress"
    }
}

Write-Host "Script execution completed."

# Pause and wait for user input before closing the script
Write-Host "Press any key to close the script..."
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
