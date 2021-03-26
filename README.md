# iudanet_microservices

iudanet microservices repository

## HW-21

### Описание

* Добавлен NetworkPolisy для сервиса mongo
* Вручную создан диск в YC
* Добавлен PV и PVC для сервиса mongo
* Добавлен ingress для UI
* Добавлен tls для ingress
* повторная выдача PV после статуса Realized

```txt
kubectl patch pv mongo-pv -p '{"spec":{"claimRef": null}}'
```

## HW-20

### Описание

* добавлены labels и env в Deployments для приложения reddit
* созданы services для взаимодействия компонентов приложения reddit
* обновлен terraform для создания managed k8s yandex

```txt
➜  terraform git:(kubernetes-2) ✗ yc managed-kubernetes cluster list
+----------------------+------+---------------------+---------+---------+------------------------+-------------------+
|          ID          | NAME |     CREATED AT      | HEALTH  | STATUS  |   EXTERNAL ENDPOINT    | INTERNAL ENDPOINT |
+----------------------+------+---------------------+---------+---------+------------------------+-------------------+
| catnbp6sj9dc96o54vhc | name | 2021-03-24 09:19:37 | HEALTHY | RUNNING | https://178.154.200.83 | https://10.0.0.17 |
+----------------------+------+---------------------+---------+---------+------------------------+-------------------+

➜  terraform git:(kubernetes-2) ✗ yc managed-kubernetes cluster get-credentials name --external --force
➜  terraform git:(kubernetes-2) ✗ k config get-contexts
CURRENT   NAME       CLUSTER                               AUTHINFO                              NAMESPACE
          minikube   minikube                              minikube                              default
*         yc-name    yc-managed-k8s-catnbp6sj9dc96o54vhc   yc-managed-k8s-catnbp6sj9dc96o54vhc
➜  terraform git:(kubernetes-2) ✗ k get nodes
NAME                        STATUS   ROLES    AGE     VERSION
cl18a7pqi9tmbk8bp229-elov   Ready    <none>   8m46s   v1.19.7
cl18a7pqi9tmbk8bp229-uqez   Ready    <none>   8m50s   v1.19.7
➜  terraform git:(kubernetes-2) ✗ cd ../reddit

➜  reddit git:(kubernetes-2) ✗ k apply -f dev-namespace.yml
namespace/dev created
➜  reddit git:(kubernetes-2) ✗ k apply -n dev -f .
deployment.apps/comment created
service/comment-db created
service/comment created
namespace/dev unchanged
deployment.apps/mongo created
service/mongodb created
deployment.apps/post created
service/post-db created
service/post created
deployment.apps/ui created
service/ui created
```

