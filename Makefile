DOCKER_IMAGE_VERSION=$(shell curl --silent "https://api.github.com/repos/owfs/owfs/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

default:
	@echo "Run 'make build-arm' for Raspberry, or 'make build-amd64' for PC"

build-arm:
	@echo "building image: smarthomerocks/owserver-armhf:$(DOCKER_IMAGE_VERSION)"
	docker build -t smarthomerocks/owserver-armhf:$(DOCKER_IMAGE_VERSION) -f armhf/Dockerfile .
	docker tag smarthomerocks/owserver-armhf:$(DOCKER_IMAGE_VERSION) smarthomerocks/owserver-armhf:latest
	docker run --rm -it --privileged smarthomerocks/owserver-armhf:$(DOCKER_IMAGE_VERSION) owserver --version

build-amd64:
	@echo "building image: smarthomerocks/owserver-amd64:$(DOCKER_IMAGE_VERSION)"
	docker build -t smarthomerocks/owserver-amd64:$(DOCKER_IMAGE_VERSION) -f amd64/Dockerfile .
	docker tag smarthomerocks/owserver-amd64:$(DOCKER_IMAGE_VERSION) smarthomerocks/owserver-amd64:latest
	docker run --rm -it --privileged smarthomerocks/owserver-amd64:$(DOCKER_IMAGE_VERSION) owserver --version

travis:
	@echo "building image: smarthomerocks/owserver-armhf:$(DOCKER_IMAGE_VERSION)"
	docker build -t smarthomerocks/owserver-armhf:$(DOCKER_IMAGE_VERSION) -f armhf/Dockerfile .
	docker tag smarthomerocks/owserver-armhf:$(DOCKER_IMAGE_VERSION) smarthomerocks/owserver-armhf:latest
	@echo "building image: smarthomerocks/owserver-amd64:$(DOCKER_IMAGE_VERSION)"
	docker build -t smarthomerocks/owserver-amd64:$(DOCKER_IMAGE_VERSION) -f amd64/Dockerfile .
	docker tag smarthomerocks/owserver-amd64:$(DOCKER_IMAGE_VERSION) smarthomerocks/owserver-amd64:latest
	@echo "pushing images to Docker hub"
	docker push smarthomerocks/owserver-armhf:$(DOCKER_IMAGE_VERSION)
	docker push smarthomerocks/owserver-armhf:latest
	docker push smarthomerocks/owserver-amd64:$(DOCKER_IMAGE_VERSION)
	docker push smarthomerocks/owserver-amd64:latest
	docker manifest create smarthomerocks/owserver:latest smarthomerocks/owserver-armhf:latest smarthomerocks/owserver-amd64:latest
	docker manifest annotate smarthomerocks/owserver:latest smarthomerocks/owserver-armhf:latest --os linux --arch arm
	docker manifest annotate smarthomerocks/owserver:latest smarthomerocks/owserver-amd64:latest --os linux --arch amd64
	docker manifest push smarthomerocks/owserver:latest
