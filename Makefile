build:
	docker build -t muratovas/webvirtcloud .

start:
	docker-compose up -d

stop:
	docker-compose rm -s

con:
	docker exec -it webvirtcloud /bin/bash

update:
	docker-compose pull