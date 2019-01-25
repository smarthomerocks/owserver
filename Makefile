DOCKER_IMAGE_VERSION=$(shell curl --silent "https://api.github.com/repos/owfs/owfs/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
DOCKER_IMAGE_NAME_ARMHF=smarthomerocks/owserver-armhf
DOCKER_IMAGE_NAME_AMD64=smarthomerocks/owserver-amd64
DOCKER_IMAGE_TAGNAME_ARMHF=${DOCKER_IMAGE_NAME_ARMHF}:${DOCKER_IMAGE_VERSION}
DOCKER_IMAGE_TAGNAME_AMD64=${DOCKER_IMAGE_NAME_AMD64}:${DOCKER_IMAGE_VERSION}

default: build

build:
	@echo "building image: ${DOCKER_IMAGE_TAGNAME_ARMHF}"
	docker build -t ${DOCKER_IMAGE_TAGNAME_ARMHF} -t ${DOCKER_IMAGE_NAME_ARMHF}:latest -f armhf/Dockerfile
	@echo "building image: ${DOCKER_IMAGE_TAGNAME_AMD64}"
	docker build -t ${DOCKER_IMAGE_TAGNAME_AMD64} -t ${DOCKER_IMAGE_NAME_AMD64}:latest -f amd64/Dockerfile

push:
	docker push ${DOCKER_IMAGE_TAGNAME_ARMHF}
	docker push ${DOCKER_IMAGE_NAME_ARMHF}
	docker push ${DOCKER_IMAGE_TAGNAME_AMD64}
	docker push ${DOCKER_IMAGE_NAME_AMD64}	

test:
	docker run --rm --privileged ${DOCKER_IMAGE_TAGNAME_ARMHF} /bin/echo "Success."
	docker run --rm --privileged ${DOCKER_IMAGE_TAGNAME_AMD64} /bin/echo "Success."

version:
	docker run --rm --privileged ${DOCKER_IMAGE_TAGNAME_ARMHF} owserver --version
	docker run --rm --privileged ${DOCKER_IMAGE_TAGNAME_AMD64} owserver --version
