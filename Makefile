DOCKER_IMAGE_VERSION="$(shell curl --silent "https://api.github.com/repos/owfs/owfs/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')"
DOCKER_IMAGE_NAME="smarthomerocks/owserver"
DOCKER_IMAGE_TAGNAME="$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)"

default: build

build:
	@echo "building image: $(DOCKER_IMAGE_TAGNAME)"
	docker build -t $(DOCKER_IMAGE_TAGNAME) .
	docker tag $(DOCKER_IMAGE_TAGNAME) $(DOCKER_IMAGE_NAME):latest

push:
	docker push $(DOCKER_IMAGE_TAGNAME)
	docker push $(DOCKER_IMAGE_NAME)

test:
	docker run --rm --privileged $(DOCKER_IMAGE_TAGNAME) /bin/echo "Success."

version:
	docker run --rm --privileged $(DOCKER_IMAGE_TAGNAME) owserver --version
