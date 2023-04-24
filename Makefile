REGISTRY := ${DOCKER_REGISTRY}
REGISTRY_LOGIN := ${DOCKER_REGISTRY_LOGIN}
REGISTRY_PASSWORD := ${DOCKER_REGISTRY_PASSWORD}
REGISTRY_IMAGE := mxs-blog

all: help

help:
	@echo "MXS WEBSITE COMMAND LINE CENTER"
	@echo ""
	@echo "make help"
	@echo "    Show this help"
	@echo ""
	@echo "make build"
	@echo "    Build Docker image"
	@echo ""
	@echo "make push"
	@echo "    Push to registry"

build:
	@echo "Building website"
	@docker build -t $(REGISTRY)/${REGISTRY_IMAGE} .

push: build
	@echo "Publishing website to ${REGISTRY}/{REGISTRY_IMAGE}:prod"
	@docker tag $(REGISTRY)/${REGISTRY_IMAGE} $(REGISTRY)/${REGISTRY_IMAGE}:prod
	@docker login --username $(REGISTRY_LOGIN) --password $(REGISTRY_PASSWORD) $(REGISTRY)
	@docker image push $(REGISTRY)/${REGISTRY_IMAGE}:prod
	@scp docker-compose.yaml maethstro.com:services/mxs.sbrk.org/docker-compose.yaml
	@ssh maethstro.com "docker login --username $(REGISTRY_LOGIN) --password $(REGISTRY_PASSWORD) $(REGISTRY) && cd services/mxs.sbrk.org && docker-compose pull && docker-compose up -d"
