
resource "azurerm_resource_group" "MC_azure-k8stest_k8stest_brazilsouth" {
  name     = "MC_azure-k8stest_k8stest_brazilsouth"
  location = "Brazil_South"
}

resource "azurerm_virtual_network" "aks-vnet-21324540   " {
  name                = "aks-vnet-21324540"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.MC_azure-k8stest_k8stest_brazilsouth.location
  resource_group_name = azurerm_resource_group.MC_azure-k8stest_k8stest_brazilsouth.name
}

resource "azurerm_subnet" "aks-subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.MC_azure-k8stest_k8stest_brazilsouth.name
  virtual_network_name = azurerm_virtual_network.aks-vnet-21324540.name
  address_prefix       = "10.0.2.0/24"
}


## Load Balancer incompleto
resource "azurerm_public_ip" "ip-externo" {
  name                = "ip-externo"
  location            = azurerm_resource_group.MC_azure-k8stest_k8stest_brazilsouth.location
  resource_group_name = azurerm_resource_group.MC_azure-k8stest_k8stest_brazilsouth.name
  allocation_method   = "Static"
 
  
  tags = {
    environment = "Production"
  }
 
}


resource "azurerm_lb" "azure-lb1" {
  name                = "azure-lb1"
  location            = azurerm_resource_group.MC_azure-k8stest_k8stest_brazilsouth.location
  resource_group_name = azurerm_resource_group.MC_azure-k8stest_k8stest_brazilsouth.name

  frontend_ip_configuration {
    name                 = "primary"
    public_ip_address_id = azurerm_public_ip.ip-externo.id
  }
}

resource "azurerm_lb_backend_address_pool" "azure-lb-backend-pool" {
  resource_group_name = azurerm_resource_group.MC_azure-k8stest_k8stest_brazilsouth.name
  loadbalancer_id     = azurerm_lb.azure-lb1.id
  name                = "acctestpool"
}

resource "azurerm_network_interface" "azure-nic1" {
  name                = "azure-nic1"
  location            = azurerm_resource_group.MC_azure-k8stest_k8stest_brazilsouth.location
  resource_group_name = azurerm_resource_group.MC_azure-k8stest_k8stest_brazilsouth.name

  ip_configuration {
    name                          = "testeconf1"
    subnet_id                     = azurerm_subnet.aks-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "az-backend-pool-assc" {
  network_interface_id    = azurerm_network_interface.azure-nic1.id
  ip_configuration_name   = "testeconf1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.azure-lb-backend-pool.id
}

##Dns

resource "azurerm_dns_zone" "dns-public" {
  name                = "publicdomain.com"
  resource_group_name = azurerm_resource_group.MC_azure-k8stest_k8stest_brazilsouth.name
}

resource "azurerm_private_dns_zone" "dns-private" {
  name                = "privatedomain.com"
  resource_group_name = azurerm_resource_group.MC_azure-k8stest_k8stest_brazilsouth.name
}




