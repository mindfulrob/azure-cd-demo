variable "client_id" {
  type =  string
  sensitive = true
}

variable "client_secret" {
  type =  string
  sensitive = true
}

variable "subscription_id" {
  type =  string
  sensitive = true
}

variable "tenant_id" {
  type =  string
  sensitive = true
}

source "azure-arm" "autogenerated_1" {
  azure_tags = {
    dept = "Engineering"
    task = "Image deployment"
  }
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  tenant_id                         = var.tenant_id
  subscription_id                   = var.subscription_id
  image_offer                       = "UbuntuServer"
  image_publisher                   = "Canonical"
  image_sku                         = "16.04-LTS"
  location                          = "East US"
  managed_image_name                = "robandpdxPackerImage"
  managed_image_resource_group_name = "robandpdxPacker"
  os_type                           = "Linux"
  vm_size                           = "Standard_DS2_v2"
}

build {
  sources = ["source.azure-arm.autogenerated_1"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = [
      "echo set debconf to Noninteractive", 
      "echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",
      "apt-get update",
      "apt-get upgrade -y",
      "apt-get -y install nginx",
      "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
    ]
    inline_shebang  = "/bin/sh -x"
  }

}