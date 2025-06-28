@secure()
param IotHubs_termosmartHub_connectionString string

@secure()
param IotHubs_termosmartHub_containerName string
param sites_index_name string = 'index'
param sites_termosmart_api_name string = 'termosmart-api'
param IotHubs_termosmartHub_name string = 'termosmartHub'
param serverfarms_termosmart_plan_name string = 'termosmart-plan'
param staticSites_termosmart_backend1_name string = 'termosmart-backend1'
param serverfarms_ASP_TermoSmartRG_a2f6_name string = 'ASP-TermoSmartRG-a2f6'
param serverfarms_ASP_TermoSmartRG_b7fc_name string = 'ASP-TermoSmartRG-b7fc'
param storageAccounts_termosmartstorage_name string = 'termosmartstorage'
param serverfarms_WestEuropeLinuxDynamicPlan_name string = 'WestEuropeLinuxDynamicPlan'
param userAssignedIdentities_oidc_msi_8221_name string = 'oidc-msi-8221'
param userAssignedIdentities_oidc_msi_b692_name string = 'oidc-msi-b692'
param userAssignedIdentities_oidc_msi_bba7_name string = 'oidc-msi-bba7'
param actionGroups_Application_Insights_Smart_Detection_name string = 'Application Insights Smart Detection'

resource IotHubs_termosmartHub_name_resource 'Microsoft.Devices/IotHubs@2023-06-30' = {
  name: IotHubs_termosmartHub_name
  location: 'westeurope'
  sku: {
    name: 'F1'
    tier: 'Free'
    capacity: 1
  }
  identity: {
    type: 'None'
  }
  properties: {
    ipFilterRules: []
    eventHubEndpoints: {
      events: {
        retentionTimeInDays: 1
        partitionCount: 2
      }
    }
    routing: {
      endpoints: {
        serviceBusQueues: []
        serviceBusTopics: []
        eventHubs: []
        storageContainers: [
          {
            connectionString: 'DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=termosmartstorage;AccountKey=****'
            containerName: 'telemetry'
            fileNameFormat: '{iothub}/{partition}/{YYYY}/{MM}/{DD}/{HH}/{mm}.json'
            batchFrequencyInSeconds: 100
            maxChunkSizeInBytes: 104857600
            encoding: 'JSON'
            authenticationType: 'keyBased'
            name: 'BlobStorageEndpoint'
            id: 'a681fecd-c864-4915-8c04-8cab180a64e3'
            subscriptionId: '37e0435e-45f9-4cae-ab09-052bd1e81275'
            resourceGroup: 'termosmart-rg'
          }
        ]
        cosmosDBSqlContainers: []
      }
      routes: [
        {
          name: 'ToBlobStorage'
          source: 'DeviceMessages'
          condition: 'true'
          endpointNames: [
            'BlobStorageEndpoint'
          ]
          isEnabled: true
        }
      ]
      fallbackRoute: {
        name: '$fallback'
        source: 'DeviceMessages'
        condition: 'true'
        endpointNames: [
          'events'
        ]
        isEnabled: true
      }
    }
    storageEndpoints: {
      '$default': {
        sasTtlAsIso8601: 'PT1H'
        connectionString: IotHubs_termosmartHub_connectionString
        containerName: IotHubs_termosmartHub_containerName
      }
    }
    messagingEndpoints: {
      fileNotifications: {
        lockDurationAsIso8601: 'PT5S'
        ttlAsIso8601: 'PT1H'
        maxDeliveryCount: 10
      }
    }
    enableFileUploadNotifications: false
    cloudToDevice: {
      maxDeliveryCount: 10
      defaultTtlAsIso8601: 'PT1H'
      feedback: {
        lockDurationAsIso8601: 'PT5S'
        ttlAsIso8601: 'PT1H'
        maxDeliveryCount: 10
      }
    }
    features: 'RootCertificateV2'
    allowedFqdnList: []
  }
}

resource actionGroups_Application_Insights_Smart_Detection_name_resource 'microsoft.insights/actionGroups@2024-10-01-preview' = {
  name: actionGroups_Application_Insights_Smart_Detection_name
  location: 'Global'
  properties: {
    groupShortName: 'SmartDetect'
    enabled: true
    emailReceivers: []
    smsReceivers: []
    webhookReceivers: []
    eventHubReceivers: []
    itsmReceivers: []
    azureAppPushReceivers: []
    automationRunbookReceivers: []
    voiceReceivers: []
    logicAppReceivers: []
    azureFunctionReceivers: []
    armRoleReceivers: [
      {
        name: 'Monitoring Contributor'
        roleId: '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
        useCommonAlertSchema: true
      }
      {
        name: 'Monitoring Reader'
        roleId: '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
        useCommonAlertSchema: true
      }
    ]
  }
}

