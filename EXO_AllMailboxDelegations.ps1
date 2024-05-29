#This script is used to get a list of all mailbox delegation settings and output the results to a CSV file

#This prompts the user for the O365 Admin email address and begins a sign-in request for that account to Connect to Exchange Online PowerShell
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

Connect-ExchangeOnline -UserPrincipalName $AdminAccount

# Output file path
$OutputFilePath = "C:\Temp\output.csv"

# Array to store mailbox delegations
$Delegations = @()

# Get all mailboxes in the organization
$mailboxes = Get-Mailbox -ResultSize Unlimited
$totalMailboxes = $mailboxes.Count
$currentMailboxIndex = 0

# Iterate through each mailbox
foreach ($mailbox in $mailboxes) {
    $currentMailboxIndex++
    Write-Host "Processing mailbox $currentMailboxIndex of $totalMailboxes..."

    # Get mailbox delegations
    $mailboxDelegations = Get-MailboxPermission -Identity $mailbox.DistinguishedName | Where-Object { $_.IsInherited -eq $false }

    foreach ($delegation in $mailboxDelegations) {
        $delegationObject = New-Object PSObject
        $delegationObject | Add-Member -MemberType NoteProperty -Name "Mailbox" -Value $mailbox.DisplayName
        $delegationObject | Add-Member -MemberType NoteProperty -Name "Delegate" -Value $delegation.User
        $delegationObject | Add-Member -MemberType NoteProperty -Name "AccessRights" -Value $delegation.AccessRights
        $delegationObject | Add-Member -MemberType NoteProperty -Name "DelegationType" -Value "Mailbox"
        $Delegations += $delegationObject
    }

    # Get calendar delegations
    $calendarDelegations = Get-MailboxFolderPermission -Identity $mailbox.DistinguishedName -FolderScope Calendar | Where-Object { $_.IsInherited -eq $false }

    foreach ($delegation in $calendarDelegations) {
        $delegationObject = New-Object PSObject
        $delegationObject | Add-Member -MemberType NoteProperty -Name "Mailbox" -Value $mailbox.DisplayName
        $delegationObject | Add-Member -MemberType NoteProperty -Name "Delegate" -Value $delegation.User
        $delegationObject | Add-Member -MemberType NoteProperty -Name "AccessRights" -Value $delegation.AccessRights
        $delegationObject | Add-Member -MemberType NoteProperty -Name "DelegationType" -Value "Calendar"
        $Delegations += $delegationObject
    }
    
    # Report progress
    $progress = [math]::Round(($currentMailboxIndex / $totalMailboxes) * 100)
    Write-Progress -Activity "Retrieving delegations" -Status "Progress: $progress% Complete" -PercentComplete $progress
}

# Export the results array to a CSV file
$Result | Export-Csv -Path $csvFilePath -NoTypeInformation

# Notify the user that the process is complete and the file location
Write-Host "Process completed."
Write-Host "Results have been exported to $OutputFilePath"

# Prompt the user to press Enter before closing the window
Write-Host "Press Enter to exit."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
