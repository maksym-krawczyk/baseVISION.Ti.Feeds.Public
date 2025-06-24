# Readme

This playbook is triggered every 15 minutes and sends IOCs to Microsoft Defender XDR. The IOCs are filtered based on the confidence level and are not part of the Microsoft Feeds to stay withtin the 15000 limit of Microsoft Defender XDR. After the deployment you need to grant the managed identity access to the Microsoft Defender XDR API. Copy the following script which can be executed in the Cloud Shell or in a local PowerShell session. 

```
# Replace with your managed identity object ID
$miName = "la-basevisionti-defenderxdr-uami"

# The app ID of the Defender API where the permissions are required
$appId = "fc780465-2017-40d4-a0c5-307022471b92"

# Replace with the API permissions required by your app
$permissionsToAdd = @("Ti.ReadWrite.All")

Connect-AzureAD

$miObjectID = (Get-AzADServicePrincipal -DisplayName $miName).Id
$app = Get-AzureADServicePrincipal -Filter "AppId eq '$appId'"

foreach ($permission in $permissionsToAdd)
{
   $role = $app.AppRoles | where Value -Like $permission | Select-Object -First 1

   New-AzureADServiceAppRoleAssignment -Id $role.Id -ObjectId $miObjectID -PrincipalId $miObjectID -ResourceId $app.ObjectId
}
```