resource userAssignedIdentities_oidc_msi_8221_name_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2025-01-31-preview' = {
  name: userAssignedIdentities_oidc_msi_8221_name
  location: 'westeurope'
}

resource userAssignedIdentities_oidc_msi_b692_name_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2025-01-31-preview' = {
  name: userAssignedIdentities_oidc_msi_b692_name
  location: 'westeurope'
}

resource userAssignedIdentities_oidc_msi_bba7_name_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2025-01-31-preview' = {
  name: userAssignedIdentities_oidc_msi_bba7_name
  location: 'westeurope'
}

resource storageAccounts_termosmartstorage_name_resource 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: storageAccounts_termosmartstorage_name
  location: 'westeurope'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_0'
    allowBlobPublicAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource serverfarms_ASP_TermoSmartRG_a2f6_name_resource 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: serverfarms_ASP_TermoSmartRG_a2f6_name
  location: 'West Europe'
  sku: {
    name: 'F1'
    tier: 'Free'
    size: 'F1'
    family: 'F'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource serverfarms_ASP_TermoSmartRG_b7fc_name_resource 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: serverfarms_ASP_TermoSmartRG_b7fc_name
  location: 'North Europe'
  sku: {
    name: 'F1'
    tier: 'Free'
    size: 'F1'
    family: 'F'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource serverfarms_termosmart_plan_name_resource 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: serverfarms_termosmart_plan_name
  location: 'West Europe'
  sku: {
    name: 'F1'
    tier: 'Free'
    size: 'F1'
    family: 'F'
    capacity: 0
  }
  kind: 'app'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource serverfarms_WestEuropeLinuxDynamicPlan_name_resource 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: serverfarms_WestEuropeLinuxDynamicPlan_name
  location: 'West Europe'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
  kind: 'functionapp'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource staticSites_termosmart_backend1_name_resource 'Microsoft.Web/staticSites@2024-04-01' = {
  name: staticSites_termosmart_backend1_name
  location: 'West Europe'
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    repositoryUrl: 'https://github.com/BartoszNowaczyk/termosmart'
    branch: 'main'
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    provider: 'GitHub'
    enterpriseGradeCdnStatus: 'Disabled'
  }
}

resource userAssignedIdentities_oidc_msi_bba7_name_oidc_credential_81f9 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2025-01-31-preview' = {
  parent: userAssignedIdentities_oidc_msi_bba7_name_resource
  name: 'oidc-credential-81f9'
  properties: {
    issuer: 'https://token.actions.githubusercontent.com'
    subject: 'repo:BartoszNowaczyk/TermoSmart:ref:refs/heads/main'
    audiences: [
      'api://AzureADTokenExchange'
    ]
  }
}

resource userAssignedIdentities_oidc_msi_b692_name_oidc_credential_82c4 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2025-01-31-preview' = {
  parent: userAssignedIdentities_oidc_msi_b692_name_resource
  name: 'oidc-credential-82c4'
  properties: {
    issuer: 'https://token.actions.githubusercontent.com'
    subject: 'repo:BartoszNowaczyk/termosmart2:ref:refs/heads/main'
    audiences: [
      'api://AzureADTokenExchange'
    ]
  }
}

resource userAssignedIdentities_oidc_msi_8221_name_oidc_credential_9d62 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2025-01-31-preview' = {
  parent: userAssignedIdentities_oidc_msi_8221_name_resource
  name: 'oidc-credential-9d62'
  properties: {
    issuer: 'https://token.actions.githubusercontent.com'
    subject: 'repo:BartoszNowaczyk/termosmart:environment:Production'
    audiences: [
      'api://AzureADTokenExchange'
    ]
  }
}

