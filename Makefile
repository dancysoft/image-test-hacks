.PHONY: default test up down build setup-certs create-dbs full shell-fpm

default:
	@echo "no default target.  Try 'make up', waiting a few seconds, then 'make create-dbs', then 'make test'"

up: setup-certs
	docker-compose up --build -d

down:
	docker-compose down

build:
	docker-compose build

test:
	@# FIXME: This won't work workout dbs.. Is there a way to test if create-dbs needs to run?
	curl -sSf -H 'Host: test.wikipedia.org' http://localhost:8000/wiki/Special:Version

setup-certs:
	./setup-certs

clean-certs:
	rm -f tls/*

create-dbs:
	docker-compose exec fpm /tmp/create-databases

full: 
	@# Fresh start
	$(MAKE) down
	$(MAKE) up
	@echo "Waiting for processes to start"
	sleep 2
	$(MAKE) create-dbs
	$(MAKE) test

shell-fpm:
	docker-compose exec -u root fpm bash
