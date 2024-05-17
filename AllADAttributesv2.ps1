$AccessToken = (Get-AzureADToken -Resource "https://graph.windows.net").AccessToken
$Users = Get-AzureADUser -All $True

$Results = @()

foreach ($User in $Users) {
  $RequestUri = "https://graph.windows.net/73839c3e-4bbb-4518-92cc-25886c02b72d/users/$UserId?api-version=1.6&$expand=manager,proxyAddresses"
  $Result = Invoke-RestMethod -Method Get -Headers @{Authorization = "Bearer $AccessToken"} -Uri $RequestUri

  $ObjectId = $Result.ObjectId
  $DisplayName = $Result.DisplayName
  $GivenName = $Result.GivenName
  $Surname = $Result.Surname
  $UserPrincipalName = $Result.UserPrincipalName
  $Mail = $Result.Mail
  $MailNickname = $Result.MailNickname
  $SignInNames = $Result.SignInNames
  $JobTitle = $Result.JobTitle
  $Department = $Result.Department
  $City = $Result.City
  $State = $Result.State
  $StreetAddress = $Result.StreetAddress
  $PostalCode = $Result.PostalCode
  $Country = $Result.Country
  $OfficeLocation = $Result.OfficeLocation
  $PhoneNumber = $Result.PhoneNumber
  $Mobile = $Result.Mobile
  $Fax = $Result.Fax
  $Manager = $Result.Manager
  $ProxyAddresses = $Result.ProxyAddresses

  $Results += New-Object PSObject -Property @{
    ObjectId = $ObjectId
    DisplayName = $DisplayName
    GivenName = $GivenName
    Surname = $Surname
    UserPrincipalName = $UserPrincipalName
    Mail = $Mail
    MailNickname = $MailNickname
    SignInNames = $SignInNames
    JobTitle = $JobTitle
    Department = $Department
    City = $City
    State = $State
    StreetAddress = $StreetAddress
    PostalCode = $PostalCode
    Country = $Country
    OfficeLocation = $OfficeLocation
    PhoneNumber = $PhoneNumber
    Mobile = $Mobile
    Fax = $Fax
    Manager = $Manager
    ProxyAddresses = $ProxyAddresses
  }
}

$Results | Export-Csv -Path "C:\Temp\AzureADUsers.csv" -NoTypeInformation