resource storageAccounts_termosmartstorage_name_default 'Microsoft.Storage/storageAccounts/blobServices@2024-01-01' = {
  parent: storageAccounts_termosmartstorage_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_termosmartstorage_name_default 'Microsoft.Storage/storageAccounts/fileServices@2024-01-01' = {
  parent: storageAccounts_termosmartstorage_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_termosmartstorage_name_default 'Microsoft.Storage/storageAccounts/queueServices@2024-01-01' = {
  parent: storageAccounts_termosmartstorage_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_termosmartstorage_name_default 'Microsoft.Storage/storageAccounts/tableServices@2024-01-01' = {
  parent: storageAccounts_termosmartstorage_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource sites_index_name_resource 'Microsoft.Web/sites@2024-04-01' = {
  name: sites_index_name
  location: 'North Europe'
  kind: 'app,linux'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${sites_index_name}-dhcha3cwbabqcken.northeurope-01.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${sites_index_name}-dhcha3cwbabqcken.scm.northeurope-01.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_ASP_TermoSmartRG_b7fc_name_resource.id
    reserved: true
    isXenon: false
    hyperV: false
    dnsConfiguration: {}
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      linuxFxVersion: 'PYTHON|3.11'
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    ipMode: 'IPv4'
    vnetBackupRestoreEnabled: false
    customDomainVerificationId: '69DC7C4B674DDC359E3E5851A1BFF6F326792AE842F577F5F27E05944953E8DB'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    endToEndEncryptionEnabled: false
    redundancyMode: 'None'
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
    autoGeneratedDomainNameLabelScope: 'TenantReuse'
  }
}

resource sites_termosmart_api_name_resource 'Microsoft.Web/sites@2024-04-01' = {
  name: sites_termosmart_api_name
  location: 'West Europe'
  kind: 'app,linux'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${sites_termosmart_api_name}-akcndqc3agbuh5bf.westeurope-01.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${sites_termosmart_api_name}-akcndqc3agbuh5bf.scm.westeurope-01.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_ASP_TermoSmartRG_a2f6_name_resource.id
    reserved: true
    isXenon: false
    hyperV: false
    dnsConfiguration: {}
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      linuxFxVersion: 'PYTHON|3.11'
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 1
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    ipMode: 'IPv4'
    vnetBackupRestoreEnabled: false
    customDomainVerificationId: '69DC7C4B674DDC359E3E5851A1BFF6F326792AE842F577F5F27E05944953E8DB'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    endToEndEncryptionEnabled: false
    redundancyMode: 'None'
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
    autoGeneratedDomainNameLabelScope: 'TenantReuse'
  }
}

resource sites_index_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-04-01' = {
  parent: sites_index_name_resource
  name: 'ftp'
  location: 'North Europe'
  properties: {
    allow: false
  }
}

resource sites_termosmart_api_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-04-01' = {
  parent: sites_termosmart_api_name_resource
  name: 'ftp'
  location: 'West Europe'
  properties: {
    allow: true
  }
}

resource sites_index_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-04-01' = {
  parent: sites_index_name_resource
  name: 'scm'
  location: 'North Europe'
  properties: {
    allow: false
  }
}

resource sites_termosmart_api_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-04-01' = {
  parent: sites_termosmart_api_name_resource
  name: 'scm'
  location: 'West Europe'
  properties: {
    allow: true
  }
}

resource sites_index_name_web 'Microsoft.Web/sites/config@2024-04-01' = {
  parent: sites_index_name_resource
  name: 'web'
  location: 'North Europe'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v4.0'
    linuxFxVersion: 'PYTHON|3.11'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: 'REDACTED'
    scmType: 'None'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    publicNetworkAccess: 'Enabled'
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    elasticWebAppScaleLimit: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {}
  }
}

resource sites_termosmart_api_name_web 'Microsoft.Web/sites/config@2024-04-01' = {
  parent: sites_termosmart_api_name_resource
  name: 'web'
  location: 'West Europe'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v4.0'
    linuxFxVersion: 'PYTHON|3.11'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    remoteDebuggingVersion: 'VS2022'
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$termosmart-api'
    scmType: 'GitHubAction'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: false
    appCommandLine: 'pip install -r requirements.txt\ngunicorn -w 4 -k uvicorn.workers.UvicornWorker main:app'
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    publicNetworkAccess: 'Enabled'
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    elasticWebAppScaleLimit: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 1
    azureStorageAccounts: {}
  }
}

resource sites_termosmart_api_name_098a0776_4214_4a8e_87b0_bba9297f34ab 'Microsoft.Web/sites/deployments@2024-04-01' = {
  parent: sites_termosmart_api_name_resource
  name: '098a0776-4214-4a8e-87b0-bba9297f34ab'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'OneDeploy'
    message: 'OneDeploy'
    start_time: '2025-06-27T17:22:38.7547587Z'
    end_time: '2025-06-27T17:23:05.1589024Z'
    active: true
  }
}

