PYTHON_VERSION    ?= 3.7.4
GITHUB_REF        ?= $(shell git symbolic-ref -q HEAD || git describe --tags --exact-match)
DOCKER_IMAGE_NAME ?= python-gdal
DOCKER_IMAGE_TAG  ?= $(shell echo $(GITHUB_REF) | sed 's/refs\/heads\///g' | sed 's/refs\/tags\///g' | sed 's/\//-/g' | sed 's/_/-/g' | sed 's/master/latest/')

ifeq ($(DOCKER_REGISTRY_URL),)
	DOCKER_IMAGE := $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)
else
	DOCKER_IMAGE := $(DOCKER_REGISTRY_URL)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)
endif

OK_COLOR := \033[32;01m
NO_COLOR := \033[0m

build:
	@echo "$(OK_COLOR)==>$(NO_COLOR) Building $(DOCKER_IMAGE)"
	@docker build . --tag=$(DOCKER_IMAGE) --file=Dockerfile --build-arg=PYTHON_VERSION=$(PYTHON_VERSION)
	@echo ""

push:
	@echo "$(OK_COLOR)==>$(NO_COLOR) Pushing $(DOCKER_IMAGE)"
	@docker push $(DOCKER_IMAGE)
	@echo ""

clean:
	@echo "$(OK_COLOR)==>$(NO_COLOR) Cleanup $(DOCKER_IMAGE)"
	@docker rmi $(DOCKER_IMAGE) || :
	@echo ""

.PHONY: build push clean
