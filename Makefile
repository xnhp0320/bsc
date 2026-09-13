.PHONY: bootstrap deps build smoke counter clean

bootstrap:
	./scripts/bootstrap.sh

deps:
	./scripts/install-deps.sh

build: bootstrap
	./scripts/build-bsc.sh

smoke: build
	./scripts/run-smoke.sh

counter: build
	./scripts/run-counter.sh

clean:
	rm -rf build
