# Ensure AzureAD module is loaded
Import-Module AzureAD -ErrorAction Stop

# Group and setting variables
$GroupName = "ADMIN"
$AllowGroupCreation = "False"

# Connect to Azure AD
Connect-AzureAD

# Get existing directory setting object
$settingsObjectID = (Get-AzureADDirectorySetting | Where-Object {$_.DisplayName -eq "Group.Unified"}).Id

# If settings object does not exist, create it
if (!$settingsObjectID) {
    $template = Get-AzureADDirectorySettingTemplate | Where-Object {$_.DisplayName -eq "Group.Unified"}
    $settingsCopy = $template.CreateDirectorySetting()
    New-AzureADDirectorySetting -DirectorySetting $settingsCopy
    $settingsObjectID = (Get-AzureADDirectorySetting | Where-Object {$_.DisplayName -eq "Group.Unified"}).Id
}

# Get the settings object to modify
$settingsCopy = Get-AzureADDirectorySetting -Id $settingsObjectID

# Set EnableGroupCreation flag
$settingsCopy["EnableGroupCreation"] = $AllowGroupCreation

# If a GroupName is defined, set GroupCreationAllowedGroupId
if ($GroupName) {
    $groupObjectID = (Get-AzureADGroup -Filter "DisplayName eq '$GroupName'").ObjectId
    if ($groupObjectID) {
        $settingsCopy["GroupCreationAllowedGroupId"] = $groupObjectID
    } else {
        Write-Host "Group $GroupName not found."
        exit 1
    }
} else {
    $settingsCopy["GroupCreationAllowedGroupId"] = $GroupName
}

# Update the directory setting
Set-AzureADDirectorySetting -Id $settingsObjectID -DirectorySetting $settingsCopy

# Display current directory settings
(Get-AzureADDirectorySetting -Id $settingsObjectID).Values

# Pause and wait for user input
Write-Host "Press any key to continue ..."
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

