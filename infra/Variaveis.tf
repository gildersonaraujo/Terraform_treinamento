variable "resource_group_location" {
  //default     = "eastus"
  description = "Location of the resource group."
}

variable "rg_name" {
  type        = string
  default     = "RG-AVD"
  description = "Name of the Resource group in which to deploy service objects"
}



variable "workspace" {
  type        = string
  description = "Name of the Azure Virtual Desktop workspace"
  default     = "Workspace"
}

variable "hostpool" {
  type        = string
  description = "Name of the Azure Virtual Desktop host pool"
  default     = "AVD-"
}

variable "rfc3339" {
  type        = string
  default     = "2022-03-30T12:43:13Z"
  description = "Registration token expiration"
}

variable "prefix" {
  type        = string
  default     = "avd"
  description = "Prefix of the name of the AVD machine(s)"
}

variable "ambiente" {
  type        = string
  description = "Ambiente DEV , TEST ,PROD"

}

variable "sub_desktop" {
  description = "Subrede para os desktops AVD"
  default     = "Sub_Desktop"

}

variable "rg_shared_name" {
  type        = string
  default     = "rg-shared-resources"
  description = "Name of the Resource group in which to deploy shared resources"
}

variable "deploy_location" {
  type        = string
  default     = "eastus"
  description = "The Azure Region in which all resources in this example should be created."
}

variable "ad_vnet" {
  type        = string
  default     = "infra-network"
  description = "Name of domain controller vnet"
}

variable "dns_servers" {
  type        = list(string)
  default     = ["10.0.0.4"]
  description = "Custom DNS configuration"
}

variable "vnet_range" {
  type        = list(string)
  default     = ["10.2.0.0/16"]
  description = "Address range for deployment VNet"
}
variable "subnet_range" {
  type        = list(string)
  default     = ["10.2.0.0/24"]
  description = "Address range for session host subnet"
}


variable "rg" {
  type        = string
  default     = "rg-avd-compute"
  description = "Name of the Resource group in which to deploy session host"
}

variable "rdsh_count" {
  description = "Number of AVD machines to deploy"
  default     = 2
}


# Domain Join
variable "domain_name" {
  type        = string
  default = "Studyaz140.onmicrosoft.com"
}
variable "domain_user_upn" {
  type        = string
  default = "svc_ad"
}
variable "domain_password" {
  type        = string
  default = "Niver@2712"

}
variable "ou_path" {
  type        = string
  default = "OU=Vms_AVD,OU=Projeto_AVD,DC=Studyaz140,DC=onmicrosoft,DC=com"
}


variable "vm_size" {
  description = "Size of the machine to deploy"
  default     = "Standard_DS2_v2"
}


variable "local_admin_username" {
  type        = string
  default     = "localadm"
  description = "local admin username"
}

variable "local_admin_password" {
  type        = string
  default     = "ChangeMe123!"
  description = "local admin password"
  sensitive   = true
}



# output "registration_token" {
#   value = azurerm_virtual_desktop_host_pool_registration_info.registration_token.id
  
# }

variable "avd_users" {
  description = "AVD users"
  default = [
    "useravd01@studyaz140.onmicrosoft.com",
    "svc_ad@Studyaz140.onmicrosoft.com"
  ]
}
