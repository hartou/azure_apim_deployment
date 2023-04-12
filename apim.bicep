param apimName string
param apiName string
param location string = resourceGroup().location

param publisherName string
param publisherEmail string
param apiDisplayName string
param apiskuName string = 'Standard'
param skuCapacity int = 1

param apimName string
param apiName string
param wsdlUrl string


resource apim 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: apiDisplayName
  location: location
   sku: {
    name: apiskuName
    capacity: skuCapacity
     } 
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}

resource api 'Microsoft.ApiManagement/service/apis@2022-08-01' = {
  parent: apim
  name: apiName
  properties: {
    displayName: apiName
    format: 'swagger-link-json'
    value: 'https://petstore.swagger.io/v2/swagger.json'
    path:'/petstore'
  }
}


// WSDL API for petstore example

resource apiwdsl 'Microsoft.ApiManagement/service/apis@2022-08-01' = {
  parent: apim
  name: apiName
  properties: {
    displayName: apiName
    format: 'soap'
    value: wsdlUrl
    path:'/petstore'
  }
}


param apimName string
param apiName string
param wsdlFileName string
param storageAccountName string
param storageContainerName string

resource apim 'Microsoft.ApiManagement/service@2021-11-01' = {
  name: apimName
  location: 'eastus'
  sku: {
    name: 'Developer'
    capacity: 1
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: 'eastus'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: storageContainerName
  dependsOn: [
    storageAccount
  ]
  properties: {
    publicAccess: 'None'
  }
}

resource wsdlBlob 'Microsoft.Storage/storageAccounts/blobServices/containers/blobs@2021-04-01' = {
  name: '${storageAccount.name}/${storageContainer.name}/${wsdlFileName}'
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
