NAME = "docker-sna"

.PHONY: all run build clean

all: build run

.built: Dockerfile
	docker build -t $(NAME) .
	@docker inspect -f '{{.Id}}' $(NAME) > .built

build: .built

run: build
	docker run -ti $(NAME) /bin/bash

clean:
	@$(RM) .built
	-docker rmi -f $(NAME)
