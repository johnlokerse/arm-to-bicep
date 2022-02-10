param myString string
param myInt int
param myArray bool
param myBool object
param myObject array

@secure()
param mySecureString

@description('This parameter has a max length of 4.')
@maxLength(4)
param myDescriptionDecorator string

@description('This string can only contain values: development or test')
@allowed([
  'development'
  'test'
])
param myEnvironments string

@description('This parameter contains a default value')
param myPrefix string = 'euw-${uniqueString(resourceGroup().id)}-'
