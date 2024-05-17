Add-Type -AssemblyName System.Windows.Forms

Function Get-UserDate {
    $calendarForm = New-Object System.Windows.Forms.Form
    $calendarForm.Text = "Select a Date"
    $calendarForm.Width = 250
    $calendarForm.Height = 250

    $calendar = New-Object System.Windows.Forms.MonthCalendar
    $calendar.ShowTodayCircle = $true
    $calendar.MaxSelectionCount = 1

    $calendarForm.Controls.Add($calendar)
    $calendarForm.StartPosition = "CenterScreen"

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(75,175)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = "OK"
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $calendarForm.Controls.Add($OKButton)
    $calendarForm.AcceptButton = $OKButton

    $calendarForm.Add_Shown({ $calendarForm.Activate() })
    $result = $calendarForm.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        return $calendar.SelectionStart
    }
    else {
        return $null
    }
}

# Call the Get-UserDate function
$date = Get-UserDate
if ($date = $null) {
    Write-Host "You selected the date: $date" -ForegroundColor Green
} else {
    Write-Host "No date selected" -ForegroundColor Red
}