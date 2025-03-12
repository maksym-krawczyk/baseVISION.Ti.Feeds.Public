# Buy / Subscribe in Azure Marketplace

1. In the Azure Marketplace, find **baseVISION SOC – TI Feeds – Subscription** and on the offer page, select the **Yearly Subscription** plan and click **Subscribe**. ![](images/Azure-Marketplace.avif)

2. On the **Basic** page, select the subscription through which the Threat Intelligence feeds will be paid and choose a **resource group** to add the SaaS resource. This does not need to be the Microsoft Sentinel resource group; it is recommended to use a dedicated resource group as the SaaS resource serves solely as a placeholder for payment purposes. Additionally, specify the **Name** of this resource. Finally, click on Review and Subscribe.![](images/Azure-Marketplace-Basic-Page.avif)

3. On the **Review** screen you can verify your chosen values and click on **Subscribe**. ![](images/Azure-Marketplace-Review-Page.avif)

4. The process for setting up the feed for you is now starting and should be finished within one minute.![](images/Azure-Marketplace-Progress-Page.avif)

5. As soon the setup is ready the **Configure account now** button is shown which you can click to open the baseVISION SaaS Portal.![](images/Azure-Marketplace-Configure-Page.avif)

6. You can login with the same account you have used in the Azure Portal. Consent to the required permissions which are limited to the minimum and verify that the publisher baseVISION AG is verified.  After the login was successfully you can click on **Activate** to enable the generated access details.![](images/SaaS-Portal-Subscription-Details.avif)

7. On this page you get the manual on how to configure the TAXII feed in Microsoft Sentinel and at the bottom of the page you can also locate the Configuration information.

> [!IMPORTANT]
> It’s important, that you use the proposed **Friendly Name** in the configuration as additional Sentinel Content Hub Solutions published in the future will expect this name.

![](images/SaaS-Portal-Setup-Details.avif)

![](images/SaaS-Portal-Config-Details.avif)

## Enable the Threat Intelligence - TAXII data connector

1. Navigate to your [Microsoft Sentinel workspace](https://portal.azure.com/#browse/microsoft.securityinsightsarg%2Fsentinel).

2. To configure the TAXII data connector, select the Data connectors menu.

3. Find and select the Threat Intelligence – TAXII data connector, and then select Open connector page. If you don’t see the connector then you need to install the [Threat Intel Solution](https://learn.microsoft.com/en-us/azure/sentinel/connect-threat-intelligence-taxii#install-the-threat-intelligence-solution-in-microsoft-sentinel) form Content Hub first.
[![](https://www.basevision.ch/wp-content/uploads/2025/03/Data-Connectors.png)](https://www.basevision.ch/wp-content/uploads/2025/03/Data-Connectors.png)

4. Enter the data like it is provided in the **Configuration Information** section on this page. Choose polling frequency you want, we recommend every one hour. Select Add. 
[![](https://www.basevision.ch/wp-content/uploads/2025/03/Configuration.png)](https://www.basevision.ch/wp-content/uploads/2025/03/Configuration.png)

5. You should receive confirmation that a connection to the TAXII server was established successfully.

6. Within a few minutes, threat indicators should begin flowing into this Microsoft Sentinel workspace. Find the new indicators on the Threat intelligence pane. You can access it from the Microsoft Sentinel menu.

## Next step: Setup Addon Pack for Azure

After the integration of the feeds we recommend [configuring the Addon Pack](SetupAddonPack.md).
