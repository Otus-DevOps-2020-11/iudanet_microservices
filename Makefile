#Envs
USER_NAME=iudanet
DOCKER_TAG=latest


# Docker builds
build:: build-prometheus build-ui build-comment build-post build-blackbox build-alertmanager build-telegraf build-grafana

build-prometheus::
	cd monitoring/prometheus && \
	docker build -t $(USER_NAME)/prometheus:$(DOCKER_TAG) .
build-ui::
	cd src/ui && \
	USER_NAME=$(USER_NAME) bash docker_build.sh
build-comment::
	cd src/comment && \
	USER_NAME=$(USER_NAME) bash docker_build.sh
build-post::
	cd src/post-py && \
	USER_NAME=$(USER_NAME) bash docker_build.sh
build-blackbox::
	cd monitoring/blackbox_exporter && \
	docker build -t $(USER_NAME)/blackbox_exporter:$(DOCKER_TAG) .
build-alertmanager::
	cd monitoring/alertmanager && \
	docker build -t $(USER_NAME)/alertmanager:$(DOCKER_TAG) .
build-telegraf::
	cd monitoring/telegraf && \
	docker build -t $(USER_NAME)/telegraf:$(DOCKER_TAG) .
build-grafana::
	cd monitoring/grafana && \
	docker build -t $(USER_NAME)/grafana:$(DOCKER_TAG) .

#Docker Push
push:: push-prometheus push-ui push-comment push-post push-blackbox push-alertmanager push-telegraf

push-prometheus:: build-prometheus docker-login
	docker push $(USER_NAME)/prometheus:$(DOCKER_TAG)
push-ui:: build-ui docker-login
	docker push $(USER_NAME)/ui:$(DOCKER_TAG)
push-comment:: build-comment docker-login
	docker push $(USER_NAME)/comment:$(DOCKER_TAG)
push-post:: build-post docker-login
	docker push $(USER_NAME)/post:$(DOCKER_TAG)
push-blackbox:: build-blackbox docker-login
	docker push $(USER_NAME)/blackbox_exporter:$(DOCKER_TAG)
push-alertmanager:: build-alertmanager docker-login
	docker push $(USER_NAME)/alertmanager:$(DOCKER_TAG)
push-telegraf:: build-telegraf docker-login
	docker push $(USER_NAME)/telegraf:$(DOCKER_TAG)
push-grafana:: build-grafana docker-login
	docker push $(USER_NAME)/grafana:$(DOCKER_TAG)

# Docker Login
docker-login::
	docker login -u $(USER_NAME)

up:: build docker-compose-up

docker-compose-up::
	cd docker && \
	docker-compose up -d && \
	docker-compose -f docker-compose-monitoring.yml up -d

docker-compose-ps::
	cd docker && \
	docker-compose ps

clean:: docker-compose-down

docker-compose-down::
	cd docker && \
	docker-compose -f docker-compose-monitoring.yml down -v && \
	docker-compose down -v
