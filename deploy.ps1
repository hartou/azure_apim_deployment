param
(
    [string]$name = "smarfin$(Get-Random)",# Enter a base name for the resource.
	[string] $deploymentName = "smartfin-$(Get-Random)",
    [string]$RGName = "${name}-rg",
    [string]$paramFileName = "./parameters.json",
    [string]$templateFileName = "./main.bicep",
    [string]$location= "eastus",
    # [string]$subscriptionId="$(az account list --query "[?isDefault].id" -o tsv)",
    [string]$subscriptionId="Enter your subscription id",
    # [string]$keyVaultName="${name}-kv"
    #[string]$serverPassword_Scrt=$(read-host -Prompt "Enter sql server password"),
	#[string]$wordpressPassword_Scrt=$(read-host -Prompt "Enter sql server password"),
	[PSCredential]$serverPassword=([xml](Get-Content env.xml)).root.SQLServerPassword,
    [PSCredential]$laravelUserPassword=([xml](Get-Content env.xml)).root.laravelUserPassword
)


# Set a default subscription for the current session.
# az account set --subscription $subscriptionId

# Create a resource group.
az group create --name $RGName --location $location

# az ad sp create-for-rbac --name "${name}-sp" --role contributor `
#  --scopes /subscriptions/$subscriptionId/resourceGroups/$RGName --create-cert 


# Create Key Vault and store secrets
# az keyvault create --name $keyVaultName --resource-group $RGName --location $location `
#  --enabled-for-template-deployment true
# echo $serverPassword 
# echo $wordpressPassword


#Get value from secureStrings 
#$serverPassword= [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($serverPassword_Scrt))
#$wordpressPassword= [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($wordpressPassword_Scrt))

# or you can also use the following command to get the value from secureStrings
#$serverPassword=[System.Runtime.InteropServices.Marshal]::PtrToStringAuto($serverPassword_Scrt)
#$wordpressPassword=[System.Runtime.InteropServices.Marshal]::PtrToStringAuto($wordpressPassword_Scrt)


# Deploy the template to the resource group

az deployment group create `
  --resource-group <resource-group-name> `
  --template-file <bicep-file-name>.bicep `
  --parameters apimName=<apim-name> apiName=<api-name>