resource sites_termosmart_api_name_156d504f_a46a_42d4_adc5_2b57fa2a1f54 'Microsoft.Web/sites/deployments@2024-04-01' = {
  parent: sites_termosmart_api_name_resource
  name: '156d504f-a46a-42d4-adc5-2b57fa2a1f54'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'OneDeploy'
    message: 'OneDeploy'
    start_time: '2025-06-20T20:37:13.7113802Z'
    end_time: '2025-06-20T20:37:54.4253005Z'
    active: false
  }
}

resource sites_termosmart_api_name_1c5cdf9b_f0e4_4062_86a8_771ea2a770ad 'Microsoft.Web/sites/deployments@2024-04-01' = {
  parent: sites_termosmart_api_name_resource
  name: '1c5cdf9b-f0e4-4062-86a8-771ea2a770ad'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'OneDeploy'
    message: 'OneDeploy'
    start_time: '2025-06-20T20:30:37.3971341Z'
    end_time: '2025-06-20T20:31:20.5693767Z'
    active: false
  }
}

resource sites_termosmart_api_name_239b233e_a43c_423b_a9a3_3375491dfaf0 'Microsoft.Web/sites/deployments@2024-04-01' = {
  parent: sites_termosmart_api_name_resource
  name: '239b233e-a43c-423b-a9a3-3375491dfaf0'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'OneDeploy'
    message: 'OneDeploy'
    start_time: '2025-06-20T20:47:04.9977379Z'
    end_time: '2025-06-20T20:47:46.2005968Z'
    active: false
  }
}

resource sites_termosmart_api_name_259fc9cb_5472_4192_92ec_a87edda6a3a2 'Microsoft.Web/sites/deployments@2024-04-01' = {
  parent: sites_termosmart_api_name_resource
  name: '259fc9cb-5472-4192-92ec-a87edda6a3a2'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'OneDeploy'
    message: 'OneDeploy'
    start_time: '2025-06-20T15:47:58.1260603Z'
    end_time: '2025-06-20T15:48:43.0007426Z'
    active: false
  }
}

resource sites_termosmart_api_name_5411755d_ac50_4687_a7a8_17e1ed5e92bf 'Microsoft.Web/sites/deployments@2024-04-01' = {
  parent: sites_termosmart_api_name_resource
  name: '5411755d-ac50-4687-a7a8-17e1ed5e92bf'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'OneDeploy'
    message: 'OneDeploy'
    start_time: '2025-06-27T17:12:34.6908845Z'
    end_time: '2025-06-27T17:13:09.7557755Z'
    active: false
  }
}

resource sites_termosmart_api_name_7641ff4e_05d2_4861_b86e_10a2fe29b4eb 'Microsoft.Web/sites/deployments@2024-04-01' = {
  parent: sites_termosmart_api_name_resource
  name: '7641ff4e-05d2-4861-b86e-10a2fe29b4eb'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'OneDeploy'
    message: 'OneDeploy'
    start_time: '2025-06-20T20:15:21.4438573Z'
    end_time: '2025-06-20T20:15:53.8976086Z'
    active: false
  }
}

resource sites_termosmart_api_name_856f0f2d_8dd6_4b6c_8c26_ef3c5d1f3d64 'Microsoft.Web/sites/deployments@2024-04-01' = {
  parent: sites_termosmart_api_name_resource
  name: '856f0f2d-8dd6-4b6c-8c26-ef3c5d1f3d64'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'OneDeploy'
    message: 'OneDeploy'
    start_time: '2025-06-20T15:56:59.7734811Z'
    end_time: '2025-06-20T15:57:59.5188816Z'
    active: false
  }
}

resource sites_termosmart_api_name_a1590536_6124_4532_a17b_3a4b9754747a 'Microsoft.Web/sites/deployments@2024-04-01' = {
  parent: sites_termosmart_api_name_resource
  name: 'a1590536-6124-4532-a17b-3a4b9754747a'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'OneDeploy'
    message: 'OneDeploy'
    start_time: '2025-06-20T20:19:18.1270675Z'
    end_time: '2025-06-20T20:21:54.0154955Z'
    active: false
  }
}

