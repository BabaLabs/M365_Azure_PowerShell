#This script is used to assign a specific license to all users within a tenant

# Connect to Azure AD, prompts user for sign-in info
Connect-AzureAD

# List all available SkuPartNumbers
Write-Host "Available Licenses:"
$skus = Get-AzureADSubscribedSku | Select-Object -Property SkuPartNumber, SkuId
$index = 1
$skus | ForEach-Object {
    Write-Host "$index. $($_.SkuPartNumber)"
    $index++
}

# Prompt user to select a SkuPartNumber from the menu
$selectedSkuIndex = Read-Host -Prompt "Enter the number of the license you want to assign"

# Validate the user input
if ($selectedSkuIndex -lt 1 -or $selectedSkuIndex -gt $skus.Count) {
    Write-Host "Invalid selection. Please re-run the script and enter a valid number."
    return
}

# Get the selected license
$selectedSku = $skus[$selectedSkuIndex - 1]

# Assign the selected license to all users who are already licensed
$license = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$license.SkuId = $selectedSku.SkuId
$licenseAssignment = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$licenseAssignment.AddLicenses = $license

#This command pulls a list of all users that are currently licensed in the tenant, then adds the selected license to all of them
Get-AzureADUser -All $true | Where-Object { $_.AssignedLicenses } | Set-AzureADUserLicense -AssignedLicenses $licenseAssignment

#This is a visual confirmation that the script ran
Write-Host "License assignment completed."
