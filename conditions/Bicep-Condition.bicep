param virtualNetworkName string
param subnetName string

resource myVnet 'Microsoft.Network/virtualNetworks@2019-11-01' = if (!empty(virtualNetworkName)) {
  name: virtualNetworkName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: !empty(subnetName) ? subnetName : 'myFalseConditionName'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}
