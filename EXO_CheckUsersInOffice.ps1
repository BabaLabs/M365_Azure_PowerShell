########################################################################################
# This script is used to show how many users are in a specific Office in O365/Exchange #
########################################################################################

#Prompts User for O365 Admin credentials
$AdminAccount = Read-Host "Please enter the O365 Admin email address"
Write-Host "Please press Enter..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Connect-ExchangeOnline -UserPrincipalName $AdminAccount

#This prompts the user for the Office number they are checking on
#It will list how many users are in that office, as well as list them all
do {$TargetOffice = Read-Host "Please enter the Office that you are checking on"`

Write-Host 'Press any key to continue...'; `
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

Write-Host 'This Office has this many users:'; `

$users = Get-User -Filter "Office -eq $TargetOffice"
foreach ($user in $users) {
    Write-Host $user.DisplayName
}

(Get-User -Filter "Office -eq $TargetOffice").User.Count | Format-List

Write-Host 'Press any key to continue...'; `
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#Below is a looping menu where the user can go back and repeat steps if they are checking multiple offices
#Loop will run until 2 is selected, in which case the script will end
function Show-Menu
{
param (
[string]$Title = 'Confirmation Menu'
)
Clear-Host
Write-Host "================ $Title ================"

Write-Host "Do you need to check any other offices?"
Write-Host "1: Press '1' to check more."
Write-Host "2: Press '2' to quit."
}
Show-Menu
$selection = Read-Host "Please make your selection"
switch ($selection)
{
    '1' {
        'Checking another office'
    } '2' {
        'Closing script.'
    }
}
pause
} until ($selection -eq '2' )
