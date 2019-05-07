default: build

build:
	docker build . -t huntprod/fwbase:latest

push:
	docker push huntprod/fwbase:latest
