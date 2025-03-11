# baseVISION.Ti.Feeds.Public
This repository contains resources for our Threat Intel Feeds solution.

## Addon Pack for Azure

baseVISION provides additional resources which can be deployed to Azure to maximize the usage of out Threat Intel Solution. The Azure Addon back consists of - base

* **Dashboard (Microsoft Sentinel Workbook)**\
This workbook provides insights into Threat Intel feeds integrated into the selected Microsoft Sentinel Workspace regarding quality, speed and efficienty.
* **Telemetry (Logic App)**\
This playbook is triggered every four hours and sends basic telemetry to baseVISION to improve the feeds. The telemetry data only contains IOC\'s provided by baseVISION together with the analysts classification of incidents associated with it.
* **Defender Integration (Logic App)**\
This playbook is triggered every 15 minutes and sends Filter based defined IOCs to Microsoft Defender XDR with an action defined by you.

### Deployment
You can start the deployment of the components by using the following button:\
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FbaseVISION%2FbaseVISION.Ti.Feeds.Public%2Frefs%2Fheads%2Fmain%2FAdditional-AzureResources.json)

After the deployment you need to grant the managed identity access to the Microsoft Defender XDR API. Copy the following script which can be executed in the Cloud Shell or in a local PowerShell session:
```powershell
# Replace with your managed identity object ID
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
