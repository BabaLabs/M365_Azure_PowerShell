Connect-AzureAD

$Users = Get-AzureADUser -All $True | Select-Object -ExpandProperty "ProxyAddresses, Manager"
$Result = @()
foreach ($User in $Users) {
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
        Manager = $User.Manager
        proxyAddresses = $User.proxyAddresses
    }
}
$Result | Select-Object * | Export-Csv -Path "C:\Temp\Attributes.csv" -NoTypeInformation