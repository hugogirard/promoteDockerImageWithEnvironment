targetScope = 'subscription'

@minLength(1)
@description('Primary location for all resources')
param location string = 'canadacentral'


var suffix = uniqueString(subscription().subscriptionId)

var configuration = [
  {
    'rgName': 'rg-dev-${suffix}'
    'acrName': 'acrdev${suffix}'    
  }
  {
    'rgName': 'rg-qa-${suffix}'
    'acrName': 'acrqa${suffix}'    
  }
  {
    'rgName': 'rg-prod-${suffix}'
    'acrName': 'acrprod${suffix}'        
  }
]

resource rgDev 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: configuration[0].rgName
  location: location
}

resource rgQA 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: configuration[1].rgName
  location: location
}

resource rgProd 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: configuration[2].rgName
  location: location
}

module acrDev 'modules/acr/acr.bicep' = {
  scope: resourceGroup(rgDev.name)
  name: configuration[0].acrName
  params: {
    env: 'dev'
    location: location
    suffix: suffix
  }
}

module acrQa 'modules/acr/acr.bicep' = {
  scope: resourceGroup(rgQA.name)
  name: configuration[1].acrName
  params: {
    env: 'qa'
    location: location
    suffix: suffix
  }
}

module acrProd 'modules/acr/acr.bicep' = {
  scope: resourceGroup(rgProd.name)
  name: configuration[2].acrName
  params: {
    env: 'prod'
    location: location
    suffix: suffix
  }
}

module aksDev 'modules/aks/aks.bicep' = {
  scope: resourceGroup(rgDev.name)
  name: 'aksDev'
  params: {
    env: 'dev'
    location: location
    suffix: suffix
  }
}
