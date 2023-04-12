param location string = resourceGroup().location



module apim 'apim.bicep' = {
  name: 'apim'
  params: {
    apimName: 'apim'
    apimSku: 'Developer'
    apimCapacity: 1
    apimLocation: 'westeurope'
    apimPublisherName: 'Contoso'
    apimPublisherEmail: 'email@email.com'
    apimPublisherWebsite: 'https://contoso.com'
    location: location
    apiDisplayName:
    apiName:
    publisherEmail:
    publisherName:
  }
}
