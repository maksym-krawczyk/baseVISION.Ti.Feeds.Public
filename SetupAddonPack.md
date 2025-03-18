# Setup Addon Pack for Azure

You can start the deployment of the components by using the following button:\
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FbaseVISION%2FbaseVISION.Ti.Feeds.Public%2Frefs%2Fheads%2Fmain%2FAdditional-AzureResources.json/createUIDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FbaseVISION%2FbaseVISION.Ti.Feeds.Public%2Frefs%2Fheads%2Fmain%2FAdditional-AzureResources-UI.json)

After the deployment you need to grant the managed identity access to the Microsoft Defender XDR API. Copy the following script which can be executed in the Cloud Shell or in a local PowerShell session:

```powershell
# Replace with your managed identity object name if you have adjusted it in above deployment
$miName = "la-basevisionti-defenderxdr-uami"
# The app ID of the Defender API where the permissions are required (For all customers the same)
$appId = "fc780465-2017-40d4-a0c5-307022471b92"
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