```
reddit git:(kubernetes-2) ✗ kubectl get nodes -o wide
NAME                        STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP       OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
cl18a7pqi9tmbk8bp229-elov   Ready    <none>   11m   v1.19.7   10.0.0.29     84.201.128.197    Ubuntu 20.04.2 LTS   5.4.0-65-generic   docker://20.10.3
cl18a7pqi9tmbk8bp229-uqez   Ready    <none>   11m   v1.19.7   10.0.0.27     178.154.203.172   Ubuntu 20.04.2 LTS   5.4.0-65-generic   docker://20.10.3

➜  reddit git:(kubernetes-2) ✗ kubectl get svc -A
NAMESPACE     NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
default       kubernetes       ClusterIP   10.96.128.1     <none>        443/TCP          14m
dev           comment          ClusterIP   10.96.175.160   <none>        9292/TCP         2m27s
dev           comment-db       ClusterIP   10.96.186.200   <none>        27017/TCP        2m27s
dev           mongodb          ClusterIP   10.96.152.49    <none>        27017/TCP        2m26s
dev           post             ClusterIP   10.96.213.106   <none>        5000/TCP         2m26s
dev           post-db          ClusterIP   10.96.247.208   <none>        27017/TCP        2m26s
dev           ui               NodePort    10.96.250.238   <none>        9292:31192/TCP   2m26s
kube-system   calico-typha     ClusterIP   10.96.159.127   <none>        5473/TCP         14m
kube-system   kube-dns         ClusterIP   10.96.128.2     <none>        53/UDP,53/TCP    14m
kube-system   metrics-server   ClusterIP   10.96.220.189   <none>        443/TCP          14m
```
* ссылка на приложение [http://84.201.128.197:31192/]()
## HW-19

### Описание

* Написан  terraform  код разворачивающий 2 виртуальные машины в облаке
* Написаны роли ansible для подготовки виртуальных машин к работе в кластере k8s
* Написаны Deployments для разворачивания стека reddit
* Созданы роли для бустрапа k8s кластера

  ```txt
  ubuntu@k8s-master:~$ sudo kubeadm init --apiserver-cert-extra-sans=10.130.0.33,178.154.203.120 --apiserver-advertise-address=0.0.0.0 --control-plane-endpoint=10.130.0.33 --pod-network-cidr=10.244.0.0/16
  [init] Using Kubernetes version: v1.20.5
  [preflight] Running pre-flight checks
          [WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd". Please follow the guide at https://kubernetes.io/docs/setup/cri/
          [WARNING SystemVerification]: this Docker version is not on the list of validated versions: 20.10.5. Latest validated version: 19.03
  [preflight] Pulling images required for setting up a Kubernetes cluster
  [preflight] This might take a minute or two, depending on the speed of your internet connection
  [preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
  [certs] Using certificateDir folder "/etc/kubernetes/pki"
  [certs] Generating "ca" certificate and key
  [certs] Generating "apiserver" certificate and key
  [certs] apiserver serving cert is signed for DNS names [k8s-master kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 10.130.0.33]
  [certs] Generating "apiserver-kubelet-client" certificate and key
  [certs] Generating "front-proxy-ca" certificate and key
  [certs] Generating "front-proxy-client" certificate and key
  [certs] Generating "etcd/ca" certificate and key
  [certs] Generating "etcd/server" certificate and key
  [certs] etcd/server serving cert is signed for DNS names [k8s-master localhost] and IPs [10.130.0.33 127.0.0.1 ::1]
  [certs] Generating "etcd/peer" certificate and key
  [certs] etcd/peer serving cert is signed for DNS names [k8s-master localhost] and IPs [10.130.0.33 127.0.0.1 ::1]
  [certs] Generating "etcd/healthcheck-client" certificate and key
  [certs] Generating "apiserver-etcd-client" certificate and key
  [certs] Generating "sa" key and public key
  [kubeconfig] Using kubeconfig folder "/etc/kubernetes"
  [kubeconfig] Writing "admin.conf" kubeconfig file
  [kubeconfig] Writing "kubelet.conf" kubeconfig file
  [kubeconfig] Writing "controller-manager.conf" kubeconfig file
  [kubeconfig] Writing "scheduler.conf" kubeconfig file
  [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
  [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
  [kubelet-start] Starting the kubelet
  [control-plane] Using manifest folder "/etc/kubernetes/manifests"
  [control-plane] Creating static Pod manifest for "kube-apiserver"
  [control-plane] Creating static Pod manifest for "kube-controller-manager"
  [control-plane] Creating static Pod manifest for "kube-scheduler"
  [etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
  [wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
  [kubelet-check] Initial timeout of 40s passed.
  [apiclient] All control plane components are healthy after 59.502626 seconds
  [upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
  [kubelet] Creating a ConfigMap "kubelet-config-1.20" in namespace kube-system with the configuration for the kubelets in the cluster
  [upload-certs] Skipping phase. Please see --upload-certs
  [mark-control-plane] Marking the node k8s-master as control-plane by adding the labels "node-role.kubernetes.io/master=''" and "node-role.kubernetes.io/control-plane='' (deprecated)"
  [mark-control-plane] Marking the node k8s-master as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
  [bootstrap-token] Using token: bycz1t.lj5c5iz9okyslfm4
  [bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
  [bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to get nodes
  [bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
  [bootstrap-token] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
  [bootstrap-token] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
  [bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
  [kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
  [addons] Applied essential addon: CoreDNS
  [addons] Applied essential addon: kube-proxy

  Your Kubernetes control-plane has initialized successfully!

  To start using your cluster, you need to run the following as a regular user:

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

  Alternatively, if you are the root user, you can run:

    export KUBECONFIG=/etc/kubernetes/admin.conf

  You should now deploy a pod network to the cluster.
  Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
    https://kubernetes.io/docs/concepts/cluster-administration/addons/

  You can now join any number of control-plane nodes by copying certificate authorities
  and service account keys on each node and then running the following as root:

    kubeadm join 10.130.0.33:6443 --token bycz1t.lj5c5iz9okyslfm4 \
      --discovery-token-ca-cert-hash sha256:46999d13ce2a96c662309b12f31f42fb8ca44c71dfcff20a90f6a58a49411472 \
      --control-plane

  Then you can join any number of worker nodes by running the following on each as root:

  kubeadm join 10.130.0.33:6443 --token bycz1t.lj5c5iz9okyslfm4 \
      --discovery-token-ca-cert-hash sha256:46999d13ce2a96c662309b12f31f42fb8ca44c71dfcff20a90f6a58a49411472
  ```

  ```txt
  ubuntu@k8s-worker:~$ sudo kubeadm join 10.130.0.33:6443 --token bycz1t.lj5c5iz9okyslfm4 --discovery-token-ca-cert-hash sha256:46999d13ce2a96c662309b12f31f42fb8ca44c71dfcff20a90f6a58a49411472
  [preflight] Running pre-flight checks
          [WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd". Please follow the guide at https://kubernetes.io/docs/setup/cri/
          [WARNING SystemVerification]: this Docker version is not on the list of validated versions: 20.10.5. Latest validated version: 19.03
  [preflight] Reading configuration from the cluster...
  [preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
  [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
  [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
  [kubelet-start] Starting the kubelet
  [kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

  This node has joined the cluster:
  * Certificate signing request was sent to apiserver and a response was received.
  * The Kubelet was informed of the new secure connection details.

  Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
  ```

* Проверка утановки:

  ```txt
  (venv) ➜  kubernetes git:(kubernetes-1) ✗ kubectl --insecure-skip-tls-verify get nodes
  NAME         STATUS   ROLES                  AGE   VERSION
  k8s-master   Ready    control-plane,master   17m   v1.20.5
  k8s-worker   Ready    <none>                 15m   v1.20.5
  ```

  ```txt
  (venv) ➜  kubernetes git:(kubernetes-1) ✗ kubectl --insecure-skip-tls-verify get pods
  NAME                                  READY   STATUS    RESTARTS   AGE
  comment-deployment-5c9794559f-p25ql   1/1     Running   0          33s
  mongo-deployment-884cdc545-zjhhb      1/1     Running   0          40s
  post-deployment-84bc94cbdc-tsmkz      1/1     Running   0          27s
  ui-deployment-7cd478f7bc-spn8w        1/1     Running   0          44s
  ```

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
