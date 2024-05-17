$AdminAccount = Read-Host "Please enter the O365 Admin email address"

Connect-ExchangeOnline -UserPrincipalName $AdminAccount

# Prompt for mailbox email address
$mailbox = Read-Host "Enter the email address of the mailbox"

# Fetch and display inbox rules
try {
    $rules = Get-InboxRule -Mailbox $mailbox

    if($rules.Count -eq 0) {
        Write-Host "No rules found for mailbox: $mailbox"
    } else {
        Write-Host "Listing rules for mailbox: $mailbox"
        $rules | Format-Table Name, Description, Enabled, Priority
    }
} catch {
    Write-Error "Error retrieving rules for mailbox: $mailbox. Error: $_"
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false

# Prompt user to close the script
Read-Host "Press Enter to close the script"