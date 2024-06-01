DISTRIB ?= ubuntu
RELEASE ?= focal
NGINX_VERSION ?= 1.26.0
NGINX_DEB_RELEASE ?= 1
BROTLI_VERSION ?= 1.1.0

IMAGE_NAME := build-nginx-brotli-$(DISTRIB)-$(RELEASE)-$(NGINX_VERSION)-$(NGINX_DEB_RELEASE)_$(BROTLI_VERSION)

dist:
	mkdir -p $@

build: dist
	docker build \
		-t $(IMAGE_NAME) \
		-f Dockerfile-deb \
		--build-arg DISTRIB=$(DISTRIB) \
		--build-arg RELEASE=$(RELEASE) \
		--build-arg NGINX_VERSION=$(NGINX_VERSION) \
		--build-arg NGINX_DEB_RELEASE=$(NGINX_DEB_RELEASE) \
		--build-arg BROTLI_VERSION=$(BROTLI_VERSION) \
		.
	docker rm $(IMAGE_NAME) ||:
	docker run --name $(IMAGE_NAME) $(IMAGE_NAME)
	mkdir dist/$(DISTRIB)-$(RELEASE) || true
	docker cp $(IMAGE_NAME):src/. dist/$(DISTRIB)-$(RELEASE)

clean:
	-rm -rf dist
	-docker rm $(IMAGE_NAME)
	-docker rmi $(IMAGE_NAME)
