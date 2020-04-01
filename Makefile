PROJECT_ID = $(shell gcloud config get-value project)
PROJECT = $(shell gcloud projects list | awk '$$1=="'$(PROJECT_ID)'"{print($$2);}')

DOCKER_REGISTRY = asia.gcr.io
CT_NAME = ping-pong
REGION = us-central1
TAG = $(DOCKER_REGISTRY)/$(PROJECT_ID)/$(CT_NAME)

RAMSIZE = 1Gi

build: 
	docker build -t $(TAG) .

run: 
	docker run -p 5000:5000 --rm -it $(TAG)

debug: 
	docker run --entrypoint bash -p 5000:5000 --rm -it $(TAG)

config-registry:
	gcloud auth configure-docker

pull: config-registry
	docker pull $(TAG)

push: config-registry build
	docker push $(TAG)

deploy: build push
	gcloud beta run deploy $(CT_NAME) \
		--image=$(TAG) \
		--region=$(REGION) \
		--platform managed \
		--port 5000 \
		--memory $(RAMSIZE) \
		--allow-unauthenticated

