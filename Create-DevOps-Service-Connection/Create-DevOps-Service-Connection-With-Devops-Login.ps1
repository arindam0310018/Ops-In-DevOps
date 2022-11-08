##############
# VARIABLES:-
############## 
$spiname = "AM-Test-SPI-001"
$devopsOrg = "https://dev.azure.com/arindammitra0251/"
$devopsPrj = "AMCLOUD"
$subsID = "210e66cb-55cf-424e-8daa-6cad804ab604"
$subsName = "AM-PROD-VS"
$tenantID = "20516b3d-42af-4bd4-b2e6-e6b4051af72a"


##############
# CORE SCRIPT:-
############## 

# Create Service Principal and Store Secret:-
$spipasswd = az ad sp create-for-rbac -n $spiname --query "password" -o tsv

# Fetch the Service Principal Application ID:-
$spiID = az ad sp list --display-name $spiname --query [].appId -o tsv

$env:AZURE_DEVOPS_EXT_AZURE_RM_SERVICE_PRINCIPAL_KEY=$spipasswd

# Perform DevOps Login:-
az devops login

# Configure Default DevOps Organisation and Project:-
az devops configure --defaults organization=$devopsOrg project=$devopsPrj

# Create DevOps Service Connection:-
az devops service-endpoint azurerm create --azure-rm-service-principal-id $spiID --azure-rm-subscription-id $subsID --azure-rm-subscription-name $subsName --azure-rm-tenant-id $tenantID --name $spiname --org $devopsOrg --project $devopsPrj

# Grant Access to all Pipelines to the Newly Created DevOps Service Connection:-
$srvEndpointID = az devops service-endpoint list --query "[?name=='$spiname'].id" -o tsv
az devops service-endpoint update --id $srvEndpointID --enable-for-all
