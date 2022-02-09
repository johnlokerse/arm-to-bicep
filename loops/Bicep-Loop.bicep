var amountOfAccounts = 3
var baseName = uniqueString(resourceGroup().id)

resource myStorageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = [for i in range(0, amountOfAccounts): {
  name: '${baseName}stg${i}'
  kind: 'StorageV2'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
}]
