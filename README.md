# iudanet_microservices

iudanet microservices repository

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
