REPO=bbrady
IMAGE=dotfiles
VERSION=0.0.0

docker-build:
	docker build . -t $(IMAGE):$(VERSION)

docker-run: docker-build
	docker run --rm -it $(IMAGE):$(VERSION) /bin/bash

docker-push-latest: docker-build
	docker tag $(IMAGE):$(VERSION) $(REPO)/$(IMAGE):$(VERSION)
	docker push $(REPO)/$(IMAGE)