resource sites_termosmart_api_name_f9dedea0_db09_410c_ac38_0a480a867a20 'Microsoft.Web/sites/deployments@2024-04-01' = {
  parent: sites_termosmart_api_name_resource
  name: 'f9dedea0-db09-410c-ac38-0a480a867a20'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'OneDeploy'
    message: 'OneDeploy'
    start_time: '2025-06-20T20:46:02.4428317Z'
    end_time: '2025-06-20T20:46:33.966042Z'
    active: false
  }
}

resource sites_index_name_sites_index_name_dhcha3cwbabqcken_northeurope_01_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2024-04-01' = {
  parent: sites_index_name_resource
  name: '${sites_index_name}-dhcha3cwbabqcken.northeurope-01.azurewebsites.net'
  location: 'North Europe'
  properties: {
    siteName: 'index'
    hostNameType: 'Verified'
  }
}

resource sites_termosmart_api_name_sites_termosmart_api_name_akcndqc3agbuh5bf_westeurope_01_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2024-04-01' = {
  parent: sites_termosmart_api_name_resource
  name: '${sites_termosmart_api_name}-akcndqc3agbuh5bf.westeurope-01.azurewebsites.net'
  location: 'West Europe'
  properties: {
    siteName: 'termosmart-api'
    hostNameType: 'Verified'
  }
}

resource staticSites_termosmart_backend1_name_default 'Microsoft.Web/staticSites/basicAuth@2024-04-01' = {
  parent: staticSites_termosmart_backend1_name_resource
  name: 'default'
  location: 'West Europe'
  properties: {
    applicableEnvironmentsMode: 'SpecifiedEnvironments'
  }
}

resource staticSites_termosmart_backend1_name_termosmart_pl 'Microsoft.Web/staticSites/customDomains@2024-04-01' = {
  parent: staticSites_termosmart_backend1_name_resource
  name: 'termosmart.pl'
  location: 'West Europe'
  properties: {}
}

resource storageAccounts_termosmartstorage_name_default_azure_webjobs_eventhub 'Microsoft.Storage/storageAccounts/blobServices/containers@2024-01-01' = {
  parent: storageAccounts_termosmartstorage_name_default
  name: 'azure-webjobs-eventhub'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_termosmartstorage_name_resource
  ]
}

resource storageAccounts_termosmartstorage_name_default_azure_webjobs_hosts 'Microsoft.Storage/storageAccounts/blobServices/containers@2024-01-01' = {
  parent: storageAccounts_termosmartstorage_name_default
  name: 'azure-webjobs-hosts'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_termosmartstorage_name_resource
  ]
}

resource storageAccounts_termosmartstorage_name_default_azure_webjobs_secrets 'Microsoft.Storage/storageAccounts/blobServices/containers@2024-01-01' = {
  parent: storageAccounts_termosmartstorage_name_default
  name: 'azure-webjobs-secrets'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_termosmartstorage_name_resource
  ]
}

resource storageAccounts_termosmartstorage_name_default_scm_releases 'Microsoft.Storage/storageAccounts/blobServices/containers@2024-01-01' = {
  parent: storageAccounts_termosmartstorage_name_default
  name: 'scm-releases'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_termosmartstorage_name_resource
  ]
}

resource storageAccounts_termosmartstorage_name_default_telemetry 'Microsoft.Storage/storageAccounts/blobServices/containers@2024-01-01' = {
  parent: storageAccounts_termosmartstorage_name_default
  name: 'telemetry'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_termosmartstorage_name_resource
  ]
}

resource storageAccounts_termosmartstorage_name_default_termosmartfunction970bbe2235a2 'Microsoft.Storage/storageAccounts/fileServices/shares@2024-01-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_termosmartstorage_name_default
  name: 'termosmartfunction970bbe2235a2'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 102400
    enabledProtocols: 'SMB'
  }
  dependsOn: [
    storageAccounts_termosmartstorage_name_resource
  ]
}

resource storageAccounts_termosmartstorage_name_default_AzureFunctionsDiagnosticEvents202506 'Microsoft.Storage/storageAccounts/tableServices/tables@2024-01-01' = {
  parent: Microsoft_Storage_storageAccounts_tableServices_storageAccounts_termosmartstorage_name_default
  name: 'AzureFunctionsDiagnosticEvents202506'
  properties: {}
  dependsOn: [
    storageAccounts_termosmartstorage_name_resource
  ]
}
