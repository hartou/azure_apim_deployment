@description('Specifies the location for resources.')
param location string = 'eastus'


param wsdlFileName string
param storageAccountName string
param storageContainerName string
param storageSkuName string = 'Standard_LRS'
param storageSkuKind string = 'StorageV2'





resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageSkuName
  }
  kind: storageSkuKind
}

resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: storageContainerName
  properties: {
    publicAccess: 'None'
  } 
  dependsOn: [
    storageAccount
  ]
}



resource wsdlBlob 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  parent: storageAccount
  name: wsdlFileName
  properties: {
    contentType: 'application/wsdl+xml'
    content: filebase64('path/to/local/file.wsdl')
  }
  dependsOn: [
    storageContainer
  ]
}

resource api 'Microsoft.ApiManagement/service/apis@2021-11-01' = {
  name: '${apim.name}/${apiName}'
  properties: {
    displayName: apiName
    format: 'soap'
    value: wsdlBlob.properties.contentLink
  }
  dependsOn: [
    apim
    wsdlBlob
  ]
}
