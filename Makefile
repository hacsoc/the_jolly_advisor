.PHONY: all compose-build compose-test

CI ?= false
TRAVIS ?=
TRAVIS_JOB_ID ?=
TRAVIS_PULL_REQUEST ?=

all:

compose-build: Dockerfile.dev docker-compose.yaml
	docker-compose up --build -d
	docker-compose run test rake db:test:prepare

compose-test: compose-build
	docker-compose run \
		-e CI=$(CI) \
		-e TRAVIS=$(TRAVIS) \
		-e TRAVIS_JOB_ID=$(TRAVIS_JOB_ID) \
		-e TRAVIS_PULL_REQUEST=$(TRAVIS_PULL_REQUEST) \
		test rake
	docker-compose kill
