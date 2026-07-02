resource "yandex_mdb_mysql_cluster" "main" {
  name        = "${local.prefix}-mysql"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.main.id
  version     = "8.0"

  resources {
    resource_preset_id = "b2.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 10
  }

  database { name = var.db_name }

  user {
    name     = var.db_user
    password = local.db_password

    permission {
      database_name = var.db_name
      roles         = ["ALL"]
    }
  }

  host {
    zone             = var.zone
    subnet_id        = yandex_vpc_subnet.main.id
    assign_public_ip = false
  }
}

