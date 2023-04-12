

# Define variables
$storageAccountName= "jrltestsa"
$containerName="jrltestcontainer"
$blobName="jrltestblob"
$filePath="~/test.txt"
$RGName="jrltestRG"
$location="eastus"

# Create a resource group.
az group create --name $RGName --location $location

# Create storage account and container

az storage account create --name $storageAccountName  `
--resource-group $RGName --location $location --sku Standard_LRS


az storage container create `
    --account-name $storageAccountName `
    --name $containerName
# Upload file to container
az storage blob upload `
    --account-name $storageAccountName `
    --account-key $(az storage account keys list --account-name $storageAccountName --query '[0].value' -o tsv) `
    --container-name $containerName `
    --name $blobName `
    --type block `
    --file $filePath
