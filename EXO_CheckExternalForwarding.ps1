############################################################################################################
#   This PowerShell script checks all mailboxes in your Exchange environment to see if they are            #
#   forwarding emails to an external domain. If they are, it logs the mailbox and the external recipient   #
#   in a CSV file.                                                                                         #
############################################################################################################

# Define the path for the CSV file
$csvFilePath = "C:\temp\ExternalForward.csv"

# Connect to Exchange Online
Write-Host "Connecting to Exchange Online..."
try {
    Connect-ExchangeOnline
} catch {
    Write-Host "Failed to connect to Exchange Online. Please check your credentials and try again."
    exit
}

# Retrieve all mailboxes
Write-Host "Retrieving all mailboxes..."
try {
    $mailboxes = Get-Mailbox -ResultSize Unlimited
} catch {
    Write-Host "Failed to retrieve mailboxes. Please check your connection and try again."
    exit
}

# Retrieve all accepted domains
Write-Host "Retrieving accepted domains..."
try {
    $domains = Get-AcceptedDomain
} catch {
    Write-Host "Failed to retrieve accepted domains. Please check your connection and try again."
    exit
}

# Initialize an array to store results
$results = @()

# Check each mailbox for forwarding to an external domain
foreach ($mailbox in $mailboxes) {
    Write-Host "Checking forwarding for $($mailbox.DisplayName) - $($mailbox.PrimarySmtpAddress)..."
    $forwardingSMTPAddress = $mailbox.ForwardingSmtpAddress
    if ($forwardingSMTPAddress) {
        $email = ($forwardingSMTPAddress -split "SMTP:")[1]
        $domain = ($email -split "@")[1]
        if ($domains.DomainName -notcontains $domain) {
            # Log the mailbox and the external recipient
            $externalRecipient = $email
            Write-Host "$($mailbox.DisplayName) - $($mailbox.PrimarySmtpAddress) forwards to $externalRecipient" -ForegroundColor Yellow
            $results += [PSCustomObject]@{
                PrimarySmtpAddress = $mailbox.PrimarySmtpAddress
                DisplayName        = $mailbox.DisplayName
                ExternalRecipient  = $externalRecipient
            }
        }
    }
}

# Export the results to a CSV file
try {
    Write-Host "Exporting results to $csvFilePath..."
    $results | Export-Csv -Path $csvFilePath -NoTypeInformation
    Write-Host "Results have been exported to $csvFilePath"
} catch {
    Write-Host "Failed to export results to CSV. Please check the file path and try again."
    exit
}

# Notify the user and prompt to exit
Write-Host "Script completed. The results are saved in $csvFilePath."
Write-Host "Press Enter to exit."
Read-Host -Prompt "Press Enter to exit"
