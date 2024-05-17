# Import the Exchange Online Management Module
Import-Module ExchangeOnlineManagement

$AdminAccount = Read-Host "Please enter the O365 Admin email address"

Connect-ExchangeOnline -UserPrincipalName $AdminAccount

# Get all mailboxes
$mailboxes = Get-ExoMailbox -ResultSize Unlimited

# Create an array to store permissions
$permissions = @()

# Iterate over each mailbox
foreach ($mailbox in $mailboxes) {
    # Get all calendar permissions for the current mailbox
    $calendarPermissions = Get-ExoMailboxFolderPermission -Identity ($mailbox.PrimarySmtpAddress.ToString() + ":\Calendar")

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
}

# Export the permissions to a CSV file
$permissions | Export-Csv -Path "C:\Temp\CalendarPermissions.csv" -NoTypeInformation

# Disconnect from Exchange Online
Disconnect-ExchangeOnline
