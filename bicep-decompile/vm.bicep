param virtualMachineName string
param adminUserName string

var prefix_var = 'euw-${virtualMachineName}-'

resource abcdefstorage 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: toLower('abcdefstorage')
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

resource prefix_PublicIP 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: '${prefix_var}PublicIP'
  location: resourceGroup().location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: toLower('myVM')
    }
  }
}

resource prefix_nsg 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: '${prefix_var}nsg'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'nsgRule1'
        properties: {
          description: 'description'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource prefix_VirtualNetwork 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: '${prefix_var}VirtualNetwork'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: '${prefix_var}VirtualNetwork-Subnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: prefix_nsg.id
          }
        }
      }
    ]
  }
}

resource prefix_VirtualNetworkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: '${prefix_var}VirtualNetworkInterface'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: prefix_PublicIP.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', '${prefix_var}VirtualNetwork', '${prefix_var}VirtualNetwork-Subnet')
          }
        }
      }
    ]
  }
  dependsOn: [
    prefix_VirtualNetwork
  ]
}

resource prefix 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: prefix_var
  location: resourceGroup().location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_A2_v2'
    }
    osProfile: {
      computerName: 'myVM'
      adminUsername: adminUserName
      adminPassword: 'adminPassword'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2012-R2-Datacenter'
        version: 'latest'
      }
      osDisk: {
        name: 'myVMOSDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: prefix_VirtualNetworkInterface.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: abcdefstorage.properties.primaryEndpoints.blob
      }
    }
  }
}