metadata title = 'baseVISION Threat Intel - Defender Integration'
metadata description = 'This playbook is triggered every 15 minutes and sends Filter based defined IOCs to Microsoft Defender XDR.'
metadata mainSteps = [
  '1. Get IOCs not part of Microsoft Feeds'
  '2. Send data to Microsoft Defender XDR'
]
metadata prerequisites = [
  'baseVISION TI Feed in TAXII connector configured.'
]
metadata postdeployment = [
  'After the deployment you need to grant the managed identity access to the Microsoft Defender XDR API. Copy the following script which can be executed in the Cloud Shell or in a local PowerShell session: <br><br> <code># Replace with your managed identity object ID<br>$miName = "la-basevisionti-defenderxdr-uami"<br># The app ID of the Defender API where the permissions are required<br>$appId = "fc780465-2017-40d4-a0c5-307022471b92"<br># Replace with the API permissions required by your app<br>$permissionsToAdd = @("Ti.ReadWrite.All")<br>Connect-AzureAD<br>$miObjectID = (Get-AzADServicePrincipal -DisplayName $miName).Id<br>$app = Get-AzureADServicePrincipal -Filter "AppId eq \'$appId\'"<br>foreach ($permission in $permissionsToAdd)<br>{<br>   $role = $app.AppRoles | where Value -Like $permission | Select-Object -First 1<br>   New-AzureADServiceAppRoleAssignment -Id $role.Id -ObjectId $miObjectID -PrincipalId $miObjectID -ResourceId $app.ObjectId<br>}</code>'
]
metadata lastUpdateTime = '2025-03-12T00:00:00.000Z'
metadata entities = []
metadata tags = []
metadata support = {
  tier: 'Community'
  name: 'baseVISION AG'
  email: 'support@basevision.ch'
}
metadata author = {
  name: 'baseVISION AG'
}

@description('Name of the playbook (Logic Apps resource) which will be created')
param PlaybookName string = 'la-basevisionti-defenderxdr'
param location string = ''

@description('Action (Warn, Block, Audit or BlockAndRemediate) to take by the defender integration playbook (Logic Apps resource) which will be created')
@minLength(1)
param Action string = 'Audit'

@description('Name of the Taxii Feed which was configured in the TAXII connector')
@minLength(1)
param TaxiiFeedName string = 'baseVISION-SOC-TI-Feed'

@description('Workspace name for Azure Log Analytics where Azure Sentinel is setup')
@minLength(1)
param workspace string = '<Enter Log Analytics Workspace>'

var laName = PlaybookName
var azureSentinelConnectionName = '${PlaybookName}-azmon-connection'
var uamiName = '${PlaybookName}-uami'
var roleDefinitionSentinelReaderId = '8d289c81-5878-46d4-8554-54e1e3d8b5cb'

resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: uamiName
  location: location
}

resource azureSentinelConnection 'Microsoft.Web/connections@2016-06-01' = {
  name: azureSentinelConnectionName
  location: location
  tags: {}
  properties: {
    displayName: azureSentinelConnectionName
    customParameterValues: {}
    api: {
      id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${location}/managedApis/azuremonitorlogs'
    }
    parameterValueSet: {
      name: 'managedIdentityAuth'
      values: {}
    }
  }
}

