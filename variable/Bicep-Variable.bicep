@allowed([
  'D'
  'T'
  'A'
  'P'
])
param myEnvironment string

// var <variable-name> = <variable-value>
var myName = 'John'

var setting = {
  D: {
    environmentName: 'development'
    sku: 'basic'
  }
  T: {
    environmentName: 'myTestEnvironment'
    sku: 'basic'
  }
  A: {
    environmentName: 'myAccEnvironment'
    sku: 'premium'
  }
  P: {
    environmentName: 'myPrdEnvironment'
    sku: 'premium'
  }
}

output envName string = setting[myEnvironment].environmentName
output skuSize string = setting[myEnvironment].sku
