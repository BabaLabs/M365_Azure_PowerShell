############################################################################################################
#   This script is used to generate a Content Search in the Compliance PowerShell Module that will         #
#        search messages matching criteria provided and then delete all messages from the org              #
############################################################################################################

#Prompts user for O365 admin account                            
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

#Connects to ExchangeOnline using the provided credentials, and prompts for password/MFA
Connect-IpPSSession -UserPrincipalName $AdminAccount

# Prompt the user for search criteria
$SearchName = Read-Host "Enter the Compliance Search name:"
$SendingEmail = Read-Host "Enter the sender email address:"
$Subjects = Read-Host "Enter the subject lines separated by commas:"
$StartDate = Read-Host "Enter the start date (MM/DD/YYYY):"
$EndDate = Read-Host "Enter the end date (MM/DD/YYYY):"

# Format the dates for the Content Match Query
$FormattedStartDate = (Get-Date $StartDate).ToString("yyyy-MM-ddTHH:mm:ss")
$FormattedEndDate = (Get-Date $EndDate).ToString("yyyy-MM-ddTHH:mm:ss")

# Split the subjects string into an array
$SubjectsArray = $Subjects -split ','

# Create the subject queries
$SubjectQueries = $SubjectsArray | ForEach-Object { "Subject:`"$_`"" }

# Combine all subject queries
$AllSubjectQueries = $SubjectQueries -join ' OR '

# Create the Content Match Query
$ContentMatchQuery = "(Received:`"$FormattedStartDate..$FormattedEndDate`" AND From:`"$SendingEmail`" AND ($AllSubjectQueries))"

# Create the Compliance Search
$Search = New-ComplianceSearch -Name $SearchName -ExchangeLocation All -ContentMatchQuery $ContentMatchQuery

# Get the count of messages matching the search criteria
$MessageCount = Get-ComplianceSearch -Identity $Search.Identity | Select-Object -ExpandProperty MessageCount

# Display the breakdown of messages to be deleted
Write-Host "The following messages will be deleted:"
Write-Host "Search Name: $SearchName"
Write-Host "Sender: $SendingEmail"
Write-Host "Subject: $Subject"
Write-Host "Start Date: $StartDate"
Write-Host "End Date: $EndDate"
Write-Host "Total Messages: $MessageCount"

# Prompt the user for confirmation before proceeding with deletion
$Confirmation = Read-Host "Do you want to proceed with message deletion? (Y/N)"
if ($Confirmation -eq "Y" -or $Confirmation -eq "y") {
    # Create the Compliance Search Action to delete messages
    $SearchAction = New-ComplianceSearchAction -SearchName $Search.Name -Purge -PurgeType HardDelete

    # Start the Compliance Search Action
    $Action = Start-ComplianceSearchAction -Identity $SearchAction.Identity

    # Monitor the progress of the Compliance Search Action
    $Completed = $false
    while (-not $Completed) {
        $Action = Get-ComplianceSearchAction -Identity $Action.Identity
        $Status = $Action.Status

        if ($Status -eq "Completed" -or $Status -eq "Failed" -or $Status -eq "PartiallySucceeded") {
            $Completed = $true
        } else {
            $PercentComplete = $Action.PercentComplete
            Write-Progress -Activity "Message Deletion Progress" -Status "Status: $Status, Percent Complete: $PercentComplete%" -PercentComplete $PercentComplete
            Start-Sleep -Seconds 5
        }
    }

    Write-Host "Message deletion has been completed. Please check the results in the Compliance Search portal."
}
else {
    Write-Host "Message deletion has been canceled."
}
