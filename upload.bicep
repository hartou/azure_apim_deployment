@description('Specifies the location for resources.')
param location string = 'eastus'
param storageAccountName string
param containerName string
param blobName string
param filePath string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

// Create a blob service in the storage account
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-04-01' = {
  parent: storageAccount
  name: 'default'
}


resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  parent: blobService
  name: containerName
  properties: {
    publicAccess: 'None'
  }
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'upload-file'
  location: location
  kind: 'AzureCLI'
  properties: {
    storageAccountName: storageAccountName
    containerName: containerName
    blobName: blobName
    filePath: filePath
    scriptContent: loadTextContent('test.txt')
    arguments: '${storageAccountName} ${containerName} ${blobName} ${filePath}'
    azCliVersion: '2.24.2'
  }
  dependsOn: [
    storageContainer
  ]
}
