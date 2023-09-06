param location string
param env string
param suffix string

resource aks 'Microsoft.ContainerService/managedClusters@2023-06-01' = {
  name: 'aks-${env}-${suffix}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: '1.27.3'
    enableRBAC: true
    dnsPrefix: 'aks-${env}-${suffix}'    
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1
        enableAutoScaling: false
        vmSize: 'Standard_D2_v2'
        osType: 'Linux'
        mode: 'System'
        enableNodePublicIP: false
      }
    ]
    networkProfile: {
      loadBalancerSku: 'standard'
      networkPlugin: 'kubenet'
    }
    autoUpgradeProfile: {
      upgradeChannel: 'patch'
    }
    aadProfile: {
      managed: true
      adminGroupObjectIDs: [
        '00000000-0000-0000-0000-000000000000'
      ]
      enableAzureRBAC: false
    }    
  }  
}
