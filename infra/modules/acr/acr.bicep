param location string
param suffix string
@minLength(2)
param env string

resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: 'acr${env}${suffix}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    adminUserEnabled: true
  }
}

output acrResourceId string = acr.id
output acrName string = acr.name
