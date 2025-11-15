        .PHONY: build run stop push-ghcr

        IMAGE=hello-docker:local
        PORT?=8000

        build:
        	docker build -t $(IMAGE) .

        run:
        	docker run --rm -p $(PORT):8000 $(IMAGE)

        stop:
        	# Finds and stops container exposing 8000 (best-effort)
        	@CID=$$(docker ps -q --filter publish=8000) ; \
	if [ -n "$$CID" ]; then docker stop $$CID ; else echo "No container on :8000"; fi

        # Build & push multi-arch image to GHCR with your username/repo
        push-ghcr:
        	@[ "$$GH_USER" ] && [ "$$GH_REPO" ] || (echo "Usage: make push-ghcr GH_USER=<user> GH_REPO=<repo>"; exit 2)
        	docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/$(GH_USER)/$(GH_REPO):latest --push .
