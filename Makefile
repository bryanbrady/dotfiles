REPO=bbrady
IMAGE=dotfiles
VERSION=0.0.0

docker-build:
	docker build . -t $(IMAGE)

docker-run: docker-build
	docker run --rm -it $(IMAGE) /bin/bash

docker-push-latest: docker-build
	docker tag $(IMAGE) $(REPO)/$(IMAGE)
	docker push $(REPO)/$(IMAGE)
