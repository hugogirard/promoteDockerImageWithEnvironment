targetScope = 'subscription'

@minLength(1)
@description('Primary location for all resources')
param location string = 'canadacentral'

@secure()
param adminGroupId string 
@secure()
param spObjectId string


var suffix = uniqueString(subscription().subscriptionId)

var configuration = [
  {
    rgName: 'rg-dev-${suffix}'
    acrName: 'acrdev${suffix}'    
  }
  {
    rgName: 'rg-qa-${suffix}'
    acrName: 'acrqa${suffix}'    
  }
  {
    rgName: 'rg-prod-${suffix}'
    acrName: 'acrprod${suffix}'        
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

module rbacAcrDev 'modules/rbac/rbac.bicep' = {
  scope: resourceGroup(rgDev.name)
  name: 'rbacAcrDev'
  params: {
    acrName: acrDev.outputs.acrName
    objectId: spObjectId
  }
}

module rbacAcrQa 'modules/rbac/rbac.bicep' = {
  scope: resourceGroup(rgQA.name)
  name: 'rbacAcrQa'
  params: {
    acrName: acrQa.outputs.acrName
    objectId: spObjectId
  }
}

module rbacAcrProd 'modules/rbac/rbac.bicep' = {
  scope: resourceGroup(rgProd.name)
  name: 'rbacAcrProd'
  params: {
    acrName: acrProd.outputs.acrName
    objectId: spObjectId
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
    adminGroupId: adminGroupId
  }
}

module aksQa 'modules/aks/aks.bicep' = {
  scope: resourceGroup(rgQA.name)
  name: 'aksQa'
  params: {
    env: 'qa'
    location: location
    suffix: suffix
    adminGroupId: adminGroupId
  }
}


module aksProd 'modules/aks/aks.bicep' = {
  scope: resourceGroup(rgProd.name)
  name: 'aksProd'
  params: {
    env: 'prod'
    location: location
    suffix: suffix
    adminGroupId: adminGroupId
  }
}


output acrFqdn string = '${acrDev.outputs.acrName}.azurecr.io'
output acrDevName string = acrDev.outputs.acrName
output acrQaName string = acrQa.outputs.acrName
output acrProdName string = acrProd.outputs.acrName

output aksDevName string = aksDev.outputs.aksName
output aksQaName string = aksQa.outputs.aksName
output aksProdName string = aksProd.outputs.aksName

output rgDevName string = rgDev.name
output rgQaName string = rgQA.name
output rgProdName string = rgProd.name
