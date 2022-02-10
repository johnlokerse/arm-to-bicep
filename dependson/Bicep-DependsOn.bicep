// Implicit dependency
resource nsg 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'euw-nsg-vm'
  location: resourceGroup().location
}

resource nsgRule 'Microsoft.Network/networkSecurityGroups/securityRules@2019-11-01' = {
  name: '${nsg}/AllowAllRule'
  properties: {
    description: 'Allow all'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
  }
}

// Explicit dependency
resource contosoZone 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: 'contoso.com'
  location: 'global'
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'euw-contoso'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
  dependsOn: [
    dnsZone
  ]
}

// Nested resources
resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: 'dnszone.com'
  location: resourceGroup().location

  resource aRecord 'A@2018-05-01' = {
    name: 'google'
    properties: {
      TTL: 3600
      ARecords: [
        {
          ipv4Address: '142.251.36.4'
        }
      ]
    }
  }

  resource cnameRecord 'CNAME@2018-05-01' = {
    name: 'opensource'
    properties: {
      TTL: 600
      CNAMERecord: {
        cname: 'opensource.microsoft.com'
      }
    }
  }
}
