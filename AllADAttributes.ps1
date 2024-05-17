# Connect to Azure AD
Connect-AzureAD

# Retrieve all users
$Users = Get-AzureADUser -All $True
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
        Manager = $(Get-AzureADUserManager -ObjectId $User.ObjectID).displayname
        proxyAddresses = [string]::join(";", ($User.proxyAddresses))
    }
}
$Result | Export-Csv -Path "C:\Temp\Attributes.csv" -NoTypeInformation

#ObjectId
#ObjectType
#DisplayName
#UserPrincipalName
#Mail
#MailNickname
#JobTitle
#Department
#OfficeLocation
#BusinessPhones
#MobilePhone
#StreetAddress
#City
#State
#PostalCode
##Country
#GivenName
#Surname
#UserType
#UsageLocation
#PreferredLanguage
#OnPremisesSecurityIdentifier
#OnPremisesSamAccountName
#OnPremisesUserPrincipalName
#OnPremisesDistinguishedName
#SignInName
#AccountEnabled
#AssignedLicenses
#AssignedPlans
#StrongAuthenticationMethods
##City
#State
#PostalCode
#Country
#CreatedOnBehalfOf
#CreationType
#ProvisionedPlans
###ProvisioningErrors
#RefreshTokensValidFromDateTime
#AdditionalData
#ServicePrincipalNames
###Tags
#AppRoleAssignments
#Owners
#ExtensionProperty
#PasswordProfile
#PasswordPolicies
