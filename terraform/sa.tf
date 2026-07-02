resource "yandex_iam_service_account" "vm_sa" {
  name      = "${local.prefix}-vm-sa"
  folder_id = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "vm_sa_registry_puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.vm_sa.id}"
}