resource la 'Microsoft.Logic/workflows@2019-05-01' = {
  name: laName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${uami.id}': {}
    }
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        TaxiiFeedName: {
          defaultValue: TaxiiFeedName
          type: 'String'
        }
        SubscriptionId: {
          defaultValue: subscription().subscriptionId
          type: 'String'
        }
        ResourceGroupName: {
          defaultValue: resourceGroup().name
          type: 'String'
        }
        SentinelName: {
          defaultValue: workspace
          type: 'String'
        }
        Action: {
          defaultValue: Action
          type: 'String'
        }
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        Sliding_Window: {
          recurrence: {
            interval: 30
            frequency: 'Minute'
            timeZone: 'UTC'
          }
          evaluatedRecurrence: {
            interval: 30
            frequency: 'Minute'
            timeZone: 'UTC'
          }
          type: 'SlidingWindow'
          conditions: []
        }
      }
      actions: {
        Get_IOCs_not_on_Microsoft_feed_with_confidence_of_100: {
          runAfter: {
            Initialize_variable_Batch: [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'azuremonitorlogs\'][\'connectionId\']'
              }
            }
            method: 'post'
            body: {
              query: 'let onlyMsTI = ThreatIntelligenceIndicator\n| where Active == true and SourceSystem == "Microsoft Defender Threat Intelligence" and FileHashType !contains "MD5" and FileHashType !contains "SHA1" and TimeGenerated > ago(7d)\n| project Ioc=strcat(NetworkSourceIP, NetworkIP, NetworkDestinationIP, Url, FileHashValue, DomainName,EmailSenderName), SourceSystem, ConfidenceScore,ExpirationDateTime\n| distinct Ioc;\nThreatIntelligenceIndicator\n| where ConfidenceScore > 99 and Active == true and SourceSystem == "@{parameters(\'TaxiiFeedName\')}" and FileHashType !contains "MD5" and FileHashType !contains "SHA1" and TimeGenerated > todatetime("@{triggerOutputs()[\'windowStartTime\']}")\n| project Ioc=strcat(NetworkSourceIP, NetworkIP, NetworkDestinationIP, Url, FileHashValue, DomainName,EmailSenderName), Description, IocType = case(\n    isnotempty(NetworkSourceIP) or isnotempty(NetworkIP) or isnotempty(NetworkDestinationIP), "IpAddress",\n    isnotempty(Url), "Url",\n    isnotempty(FileHashValue), "FileSha256",  // Assuming FileHashValue represents FileSha256\n    isnotempty(DomainName), "DomainName",\n    ""\n), SourceSystem, ConfidenceScore,ExpirationDateTime,TrafficLightProtocolLevel\n| join kind=leftanti onlyMsTI on Ioc\n| summarize MinConfidenceScore=min(ConfidenceScore),MinExpirationDateTime=min(ExpirationDateTime), Descriptions=make_list(Description) by Ioc, IocType\n| project Ioc, IocType, Description=replace(@"[^a-zA-Z0-9/]"," ",iff(Descriptions[0] != "",Descriptions[0],"baseVISION TI")), MinConfidenceScore,MinExpirationDateTime'
              timerangetype: '3'
            }
            path: '/queryDataV2'
            queries: {
              subscriptions: '@parameters(\'SubscriptionId\')'
              resourcegroups: '@parameters(\'ResourceGroupName\')'
              resourcetype: 'Log Analytics Workspace'
              resourcename: '@parameters(\'SentinelName\')'
            }
          }
        }
        For_each: {
          foreach: '@body(\'Get_IOCs_not_on_Microsoft_feed_with_confidence_of_100\')?[\'value\']'
          actions: {
            Append_to_array_variable: {
              type: 'AppendToArrayVariable'
              inputs: {
                name: 'Batch'
                value: {
                  indicatorValue: '@{item()?[\'Ioc\']}'
                  indicatorType: '@{item()?[\'IocType\']}'
                  title: '@{item()?[\'Ioc\']}'
                  application: '@{parameters(\'TaxiiFeedName\')}'
                  expirationTime: '@{formatDateTime(item()?[\'MinExpirationDateTime\'],\'s\')}Z'
                  action: '@{parameters(\'Action\')}'
                  severity: 'Low'
                  description: '@{item()?[\'Description\']}'
                  recommendedActions: 'nothing'
                  rbacGroupNames: []
                  generateAlert: 'True'
                }
              }
            }
            Condition: {
              actions: {}
              runAfter: {
                Append_to_array_variable: [
                  'Succeeded'
                ]
              }
              else: {
                actions: {
                  Reset_Batch: {
                    runAfter: {
                      Add_Indicator_to_Defender_XDR: [
                        'Succeeded'
                      ]
                    }
                    type: 'SetVariable'
                    inputs: {
                      name: 'Batch'
                      value: '@null'
                    }
                  }
                  Add_Indicator_to_Defender_XDR: {
                    type: 'Http'
                    inputs: {
                      uri: 'https://api.securitycenter.microsoft.com/api/indicators/import'
                      method: 'POST'
                      headers: {
                        'Content-Type': 'application/json'
                      }
                      body: {
                        Indicators: '@variables(\'Batch\')'
                      }
                      authentication: {
                        type: 'ManagedServiceIdentity'
                        identity: uami.id
                        audience: 'https://api.securitycenter.microsoft.com/'
                      }
                      retryPolicy: {
                        type: 'none'
                      }
                    }
                    runtimeConfiguration: {
                      contentTransfer: {
                        transferMode: 'Chunked'
                      }
                    }
                  }
                }
              }
              expression: {
                and: [
                  {
                    less: [
                      '@length(variables(\'Batch\'))'
                      400
                    ]
                  }
                ]
              }
              type: 'If'
            }
          }
          runAfter: {
            Get_IOCs_not_on_Microsoft_feed_with_confidence_of_100: [
              'Succeeded'
            ]
          }
          type: 'Foreach'
        }
        Initialize_variable_Batch: {
          runAfter: {}
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'Batch'
                type: 'array'
              }
            ]
          }
        }
        Only_Add_indicators_if_array_contains_values: {
          runAfter: {
            For_each: [
              'Succeeded'
            ]
          }
          type: 'If'
          expression: {
            and: [
              {
                greater: [
                  '@length(variables(\'Batch\'))'
                  0
                ]
              }
            ]
          }
          actions: {
            Add_Indicator_to_Defender_XDR_Final: {
              type: 'Http'
              inputs: {
                uri: 'https://api.securitycenter.microsoft.com/api/indicators/import'
                method: 'POST'
                headers: {
                  'Content-Type': 'application/json'
                }
                body: {
                  Indicators: '@variables(\'Batch\')'
                }
                authentication: {
                  type: 'ManagedServiceIdentity'
                  identity: uami.id
                  audience: 'https://api.securitycenter.microsoft.com/'
                }
                retryPolicy: {
                  type: 'none'
                }
              }
              runtimeConfiguration: {
                contentTransfer: {
                  transferMode: 'Chunked'
                }
              }
            }
          }
          else: {
            actions: {}
          }
        }
      }
      outputs: {}
    }
    parameters: {
      '$connections': {
        value: {
          azuremonitorlogs: {
            id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${location}/managedApis/azuremonitorlogs'
            connectionId: azureSentinelConnection.id
            connectionName: 'azuremonitorlogs'
            connectionProperties: {
              authentication: {
                type: 'ManagedServiceIdentity'
                identity: uami.id
              }
            }
          }
        }
      }
    }
  }
}

resource Microsoft_Logic_workflows_laName_Microsoft_ManagedIdentity_userAssignedIdentities_uamiName_Microsoft_Authorization_roleDefinitions_roleDefinitionSentinelReaderId 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(
    la.id,
    uami.id,
    subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionSentinelReaderId)
  )
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionSentinelReaderId)
    principalId: reference(uami.id, '2024-11-30').principalId
    principalType: 'ServicePrincipal'
  }
}
