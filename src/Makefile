docker_tag=1.0


build:: lint build-docker-post-py build-docker-comment build-docker-ui
lint:: lint-docker-post-py lint-docker-comment lint-docker-ui
clear:: clear-docker-run
run:: build pre_run run-docker-mongo run-rocker-post-py run-docker-comment run-docker-ui
pre_run:: create-docker-voleume create-docker-network


## Builders
build-docker-post-py::
	sudo docker build --pull -t iudanet/post:$(docker_tag)   ./post-py/
build-docker-comment::
	sudo docker build --pull -t iudanet/comment:$(docker_tag)   ./comment/
build-docker-ui::
	sudo docker build --pull -t iudanet/ui:$(docker_tag)   ./ui/

## Linters
lint-docker-monolith::
	sudo docker run --rm -i hadolint/hadolint < ../docker-monolith/Dockerfile
lint-docker-post-py::
	sudo docker run --rm -i hadolint/hadolint < post-py/Dockerfile
lint-docker-comment::
	sudo docker run --rm -i hadolint/hadolint < comment/Dockerfile
lint-docker-ui::
	sudo docker run --rm -i hadolint/hadolint < ui/Dockerfile

## RUN

run-rocker-post-py::
	sudo docker run -d --network=reddit --network-alias=post iudanet/post:$(docker_tag)
run-docker-comment::
	sudo docker run -d --network=reddit --network-alias=comment iudanet/comment:$(docker_tag)
run-docker-ui::
	sudo docker run -d --network=reddit -p 9292:9292 iudanet/ui:$(docker_tag)
run-docker-mongo::
	sudo docker run -d \
		--network=reddit \
		--network-alias=post_db \
		-v reddit_db:/data/db \
		--network-alias=comment_db \
		mongo:latest

create-docker-voleume::
	sudo docker volume create reddit_db || exit 0
create-docker-network::
	sudo docker network create reddit || exit 0

clear-docker-run::
	sudo docker kill $(shell sudo docker ps -q)
