
##Cluster Variables

variable "client_id" {
    ##default = "844f26e1-a9a8-46a3-8e18-0bedd6d780d2"
    default = "${var.client_id}"
    
}

variable "client_secret" {
    ##default = "p5kG.oqjBEZ2LyiMmIUdeJc2Z139b4I6Yb"
    default = "${var.client_secret}"
}

variable "agent_count" {
    default = 2
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "k8stest"
}

variable cluster_name {
    default = "k8stest"
}

variable resource_group_name {
    default = "azure-k8stest"
}

variable location {
    default = "Brazil South"
}

## Logs

variable log_analytics_workspace_name {
    default = "testLogAnalyticsWorkspaceName"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    default = "eastus"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}