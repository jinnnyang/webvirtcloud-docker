build:
	docker build -t jinnyang/webvirtcloud:0.0.1 .
pull:
	docker image pull harbor.nas.local/jinnyang/webvirtcloud:0.0.1
	docker image tag harbor.nas.local/jinnyang/webvirtcloud:0.0.1 jinnyang/webvirtcloud:0.0.1 
	docker image rm harbor.nas.local/jinnyang/webvirtcloud:0.0.1
push: 
	docker image tag jinnyang/webvirtcloud:0.0.1 harbor.nas.local/jinnyang/webvirtcloud:0.0.1
	docker image push harbor.nas.local/jinnyang/webvirtcloud:0.0.1
	docker image rm harbor.nas.local/jinnyang/webvirtcloud:0.0.1
start:
	docker-compose up -d

stop:
	docker-compose rm -s

con:
	docker exec -it webvirtcloud /bin/bash

update:
	docker-compose pull