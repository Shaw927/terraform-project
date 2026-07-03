проект: развертывание web-приложение в yandex cloud через terraform, docker и docker Compose.

## Что делает проект

- Создаёт VPC, подсеть и security group (порты 22, 80, 443)
- Поднимает VM в Yandex Cloud с автоустановкой Docker через cloud-init
- Создаёт кластер MySQL (Managed Database)
- Создаёт Container Registry и пушит туда собранный образ
- Разворачивает приложение на VM через Docker Compose (nginx + web app), подключённое к БД
- Пароль от БД можно хранить в Yandex Lockbox (опционально)
- State хранится удалённо в S3-совместимом бакете, со state locking

## Структура репозитория

app/     — код web-приложения, Dockerfile
terraform/    — вся инфраструктура (Terraform)
terraform/templates/  — шаблоны cloud-init, docker-compose, nginx.conf


## Как запустить

1. Установи Terraform и Yandex CLI (`yc`), авторизуйся в `yc`.

2. Скопируй примеры конфигов и заполни своими данными:
   ```bash
   cp terraform/backend.hcl.example terraform/backend.hcl
   cp terraform/terraform.tfvars.example terraform/terraform.tfvars

В  backend.hcl  укажи свой S3-бакет и ключи доступа.
В  terraform.tfvars  укажи  cloud_id ,  folder_id ,  yc_token , свой SSH-ключ.
3. Инициализация и деплой:
```bash
cd terraform
terraform init -backend-config=backend.hcl
terraform plan -out=tfplan
terraform apply tfplan
```
Важно:
- Образ приложения собирается и пушится в Container Registry локально (через  null_resource  +  local-exec ), поэтому на машине, откуда запускаешь  terraform apply, должны быть установлены docker и yc
- terraform.tfstate ,  terraform.tfvars  и  backend.hcl  не хранятся в git — там секреты и реальные данные инфраструктуры.
- Пароль от БД можно передать напрямую через  db_password  в  tfvars , либо (рекомендуется) положить в Yandex Lockbox и указать  lockbox_secret_id тогда пароль подтянется автоматически.
- после  terraform destroy  сам bucket с remote state (S3) не удаляется, Terraform чистит только описанные в коде ресурсы, а бакет для state создаётся отдельно и вручную


## Как всё удалить (terraform destroy)

`terraform destroy` **не может удалить Container Registry, если внутри есть образы**, yc API не даёт снести непустой registry. Поэтому перед дестроем нужно вручную удалить все образы:

```bash
yc container image list
yc container image delete <ID образа>
terraform destroy
```




