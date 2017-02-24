.PHONY: all compose-build compose-test

all:

compose-build: Dockerfile.dev docker-compose.yaml
	docker-compose up --build -d

compose-test: compose-build
	docker-compose run test rake
	docker-compose kill
