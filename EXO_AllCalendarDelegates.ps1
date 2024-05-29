############################################################################################################
#   This PowerShell script connects to Exchange Online, retrieves calendar permissions for all mailboxes,  #
#   and exports the information to a CSV file.                                                             #
############################################################################################################

# Import the Exchange Online Management Module
Write-Host "Importing the Exchange Online Management module..."
try {
    Import-Module ExchangeOnlineManagement -ErrorAction Stop
} catch {
    Write-Host "Failed to import the Exchange Online Management module. Please ensure it is installed and try again."
    exit
}

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

# Retrieve all mailboxes
Write-Host "Retrieving all mailboxes..."
try {
    $mailboxes = Get-ExoMailbox -ResultSize Unlimited -ErrorAction Stop
} catch {
    Write-Host "Failed to retrieve mailboxes. Please check your connection and try again."
    Disconnect-ExchangeOnline -Confirm:$false
    exit
}

# Create an array to store permissions
$permissions = @()

# Iterate over each mailbox
foreach ($mailbox in $mailboxes) {
    Write-Host "Processing mailbox: $($mailbox.PrimarySmtpAddress)..."
    try {
        # Get all calendar permissions for the current mailbox
        $calendarPermissions = Get-ExoMailboxFolderPermission -Identity ($mailbox.PrimarySmtpAddress.ToString() + ":\Calendar") -ErrorAction Stop

        # Iterate over each calendar permission
        foreach ($calendarPermission in $calendarPermissions) {
            # Create a new object for the current permission
            $permission = New-Object PSObject
            $permission | Add-Member -MemberType NoteProperty -Name "Mailbox" -Value $mailbox.PrimarySmtpAddress.ToString()
            $permission | Add-Member -MemberType NoteProperty -Name "User" -Value $calendarPermission.User.ToString()
            $permission | Add-Member -MemberType NoteProperty -Name "AccessRights" -Value ($calendarPermission.AccessRights -join ', ')

            # Add the new permission to the array
            $permissions += $permission
        }
    } catch {
        Write-Host "Failed to retrieve calendar permissions for mailbox: $($mailbox.PrimarySmtpAddress). Skipping..."
        continue
    }
}

# Define the path for the CSV file
$csvPath = "C:\Temp\CalendarPermissions.csv"

# Export the permissions to a CSV file
Write-Host "Exporting results to $csvPath..."
try {
    $permissions | Export-Csv -Path $csvPath -NoTypeInformation -ErrorAction Stop
    Write-Host "Export completed. The CSV file can be found at $csvPath"
} catch {
    Write-Host "Failed to export results to CSV. Please check the file path and try again."
    Disconnect-ExchangeOnline -Confirm:$false
    exit
}

# Disconnect from Exchange Online
Write-Host "Disconnecting from Exchange Online..."
try {
    Disconnect-ExchangeOnline -Confirm:$false
} catch {
    Write-Host "Failed to disconnect from Exchange Online. Please close the session manually."
}

# Pause at the end of the script to allow the user to view the completion message
Write-Host "Press Enter to exit."
Read-Host -Prompt "Press Enter to exit"
