# Создать Terraform скрипт

## Цель:

реализовать первый терраформ скрипт.

## Описание/Пошаговая инструкция выполнения домашнего задания:

Необходимо:

  *  реализовать терраформ для разворачивания одной виртуалки в yandex-cloud
  *  запровиженить nginx с помощью ansible

Формат сдачи

  *  репозиторий с терраформ манифестами
  *  README файл

---  


## Решение

1. Регистрируемся в облачном сервисе Yandex Cloud

2. Создаем Folder в облачном сервисе

2. Создаем сервисный аккаунт

```sh
yc iam service-account create --name otus-hl-sa


yc iam service-account list

yc iam service-account list                                                                                                                                                                                                                                                                                       
+----------------------+------------+--------+
|          ID          |    NAME    | LABELS |
+----------------------+------------+--------+
| aje...ed5 | otus-hl-sa |        |
+----------------------+------------+--------+

yc iam key create   --service-account-id aje...ed5  --folder-id b1....et2   --output key.json

yc config set service-account-key key.json


```
3. Назначаем роли для сервисного аккаунта на папку - default
```sh
yc resource-manager folder add-access-binding default   --role admin   --subject serviceAccount:aje...ed5
```


4. Выставляем  переменные для terraform скрипта в переменные среды 

```sh
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)                                                
```


5. Запускаем terraform
``` sh
terraform  apply -var-file="yc.tfvars"                 
```

В консоли выполнения должно быть надпись с внешним IP созданной виртуалки

```sh
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

instance_external_ip = "51.250.14.243"
```

6. Проверяем работу (видим что успешно работает)

```sh
curl 51.250.14.243                                                                                                                                                                                                                                                                                       
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```