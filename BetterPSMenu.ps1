#Prompt user for O365 admin credentials
$AdminAccount = Read-Host "Please enter the O365 Admin email address"

Connect-ExchangeOnline -UserPrincipalName $AdminAccount

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

function ShowMainMenu {
    while ($true) {
        Write-Host "Select an option:"
        Write-Host "1. Mailbox delegation"
        Write-Host "2. Calendar delegation"
        Write-Host "3. Additional options"
        Write-Host "4. Exit"
        $choice = Read-Host

        switch ($choice) {
            1 {
                Call "MailboxDelegationMenu"
            }
            2 {
                Call "CalendarDelegationMenu"
            }
            3 {
                Call "AdditionalOptionsMenu"
            }
            4 {
                # Exit script
                Write-Host "Exiting..."
                return
            }
            default {
                Write-Host "Invalid choice. Try again."
            }
        }
    }
}

function MailboxDelegationMenu {
    while ($true) {
        Write-Host "Select an option:"
        Write-Host "1. Add mailbox delegation"
        Write-Host "2. Remove mailbox delegation"
        Write-Host "3. View mailbox delegation"
        Write-Host "4. Back"
        $choice = Read-Host

        switch ($choice) {
            1 {
                while ($true) {
                    $TargetMailbox = Read-Host "Please enter the email address of the mailbox that is BEING SHARED"

                    Write-Host 'Press any key to continue...';
                    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

                    $DelegateAccount = Read-Host "Please enter the email address of the user GETTING ACCESS to the mailbox"

                    Write-Host 'Press any key to continue...';
                    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

                    Add-MailboxPermission -Identity ${TargetMailbox} -User $DelegateAccount -AccessRights FullAccess -InheritanceType All

                    Write-Host 'Press any key to continue...';
                    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

                    Write-Output 'Delegate access for mailbox '${TargetMailbox}' has been given to '${DelegateAccount}''

                    $choice = Read-Host "Do you want to add another mailbox delegation? (Y/N)"
                    if ($choice -ne "Y") {
                        break
                    }
                }
            }
            2 {
                RemoveMailboxDelegation
            }
            3 {
                ViewMailboxDelegation
            }
            4 {
                # Return to main menu
                return
            }
            default {
                Write-Host "Invalid choice. Try again."
            }
        }
    }
}

function CalendarDelegationMenu {
    while ($true) {
        Write-Host "Select an option:"
        Write-Host "1. Add calendar delegation"
        Write-Host "2. Remove calendar delegation"
        Write-Host "3. View calendar delegation"
        Write-Host "4. Back"
        $choice = Read-Host

        switch ($choice) {
            1 {
                AddCalendarDelegation
            }
            2 {
                RemoveCalendarDelegation
            }
            3 {
                ViewCalendarDelegation
            }
            4 {
                # Return to main menu
                return
            }
            default {
                Write-Host "Invalid choice. Try again."
            }
        }
    }
}

function AdditionalOptionsMenu {
    while ($true) {
        Write-Host "Select an option:"
        Write-Host "1. Placeholder for additional option 1"
        Write-Host "2. Placeholder for additional option 2"
        Write-Host "3. Back"
        $choice = Read-Host

        switch ($choice) {
            1 {
                Call "AdditionalOption1Menu"
            }
            2 {
                Call "AdditionalOption2Menu"
            }
            3 {
                # Return to main menu
                return
            }
            default {
                Write-Host "Invalid choice. Try again."
            }
        }
    }
}

# Placeholder for additional option 1 menu
function AdditionalOption1Menu {
    Write-Host "This is a placeholder for additional option 1 menu"
}

# Placeholder for additional option 2 menu
function AdditionalOption2Menu {
    Write-Host "This is a placeholder for additional option 2 menu"
}

function AddMailboxDelegation {
    # Prompt for user and delegate
    $user = Read-Host "Enter the email address of the user whose mailbox you want to delegate"
    $delegate = Read-Host "Enter the email address of the delegate"

    Add-MailboxPermission -Identity $user -User $delegate -AccessRights FullAccess
    Write-Host "Mailbox delegation added successfully!"
}

function RemoveMailboxDelegation {
    # Prompt for user and delegate
    $user = Read-Host "Enter the email address of the user whose mailbox delegation you want to remove"
    $delegate = Read-Host "Enter the email address of the delegate"

    Remove-MailboxPermission -Identity $user -User $delegate -AccessRights FullAccess
    Write-Host "Mailbox delegation removed successfully!"
}

function ViewMailboxDelegation {
    # Prompt for user
    $user = Read-Host "Enter the email address of the user whose mailbox delegation you want to view"

    # Get mailbox delegation for user
    $mailboxPermission = Get-MailboxPermission -Identity $user

    # Display mailbox delegation
    Write-Host "Mailbox delegation for ${user}:"
    foreach ($permission in $mailboxPermission) {
        if ($permission.IsInherited -eq $false) {
            Write-Host "Delegate: $($permission.User.ToString()), Access Rights: $($permission.AccessRights)"
        }
    }
}

function AddCalendarDelegation {
    # Prompt for user and delegate
    $user = Read-Host "Enter the email address of the user whose calendar you want to delegate"
    $delegate = Read-Host "Enter the email address of the delegate"

    Add-MailboxFolderPermission -Identity "${user}:\Calendar" -User $delegate -AccessRights Editor
    Write-Host "Calendar delegation added successfully!"
}

function RemoveCalendarDelegation {
    # Prompt for user and delegate
    $user = Read-Host "Enter the email address of the user whose calendar delegation you want to remove"
    $delegate = Read-Host "Enter the email address of the delegate"

    Remove-MailboxFolderPermission -Identity "${user}:\Calendar" -User $delegate
    Write-Host "Calendar delegation removed successfully!"
}

function ViewCalendarDelegation {
    # Prompt for user
    $user = Read-Host "Enter the email address of the user whose calendar delegation you want to view"

    # Get calendar delegation for user
    $calendarPermission = Get-MailboxFolderPermission -Identity "${user}:\Calendar"

    # Display calendar delegation
    Write-Host "Calendar delegation for ${user}:"
    foreach ($permission in $calendarPermission) {
        if ($permission.IsInherited -eq $false) {
            Write-Host "Delegate: $($permission.User.ToString()), Access Rights: $($permission.AccessRights)"
        }
    }
}

# Call the main menu
Call "ShowMainMenu"

# Close the session
Remove-PSSession $Session
