resource "azurerm_resource_group" "testvm" {
  name = "${var.prefix}-rg"
  location = var.region
  tags = {
    "site" = "${var.prefix}.com"
  }
}

resource "azurerm_dns_zone" "suitest" {
    name = "${var.prefix}.com"
    resource_group_name = azurerm_resource_group.testvm.name
    tags = {
      "site" = "${var.prefix}.com"
    } 
}

resource "azurerm_virtual_network" "suivnet" {
    name = "${var.prefix}-vnet"
    address_space = [ "10.0.0.0/16" ]
    location = azurerm_resource_group.testvm.location
    resource_group_name = azurerm_resource_group.testvm.name
    tags = {
      "site" = "${var.prefix}.com"
    }
}

resource "azurerm_subnet" "internal" {
    name = "internal"
    resource_group_name = azurerm_resource_group.testvm.name
    virtual_network_name = azurerm_virtual_network.suivnet.name
    address_prefixes = [ "10.0.1.0/24" ]
}

resource "azurerm_public_ip" "external" {
    name = "external"
    location = azurerm_resource_group.testvm.location
    resource_group_name = azurerm_resource_group.testvm.name
    allocation_method = "Static"
    tags = {
      "site" = "${var.prefix}.com"
    }
}

resource "azurerm_network_security_group" "suinsg" {
    name = "${var.prefix}-nsg"
    location = azurerm_resource_group.testvm.location
    resource_group_name = azurerm_resource_group.testvm.name
    tags = {
        "site" = "${var.prefix}.com"
    }
}

resource "azurerm_network_security_rule" "ssh_allow" {
    name = "SSH"
    priority = 1001
    protocol = "TCP"
    direction = "Inbound"
    access = "Allow"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    source_port_range = "*"
    destination_port_range = "22"
    resource_group_name = azurerm_resource_group.testvm.name
    network_security_group_name = azurerm_network_security_group.suinsg.name
}

resource "azurerm_network_security_rule" "rpc" {
    name = "RPC"
    priority = 1002
    protocol = "TCP"
    direction = "Inbound"
    access = "Allow"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    source_port_range = "*"
    destination_port_range = "9000"
    resource_group_name = azurerm_resource_group.testvm.name
    network_security_group_name = azurerm_network_security_group.suinsg.name
}

resource "azurerm_network_security_rule" "metrics" {
    name = "Metrics"
    priority = 1003
    protocol = "TCP"
    direction = "Inbound"
    access = "Allow"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    source_port_range = "*"
    destination_port_range = "9184"
    resource_group_name = azurerm_resource_group.testvm.name
    network_security_group_name = azurerm_network_security_group.suinsg.name
}

resource "azurerm_subnet_network_security_group_association" "sec-group-association" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.suinsg.id
}

resource "azurerm_network_interface" "suinic" {
    name = "${var.prefix}-nic"
    location = azurerm_resource_group.testvm.location
    resource_group_name = azurerm_resource_group.testvm.name
    ip_configuration {
        name = "${var.prefix}-nic_conf"
        subnet_id = azurerm_subnet.internal.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.external.id
    }
    tags = {
        "site" = "${var.prefix}.com"
    }
}

resource "azurerm_virtual_machine" "suivm" {
    name = "${var.prefix}-vm"
    location = azurerm_resource_group.testvm.location
    resource_group_name = azurerm_resource_group.testvm.name
    network_interface_ids = [azurerm_network_interface.suinic.id]
    vm_size = "Standard_D2s_v3"
    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }
    storage_os_disk {
        name = "${var.prefix}-disk"
        caching = "ReadWrite"
        create_option = "FromImage"
        managed_disk_type = "StandardSSD_LRS"
    }
    os_profile {
        computer_name = var.prefix
        admin_username = "ubuntu"
        custom_data = data.template_file.init_script.rendered
    }
    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path = "/home/ubuntu/.ssh/authorized_keys"
            key_data = file("~/.ssh/${var.prefix}.pub")
        }
    }
    tags = {
        "site" = "${var.prefix}.com"
    }
}
