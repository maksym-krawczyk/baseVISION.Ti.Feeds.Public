# baseVISION.Ti.Feeds.Public

This repository contains resources for our Threat Intel Feeds solution.

## Azure Marketplace Subscription offering

The TI Feed solution can directly be subscribed via Azure Marketplace.

## Addon Pack for Azure

baseVISION provides additional resources which can be deployed to Azure to maximize the usage of our Threat Intel Solution. The Azure Addon Pack consists of:

* **Dashboard (Microsoft Sentinel Workbook)**\
This workbook provides insights into Threat Intel feeds integrated into the selected Microsoft Sentinel Workspace regarding quality, speed and efficienty.
* **Telemetry (Logic App)**\
This playbook is triggered every four hours and sends basic telemetry to baseVISION to improve the feeds. The telemetry data only contains IOC\'s provided by baseVISION together with the analysts classification of incidents associated with it.

## Setup Guides

* [Buy / Subscribe in Azure Marketplace](SubscribeAzureMarketplaceOffering.md)
* [Setup Addon Pack for Azure](SetupAddonPack.md)

## Support

The Addon Pack for Azure is provided as community solution without support. For the paid feeds check the support information withtin the subscription portal.
