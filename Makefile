#Envs
USER_NAME=iudanet
DOCKER_TAG=latest


# Docker builds
build:: build-prometheus build-ui build-comment build-post build-blackbox

build-prometheus::
	cd monitoring/prometheus && \
	USER_NAME=$(USER_NAME) bash docker_build.sh
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
	USER_NAME=$(USER_NAME) bash docker_build.sh

#Docker Push
push:: push-prometheus push-ui push-comment push-post push-blackbox

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

# Docker Login
docker-login::
	docker login -u $(USER_NAME)

up:: build docker-compose-up

docker-compose-up::
	cd docker && \
	docker-compose up -d

docker-compose-ps::
	cd docker && \
	docker-compose ps

clean:: docker-compose-down

docker-compose-down::
	cd docker && \
	docker-compose down -v
