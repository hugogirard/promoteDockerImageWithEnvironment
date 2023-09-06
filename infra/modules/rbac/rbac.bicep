
param roleDefinitionId string = '8311e382-0749-4cb8-b61a-304f252e45ec'
param objectId string
param acrName string

resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' existing = {
  name: acrName
}

resource acrRoleAssignement 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(roleDefinitionId,objectId,acr.id)
  scope: acr
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: objectId
    principalType: 'ServicePrincipal'
  }
}
