Connect-exchangeOnline -UserPrincipalName Administrator@agilexfragrances.com

#This searches for all mailboxes in the organization and runs the command for each account that is listed. FifteenMinutes and ThirtyMinutes are the only 2 criteria that can be used
$users = Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited;
foreach ($user in $users) 
{
    Set-MailboxCalendarConfiguration -Identity $user.PrimarySmtpAddress -DefaultMeetingDuration 30
}
