REPO=bbrady
IMAGE=dotfiles
VERSION=0.0.0

build:
	docker build . -t $(IMAGE)

run: build
	docker run --rm -it $(IMAGE) /bin/bash

push-latest: build
	docker tag $(IMAGE) $(REPO)/$(IMAGE)
	docker push $(REPO)/$(IMAGE)
