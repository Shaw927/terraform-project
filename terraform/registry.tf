resource "yandex_container_registry" "main" {
  name      = "${local.prefix}-registry"
  folder_id = var.folder_id
}

resource "null_resource" "build_and_push" {
  triggers = {
    dockerfile = filemd5("${path.module}/../app/Dockerfile.python")
    main_py    = filemd5("${path.module}/../app/main.py")
    reqs       = filemd5("${path.module}/../app/requirements.txt")
    registry   = yandex_container_registry.main.id
  }

  depends_on = [
    yandex_container_registry.main,
    yandex_iam_service_account.vm_sa,
    yandex_resourcemanager_folder_iam_member.vm_sa_registry_puller,
  ]

  provisioner "local-exec" {
    command = <<-EOT
      set -e
      echo "==> Авторизация в Container Registry..."
      yc iam create-token | docker login \
        --username iam \
        --password-stdin \
        cr.yandex

      echo "==> Сборка образа..."
      docker build \
        -f ${path.module}/../app/Dockerfile.python \
        -t cr.yandex/${yandex_container_registry.main.id}/webapp:${var.image_tag} \
        ${path.module}/../app

      echo "==> Пуш образа..."
      docker push cr.yandex/${yandex_container_registry.main.id}/webapp:${var.image_tag}

      echo "==> Готово!"
    EOT
  }
}
