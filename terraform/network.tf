resource "yandex_vpc_network" "main" {
  name = "${local.prefix}-vpc"
  folder_id = var.folder_id
}
resource "yandex_vpc_subnet" "main" {
  name = "${local.prefix}-subnet"
  network_id = yandex_vpc_network.main.id
  zone = var.zone
  v4_cidr_blocks = [var.subnet_cidr]
  folder_id = var.folder_id
}

resource "yandex_vpc_security_group" "vm_sg" {
  name       = "${local.prefix}-sg"
  network_id = yandex_vpc_network.main.id
  folder_id  = var.folder_id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "SSH"
  }

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "HTTP"
  }

  ingress {
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "HTTPS"
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "All outbound"
  }
}

