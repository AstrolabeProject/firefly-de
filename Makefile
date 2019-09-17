help:
	@echo "Make what? Try: docker, run, rund, exec, watch, stop"

docker:
	docker build -t firefly-de .

run:
	docker run -d --rm --name ff -p8888:8080 -v ${PWD}/images:/external ipac/firefly

rund:
	docker run -d --rm --name ff -p8888:8080 -v ${PWD}/images:/external -e DEBUG="TRUE" ipac/firefly

exec:
	docker exec -it ff /bin/bash

watch:
	docker logs -f ff

stop:
	docker stop ff
	-docker rm ff

%:
	@:
