DOCKER_IMAGE_VERSION=3.2p3
DOCKER_IMAGE_NAME=smarthomerocks/owserver
DOCKER_IMAGE_TAGNAME=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

default: build

build:
	docker build -t $(DOCKER_IMAGE_TAGNAME) .
	docker tag $(DOCKER_IMAGE_TAGNAME) $(DOCKER_IMAGE_NAME):latest

push:
	docker push $(DOCKER_IMAGE_TAGNAME)
	docker push $(DOCKER_IMAGE_NAME)

test:
	docker run --rm --privileged $(DOCKER_IMAGE_TAGNAME) /bin/echo "Success."

version:
	docker run --rm --privileged $(DOCKER_IMAGE_TAGNAME) owserver --version
