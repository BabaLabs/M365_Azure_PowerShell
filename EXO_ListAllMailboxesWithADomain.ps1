# This script is used to get a list of all mailboxes that have a specific domain as the primary SMTP address

# Prompt the user for the O365 Admin email address
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

# Validate the admin email format
if ($AdminAccount -notmatch '^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$') {
    Write-Host "Invalid email format. Please enter a valid O365 Admin email address."
    exit
}

# Connect to Exchange Online PowerShell
try {
    Connect-ExchangeOnline -UserPrincipalName $AdminAccount
} catch {
    Write-Host "Failed to connect to Exchange Online. Please check the credentials and try again."
    exit
}

Write-Host 'Press any key to continue...'
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

# Loop to prompt the user for the domain they are wanting to search for with the Primary SMTP address
$validDomain = $false
while (-not $validDomain) {
    $AliasDomain = Read-Host "Please enter the domain of the alias you're searching"

    # Validate the domain format
    if ($AliasDomain -match '^[\w-]+\.[\w-]{2,}$') {
        $validDomain = $true
    } else {
        Write-Host "Invalid domain format. Please enter a valid domain (e.g., example.com)."
    }
}

# Run a search on the provided domain, searching for all accounts where the Primary SMTP address includes the domain
try {
    $users = Get-Mailbox -ResultSize Unlimited | Where-Object { $_.PrimarySmtpAddress -like "*@$AliasDomain" }
    
    # Export the results to a CSV file
    $csvFilePath = "C:\temp\aliasdomain.csv"
    $users | Export-Csv -Path $csvFilePath -NoTypeInformation
    
    # Notify the user that the list has been exported
    Write-Host "Here are the accounts that have that domain as an alias:"
    Write-Host "The list has been exported to $csvFilePath"
    
    # List all of the addresses immediately for reference
    $users
} catch {
    Write-Host "An error occurred while retrieving or exporting the mailboxes. Please check your inputs and try again."
}

# Pause at the end of the script to allow the user to view the completion message
Write-Host "Press Enter to exit."
Read-Host -Prompt "Press Enter to exit"
