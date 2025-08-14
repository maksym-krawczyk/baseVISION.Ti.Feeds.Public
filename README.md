# baseVISION Threat Intelligence Feeds

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FbaseVISION%2FbaseVISION.Ti.Feeds.Public%2Frefs%2Fheads%2Fmain%2FAdditional-AzureResources.json/createUIDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FbaseVISION%2FbaseVISION.Ti.Feeds.Public%2Frefs%2Fheads%2Fmain%2FAdditional-AzureResources-UI.json)
[![License](https://img.shields.io/github/license/baseVISION/baseVISION.Ti.Feeds.Public)](LICENSE)

> 🚀 **Enterprise-grade threat intelligence feeds for Microsoft Sentinel**

This repository contains deployment resources and documentation for baseVISION's Threat Intelligence Feeds solution, designed to enhance your cybersecurity posture with high-quality, actionable threat intelligence data.

## 🌟 Overview

baseVISION's Threat Intelligence Feeds provide real-time, curated threat indicators that integrate seamlessly with Microsoft Sentinel through TAXII (Trusted Automated Exchange of Intelligence Information) protocol. Our feeds help security teams identify, investigate, and respond to threats more effectively.

### Key Features

- 🎯 **High-Quality Indicators**: Curated threat intelligence from multiple sources
- ⚡ **Real-Time Updates**: Fresh indicators delivered continuously
- 🔗 **Native Integration**: Seamless Microsoft Sentinel compatibility via TAXII
- 📊 **Rich Context**: Detailed metadata and attribution for each indicator
- 🛡️ **Enterprise Ready**: Scalable solution for organizations of all sizes

## 🛍️ Azure Marketplace Subscription

Subscribe to our threat intelligence feeds directly through the Azure Marketplace for streamlined billing and deployment.

### Benefits
- **Simple Procurement**: One-click subscription through Azure Marketplace
- **Unified Billing**: Integrated with your existing Azure billing
- **Instant Activation**: Get started within minutes
- **Flexible Plans**: Choose the subscription tier that fits your needs

## 🧩 Azure Addon Pack

Maximize the value of your threat intelligence investment with our comprehensive Azure Addon Pack. These additional resources enhance monitoring, analytics, and operational efficiency.

### Components

#### 📊 **Microsoft Sentinel Workbook (Dashboard)**
- **Purpose**: Comprehensive analytics and visualization dashboard
- **Features**: 
  - Real-time feed quality metrics
  - Performance monitoring and statistics
  - Threat landscape insights
  - ROI and efficiency analytics
- **Benefits**: Monitor feed effectiveness and justify security investments

#### 🔄 **Logic App (Telemetry Playbook)**
- **Purpose**: Automated telemetry collection for feed optimization
- **Frequency**: Runs every 4 hours
- **Data Collected**: 
  - IOC utilization metrics
  - Analyst feedback on threat classifications
  - Incident correlation data
- **Privacy**: Only baseVISION-provided IOCs and associated classifications are shared
- **Benefits**: Continuously improve feed quality based on real-world usage

## 📚 Quick Start Guide

### 1. Subscribe to Threat Intelligence Feeds
Get started with our comprehensive subscription guide:
- 📖 [Subscribe via Azure Marketplace](SubscribeAzureMarketplaceOffering.md)

### 2. Deploy the Azure Addon Pack
Enhance your deployment with additional monitoring and analytics:
- 🚀 [Setup Azure Addon Pack](SetupAddonPack.md)

### 3. Configure Microsoft Sentinel
Follow the detailed integration steps in our subscription guide to connect the TAXII feed to your Microsoft Sentinel workspace.

## 🔧 Prerequisites

- **Microsoft Sentinel Workspace**: Active workspace with appropriate permissions
- **Azure Subscription**: With permissions to deploy resources
- **TAXII Connector**: Threat Intelligence - TAXII data connector (available in Content Hub)

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│   baseVISION    │────│   TAXII Feed     │────│  Microsoft Sentinel │
│  TI Platform    │    │   (Encrypted)    │    │     Workspace       │
└─────────────────┘    └──────────────────┘    └─────────────────────┘
                                │                          │
                                │                          │
                       ┌────────▼────────┐        ┌───────▼────────┐
                       │  Azure Addon    │        │   Dashboard    │
                       │     Pack        │        │   & Analytics  │
                       └─────────────────┘        └────────────────┘
```

## 📁 Repository Structure

```
├── Additional-AzureResources.json      # ARM template for addon pack
├── Additional-AzureResources-UI.json   # UI definition for deployment
├── SubscribeAzureMarketplaceOffering.md # Subscription guide
├── SetupAddonPack.md                   # Addon pack setup guide
├── beta/                               # Beta features and integrations
│   └── DefenderIntegration/            # Microsoft Defender XDR integration
└── images/                             # Documentation screenshots
```

## 🔐 Security & Privacy

- **Data Protection**: All threat intelligence data is transmitted over encrypted channels
- **Minimal Telemetry**: Only necessary operational data is collected
- **No Sensitive Data**: Customer data and non-baseVISION IOCs are never transmitted
- **Compliance Ready**: Suitable for regulated environments

## 📈 Beta Features

Explore cutting-edge integrations in our beta directory:
- **Microsoft Defender XDR Integration**: Enhanced threat hunting capabilities
  - 📖 [Setup Guide & Documentation](beta/DefenderIntegration/Readme.md)
  - 🚀 Automated IOC synchronization with Microsoft Defender XDR
  - ⚡ Real-time threat intelligence integration

## 💬 Support & Community

### Community Support
The Azure Addon Pack is provided as a community solution. Get help through:
- 🐛 [GitHub Issues](https://github.com/baseVISION/baseVISION.Ti.Feeds.Public/issues)
- 📖 [Documentation](https://github.com/baseVISION/baseVISION.Ti.Feeds.Public/wiki)

## 📄 License

This project is licensed under the terms specified in the [LICENSE](LICENSE) file.

## 🏢 About baseVISION

baseVISION is a leading cybersecurity company. We help organizations stay ahead of evolving threats through innovative technology and expert analysis.

---

**Ready to enhance your threat detection capabilities?** Start by [subscribing to our feeds](SubscribeAzureMarketplaceOffering.md) or [deploying the addon pack](SetupAddonPack.md) today!
