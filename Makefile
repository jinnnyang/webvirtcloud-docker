build:
	docker build -t muratovas/webvirtcloud .

start:
	docker-compose up -d

stop:
	docker-compose rm -s

update:
	docker-compose pull