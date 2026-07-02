output "vm_external_ip" {
  value = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}

output "registry_url" {
  value = "cr.yandex/${yandex_container_registry.main.id}"
}

output "db_fqdn" {
  value = yandex_mdb_mysql_cluster.main.host[0].fqdn
}

output "app_url" {
  value = "http://${yandex_compute_instance.vm.network_interface[0].nat_ip_address}"
}
