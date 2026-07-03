locals {
  project  = "netology"
  env      = "prod"
  prefix   = "${local.project}-${local.env}"
  app_port = 5000

  db_password = var.lockbox_secret_id != "" ? (
    data.yandex_lockbox_secret_version.db[0].entries[0].text_value
  ) : var.db_password

  registry_url = "cr.yandex/${yandex_container_registry.main.id}"

  nginx_conf = templatefile("${path.module}/templates/nginx.conf.tftpl", {
    app_port = local.app_port
  })

  docker_compose_content = templatefile("${path.module}/templates/docker-compose.yaml.tftpl", {
    registry_url = local.registry_url
    image_tag    = var.image_tag
    db_host      = yandex_mdb_mysql_cluster.main.host[0].fqdn
    db_name      = var.db_name
    db_user      = var.db_user
    db_password  = local.db_password
    app_port     = local.app_port
  })
}
