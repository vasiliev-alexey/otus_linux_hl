# Настраиваем балансировку веб-приложения

## Цель:

Настраиваем балансировку веб-приложения

## Описание/Пошаговая инструкция выполнения домашнего задания:

В результате получаем рабочий пример Nginx в качестве балансировщика, и базовую отказоустойчивость бекенда.

* развернуть 4 виртуалки терраформом в яндекс облаке
* 1 виртуалка - Nginx - с публичным IP адресом
* 2 виртуалки - бэкенд на выбор студента ( любое приложение из гитхаба - uwsgi/unicorn/php-fpm/java) + nginx со статикой
* 1 виртуалкой с БД на выбор mysql/mongodb/postgres/redis.
* В работе должны применяться:
* terraform
* ansible
* nginx;
* uwsgi/unicorn/php-fpm;
* некластеризованная бд mysql/mongodb/postgres/redis.-

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

4. Выставляем переменные для terraform скрипта в переменные среды

```sh
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)                                                
```

5. Запускаем terraform

``` sh
terraform  apply -var-file="yc.tfvars"                 
```

В консоли выполнения должно быть надпись с внешним IP созданной виртуалки c балансировщиком

```sh

Outputs:

Адрес-ip-LB = "62.84.116.42"

```

6. Проверяем работу (видим что успешно работает) - фронт загружается. Бекнд работает.

```sh
curl 62.84.116.42                                                                                                                                                                                                                                                                                                                                                                   19:01:25 11/09/24
<!doctype html>
<html lang="en" data-critters-container>
<head><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <meta charset="utf-8">
  <title>RealworldStateTest</title>
<!--  <base href="/">-->
/// content ommitted
```