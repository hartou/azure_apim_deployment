@description('Location of the blob storage.')
param location string = resourceGroup().location

var _fxv_0 = '\r\n$localFileName = "\${env:csvFileName}"\r\n\r\nInvoke-WebRequest -Uri "\${env:contentUri}" -OutFile $localFileName\r\n\r\n$ctx = New-AzStorageContext -StorageAccountName "\${Env:SAName}" -StorageAccountKey "\${Env:storageKey}"\r\n\r\nSet-AzStorageBlobContent -Container "\${Env:ContainerName}" -Blob "\${env:csvInputFolder}/$localFileName" -Context $ctx -StandardBlobTier \'Hot\' -File $localFileName\r\n'
var contentUri = uri('https://azbotstorage.blob.${environment().suffixes.storage}', '/sample-artifacts/data-factory/moviesDB2.csv')
var csvFilename = last(split(contentUri, '/'))
var storageAccountName = 'storage${uniqueString(resourceGroup().id)}'
var csvInputFolder = 'input'
var blobContainerName = 'datafactory'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource storageAccountName_default_blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  name: '${storageAccountName}/default/${blobContainerName}'
  dependsOn: [
    storageAccount
  ]
}

resource copyFile 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'copyFile'
  location: location
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '8.0'
    environmentVariables: [
      {
        name: 'storageKey'
        secureValue: listKeys(storageAccount.id, '2021-09-01').keys[0].value
      }
      {
        name: 'SAName'
        value: storageAccountName
      }
      {
        name: 'ContainerName'
        value: blobContainerName
      }
      {
        name: 'contentUri'
        value: contentUri
      }
      {
        name: 'csvFileName'
        value: csvFilename
      }
      {
        name: 'csvInputFolder'
        value: csvInputFolder
      }
    ]
    scriptContent: _fxv_0
    timeout: 'PT1H'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
  }
  dependsOn: [
    resourceId('Microsoft.Storage/storageAccounts/blobServices/containers', split('${storageAccountName}/default/${blobContainerName}', '/')[0], split('${storageAccountName}/default/${blobContainerName}', '/')[1], split('${storageAccountName}/default/${blobContainerName}', '/')[2])

  ]
}
