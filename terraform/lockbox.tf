data "yandex_lockbox_secret_version" "db" {
  count     = var.lockbox_secret_id != "" ? 1 : 0
  secret_id = var.lockbox_secret_id
}

