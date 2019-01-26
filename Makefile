DOCKER_IMAGE_VERSION=$(shell curl --silent "https://api.github.com/repos/owfs/owfs/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

default: build
#https://developer.ibm.com/linuxonpower/2017/07/27/create-multi-architecture-docker-image/
build:
	@echo "building image: smarthomerocks/owserver-armhf:$(DOCKER_IMAGE_VERSION)"
	docker build -t smarthomerocks/owserver-armhf:$(DOCKER_IMAGE_VERSION) -f armhf/Dockerfile .
	docker tag smarthomerocks/owserver-armhf:$(DOCKER_IMAGE_VERSION) smarthomerocks/owserver-armhf:latest
	
	@echo "building image: smarthomerocks/owserver-amd64:$(DOCKER_IMAGE_VERSION)"
	docker build -t smarthomerocks/owserver-amd64:$(DOCKER_IMAGE_VERSION) -f amd64/Dockerfile .
	docker tag smarthomerocks/owserver-amd64:$(DOCKER_IMAGE_VERSION) smarthomerocks/owserver-amd64:latest

push:
	docker push smarthomerocks/owserver-armhf:$(DOCKER_IMAGE_VERSION)
	docker push smarthomerocks/owserver-armhf:latest
	
	docker push smarthomerocks/owserver-amd64:$(DOCKER_IMAGE_VERSION)
	docker push smarthomerocks/owserver-amd64:latest	

test:
	docker run --rm --privileged smarthomerocks/owserver-armhf:$(DOCKER_IMAGE_VERSION) /bin/echo "Success." && docker run --rm --privileged smarthomerocks/owserver-amd64:$(DOCKER_IMAGE_VERSION) /bin/echo "Success."

version:
	docker run --rm --privileged smarthomerocks/owserver-armhf:$(DOCKER_IMAGE_VERSION) owserver --version && docker run --rm --privileged smarthomerocks/owserver-amd64:$(DOCKER_IMAGE_VERSION) owserver --version
