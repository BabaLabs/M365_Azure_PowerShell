Connect-AzureAD

$Users = Get-AzureADUser -All $True
$Result = @()

for ($i=0; $i -lt $Users.Count; $i++) {
    $User = $Users[$i]
    Write-Progress -Activity "Processing Users" -Status "Processing $($User.DisplayName)" -PercentComplete (($i / $Users.Count) * 100)

    $ManagerId = (Get-AzureADUserManager -ObjectId $User.ObjectId).ObjectId
    $ManagerDetails = if($ManagerId) { Get-AzureADUser -ObjectId $ManagerId }
    $proxyAddresses = ($User | Select-Object -ExpandProperty ProxyAddresses) -join ", "

    $Result += New-Object PSObject -Property @{
        ObjectId = $User.ObjectId
        ObjectType = $User.ObjectType
        DisplayName = $User.DisplayName
        UserPrincipalName = $User.UserPrincipalName
        Mail = $User.Mail
        MailNickName = $User.MailNickName
        Mobile = $User.Mobile
        GivenName = $User.GivenName
        Surname = $User.Surname
        AccountEnabled = $User.AccountEnabled
        UsageLocation = $User.UsageLocation
        StreetAddress = $User.StreetAddress
        City = $User.City
        State = $User.State
        PostalCode = $User.PostalCode
        Country = $User.Country
        JobTitle = $User.JobTitle
        Department = $User.Department
        Company = $User.Company
        ManagerDisplayName = $ManagerDetails.DisplayName
        ManagerUserPrincipalName = $ManagerDetails.UserPrincipalName
        ProxyAddresses = $proxyAddresses
    }
}

$Result | Export-Csv -Path "C:\Temp\Attributes.csv" -NoTypeInformation

# Pause at the end
Read-Host -Prompt "Press Enter to exit"
