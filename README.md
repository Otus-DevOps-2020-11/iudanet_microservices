# iudanet_microservices

iudanet microservices repository

## HW-18

### Описание

* Настроен fluentd и Elasticsearch
* Настроены парсеры json и grok для fluentd
* Настроен zipkin для просомтра трасировок
* Настроен docker-compose с сервисами логирования
* Поиск неисправности в коде репозитория `https://github.com/Artemmkin/bugged-code`
  * поиск по zipkin показал что тормозит функция `db_find_single_post`
  * лишняя строчка с  `time.sleep(3)`

  ```python
  @zipkin_span(service_name='post', span_name='db_find_single_post')
  def find_post(id):
      start_time = time.time()
      try:
          post = app.db.find_one({'_id': ObjectId(id)})
      except Exception as e:
          log_event('error', 'post_find',
                    "Failed to find the post. Reason: {}".format(str(e)),
                    request.values)
          abort(500)
      else:
          stop_time = time.time()  # + 0.3
          resp_time = stop_time - start_time
          app.post_read_db_seconds.observe(resp_time)
          time.sleep(3)
          log_event('info', 'post_find',
                    'Successfully found the post information',
                    {'post_id': id})
          return dumps(post)
  ```

* В проекте собираются образы:
  * iudanet/percona_mongodb_exporter:master
  * iudanet/blackbox_exporter:logging
  * iudanet/post:logging
  * iudanet/comment:logging
  * iudanet/ui:logging
  * iudanet/prometheus:logging
  * iudanet/alertmanager:logging
  * iudanet/telegraf:logging
  * iudanet/grafana:logging
  * iudanet/fluentd:logging

## HW-17

### Описание

* Стек мониторинга перенесен в отдельный `docker-compose-monitoring.yml`
* добавлен cAdvisor
* Добавлена Grafana
* Настроен провижинг дашбордов и источников данных через код
* Добавлен Alertmanager с алертами в slak   и почту
* Добавлен telegraf для сборки метрик docker
* Добавлена сборка метрик docker daemon
* Доработан Makefile
* Настроен сбор метрик с яндекс облака
* В проекте собираются образы:
  * iudanet/percona_mongodb_exporter:master
  * iudanet/blackbox_exporter:latest
  * iudanet/post:latest
  * iudanet/comment:latest
  * iudanet/ui:latest
  * iudanet/prometheus:latest
  * iudanet/alertmanager:latest
  * iudanet/telegraf:latest
  * iudanet/grafana:latest

## HW-16

### Описание

* Произведена переконпановка репозитория, перенесены файлы docker-compose и папка `docker-monolith` в папку `docker`
* добавлен мониторинг prometheus в docker-compose для сервисов:
  * ui
  * comment
  * post
* добавлен node_exporer
* добавлен mongodb_exporter
  * скачан репозиторий [https://github.com/percona/mongodb_exporter]()
  * собран из мастер ветки и запушен образ в Docker Hub `iudanet/percona_mongodb_exporter:master`
* добавлен blackbox_exporter c tcp и http проверками
  * в Docker Hub запушен образ `iudanet/blackbox_exporter:latest`
* Проведены практические тесты по нахождению неисправности с помощью prometheus
* В проекте собираются образы:
  * iudanet/percona_mongodb_exporter:master
  * iudanet/blackbox_exporter:latest
  * iudanet/post:latest
  * iudanet/comment:latest
  * iudanet/ui:latest
  * iudanet/prometheus:latest

* Написан `Makefile` для автоматизации рутинных процессов:
  * `make build` собирает все образы
    * можно собрать конкретный образ
  * `make push` пушит образы на докерхаб с логином под пользователем iudanet
    * можно запушить конкретный образ
  * `make up` запускает `make build` и `docker-compose up -d`
  * `make clean` запускает `docker-compose down -v`

## HW-14

### Описание

* добавлен docker-compose для удобного запуска проекта
* добавлен расширенный docker-compose.override.yml для запуска в режиме разработки.
* он монтирует папки с кодом сервисов и запускает puma в debug режиме.
* Расширен файлы .env для переменных docker-compose
* Чтобы задать имя проекта

    ```bash
    docker-compose --project-name MY_PROJECT_NAME up -d
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
