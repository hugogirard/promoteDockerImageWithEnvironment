param location string
param env string
param suffix string
param adminGroupId string

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
        vmSize: 'Standard_B4ms'
        mode: 'System'        
        osType: 'Linux'
        osDiskSizeGB: 30        
        type: 'VirtualMachineScaleSets'
        maxPods: 110
        enableNodePublicIP: false   
      }
    ]
    disableLocalAccounts: false
    networkProfile: {
      loadBalancerSku: 'standard'
      networkPlugin: 'kubenet'
    }
    autoUpgradeProfile: {
      upgradeChannel: 'patch'
    }
    aadProfile: {
      managed: true
      tenantID: subscription().tenantId
      adminGroupObjectIDs: [
        adminGroupId
      ]
      enableAzureRBAC: false
    } 
    apiServerAccessProfile: {
      enablePrivateCluster: false
    }
    addonProfiles: {
      azurePolicy: {
        enabled: false
      }      
    }       
  }  
}
