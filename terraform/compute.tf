data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "vm" {
  name        = "${local.prefix}-vm"
  platform_id = "standard-v3"
  zone        = var.zone
  folder_id   = var.folder_id

  depends_on = [null_resource.build_and_push]

  lifecycle {
    replace_triggered_by = [
      null_resource.build_and_push,
      yandex_container_registry.main,
    ]
  }

  resources {
    cores         = var.vm_cores
    memory        = var.vm_memory
    core_fraction = 50
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.vm_disk_size
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.main.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.vm_sg.id]
  }

  metadata = {
    user-data = templatefile("${path.module}/templates/cloud-init.yaml.tftpl", {
      username               = var.vm_username
      ssh_public_key         = var.vm_ssh_public_key
      registry_url           = local.registry_url
      db_host                = yandex_mdb_mysql_cluster.main.host[0].fqdn
      db_password            = local.db_password
      db_name                = var.db_name
      db_user                = var.db_user
      image_tag              = var.image_tag
      nginx_conf             = local.nginx_conf
      docker_compose_content = local.docker_compose_content
      app_port               = local.app_port
    })
  }

  service_account_id = yandex_iam_service_account.vm_sa.id
}
