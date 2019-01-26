DOCKER_IMAGE_VERSION=$(shell curl --silent "https://api.github.com/repos/owfs/owfs/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
DOCKER_IMAGE_NAME_ARMHF=smarthomerocks/owserver-armhf
DOCKER_IMAGE_NAME_AMD64=smarthomerocks/owserver-amd64

default: build
#https://developer.ibm.com/linuxonpower/2017/07/27/create-multi-architecture-docker-image/
build:
	@echo "building image: ${DOCKER_IMAGE_NAME_ARMHF}:${DOCKER_IMAGE_VERSION}"
	docker build -t ${DOCKER_IMAGE_NAME_ARMHF}:${DOCKER_IMAGE_VERSION} -f armhf/Dockerfile .
	docker tag ${DOCKER_IMAGE_NAME_ARMHF}:${DOCKER_IMAGE_VERSION} ${DOCKER_IMAGE_NAME_ARMHF}:latest
	@echo "building image: ${DOCKER_IMAGE_NAME_AMD64}:${DOCKER_IMAGE_VERSION}"
	docker build -t ${DOCKER_IMAGE_NAME_AMD64}:${DOCKER_IMAGE_VERSION} -f amd64/Dockerfile .
	docker tag ${DOCKER_IMAGE_NAME_AMD64}:${DOCKER_IMAGE_VERSION} ${DOCKER_IMAGE_NAME_AMD64}:latest

push:
	docker push ${DOCKER_IMAGE_NAME_ARMHF}:${DOCKER_IMAGE_VERSION}
	docker push ${DOCKER_IMAGE_NAME_ARMHF}:latest
	docker push ${DOCKER_IMAGE_NAME_AMD64}:${DOCKER_IMAGE_VERSION}
	docker push ${DOCKER_IMAGE_NAME_AMD64}:latest	

test:
	docker run --rm --privileged ${DOCKER_IMAGE_NAME_ARMHF}:${DOCKER_IMAGE_VERSION} /bin/echo "Success."
	docker run --rm --privileged ${DOCKER_IMAGE_NAME_AMD64}:${DOCKER_IMAGE_VERSION} /bin/echo "Success."

version:
	docker run --rm --privileged ${DOCKER_IMAGE_NAME_ARMHF}:${DOCKER_IMAGE_VERSION} owserver --version
	docker run --rm --privileged ${DOCKER_IMAGE_NAME_AMD64}:${DOCKER_IMAGE_VERSION} owserver --version
