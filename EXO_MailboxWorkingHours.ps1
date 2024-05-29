#########################################################################
# This script is used to modify the Working Hours for a mailbox in O365 #
#########################################################################

#Prompts the user for the O365 Admin account
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

Connect-ExchangeOnline -UserPrincipalName $AdminAccount

# Prompt for resource room email address
$RoomEmailAddress = Read-Host -Prompt 'Enter the email address of the resource room'

# Prompt for working hours start time
$StartTime = Read-Host -Prompt 'Enter the working hours start time (HH:MM:SS)'

# Prompt for working hours end time
$EndTime = Read-Host -Prompt 'Enter the working hours end time (HH:MM:SS)'

# Import required assemblies for Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Create and configure the CheckedListBox
$checkedListBox = New-Object System.Windows.Forms.CheckedListBox
$checkedListBox.Width = 200
$checkedListBox.Height = 120
[void]$checkedListBox.Items.Add("Monday")
[void]$checkedListBox.Items.Add("Tuesday")
[void]$checkedListBox.Items.Add("Wednesday")
[void]$checkedListBox.Items.Add("Thursday")
[void]$checkedListBox.Items.Add("Friday")
[void]$checkedListBox.Items.Add("Saturday")
[void]$checkedListBox.Items.Add("Sunday")

# Create and configure the button
$button = New-Object System.Windows.Forms.Button
$button.Text = "OK"
$button.Width = 60
$button.Height = 30
$button.Top = 130
$button.Left = 70
$button.DialogResult = [System.Windows.Forms.DialogResult]::OK

# Create and configure the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Select Working Days"
$form.Width = 250
$form.Height = 220
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.AcceptButton = $button

# Add controls to the form
$form.Controls.Add($checkedListBox)
$form.Controls.Add($button)

# Show the form and get the result
$result = $form.ShowDialog()

# Process the result
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $DaysOfWeek = $checkedListBox.CheckedItems -join ","
}

# Continue with the rest of your script, using $DaysOfWeek as the selected days

# Time zone selection loop
do {
    Write-Host "Select a time zone:"
    Write-Host "1) Pacific Standard Time"
    Write-Host "2) Mountain Standard Time"
    Write-Host "3) Central Standard Time"
    Write-Host "4) Eastern Standard Time"

    $TimeZoneChoice = Read-Host -Prompt 'Enter the number corresponding to your choice'

    # Convert choice to time zone
    $TimeZone = switch ($TimeZoneChoice) {
        '1' { "Pacific Standard Time" }
        '2' { "Mountain Standard Time" }
        '3' { "Central Standard Time" }
        '4' { "Eastern Standard Time" }
        default { $null }
    }

    if ($null -eq $TimeZone) {
        Write-Host "Invalid choice. Please try again."
    }
} while ($null -eq $TimeZone)

# Set working hours
Set-MailboxCalendarConfiguration -Identity $RoomEmailAddress -WorkingHoursStartTime $StartTime -WorkingHoursEndTime $EndTime -WorkingHoursTimeZone $TimeZone -WorkDays $DaysOfWeek

# Inform the user
Write-Host "Working hours for $RoomEmailAddress have been updated."

# Disconnect
Disconnect-ExchangeOnline -Confirm:$false

# Pause before exiting
Read-Host -Prompt "Press Enter to exit"
