# iudanet_microservices

iudanet microservices repository

## HW-14

### Описание

* добавлен

* Задать имя проекта

```bash
docker-compose --project-name MY_PROJECT_NAME
```

* Запустить с параметрами разработки

    ```bash
    docker-compose -f docker-compose.override.yml -f docker-compose.yml up  -d
    ```

## HW-13

### Описание

* Собраны 3 контейнера:
  * iudanet/ui:1.0
  * iudanet/comment:1.0
  * iudanet/post:1.0
* Сборка осуществлена с помощью alpine

    ```txt
    ➜  iudanet_microservices git:(docker-3) docker images | grep iudanet
    iudanet/ui                1.0             cf9816138451   10 hours ago   146MB
    iudanet/comment           1.0             df4bd7ae238c   10 hours ago   144MB
    iudanet/post              1.0             9ce0e4c25009   11 hours ago   106MB
    ```

* Для удобства сборки, проверки и разворачивания локально написан Makefile. В папке src:
  * `make lint`
  * `make build`
  * `make run`

## HW-12

### Описание

* научился использовать docker  и docker-machine

    ```bash
    docker-machine create  --driver generic  --generic-ip-address=130.193.46.19  --generic-ssh-user ubuntu  --generic-ssh-key ~/.ssh/appuser  docker-host-2
    docker-machine ls
    eval $(docker-machine env docker-host-2)
    eval $(docker-machine env --unset)
    ```

* Создан образ `iudanet/otus-reddit:1.0` и залит на Docker Hub
* Создана ansible роль `docker` для установки docker на хост
* Создана ansible роль `monolith` для деплоя контенера на хост
* Настроена сборка виртуальной машины с помошью packer. При сборке используется роль `docker`.

    ```bash
    cd docker-monolith/infra
    packer build -var-file=packer/variables.json packer/docker.json
    ```

* Настроен проект Terraform для создания виртуальных машин в облоке Yandex. КОличество виртуалок задется через переменную `count_app`

    ```bash
    cd docker-monolith/infra/terraform
    terraform init
    terraform apply
    ```

* Ansible использует скрипт Динамического инвентори.

    ```bash
    cd docker-monolith/infra/ansible
    ansible-playbook playbooks/docker.yml
    ```

* настроена интеграция с github actions, Slack, Travis.
