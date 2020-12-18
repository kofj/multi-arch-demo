IMAGE?=harbor-community.tencentcloudcr.com/multi-arch/demo
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
EMPTY:=
SPACE:=$(EMPTY) $(EMPTY)
LINUX_ARCH=amd64 arm64 riscv64
IMAGES:=$(foreach arch,$(LINUX_ARCH),$(IMAGE):$(arch))
BUILD_ARCH?=$(uname -m)
BUILD_OS?=$(uname -s)
BUILD_PATH=build/docker/linux
LDFLAGS="-s -w -X github.com/kofj/multi-arch-demo/cmd/info.BuildArch=$(BUILD_ARCH) -X github.com/kofj/multi-arch-demo/cmd/info.BuildOS=$(BUILD_OS)"

.PHONY: build
build:
	docker buildx build --no-cache --platform linux/amd64,linux/arm64 -t ${IMAGE} --push .

build-tar:
	docker buildx build --no-cache --platform linux/amd64,linux/arm64 -t ${IMAGE} --output=tar .

run-arm64:
	docker run --rm --platform=arm64 --name arm64web -p 9090:9090 ${IMAGE}

run-amd64:
	docker run --rm --platform=amd64 --name amd64web -p 9090:9090 ${IMAGE}

run-riscv64:
	docker run --rm --platform=riscv64 --name riscv64web -p 9090:9090 ${IMAGE}

binary:
	@for arch in ${LINUX_ARCH}; do \
		echo ${GREEN}Build binary for ${RED}linux/$$arch${NOCOLOR}; \
		echo ===================; \
		GOARCH=$$arch GOOS=linux go build -o ${BUILD_PATH}/$$arch/webapp -ldflags=${LDFLAGS} -v cmd/main.go; \
	done

docker-build: binary
	@for arch in ${LINUX_ARCH}; do \
			echo ${GREEN}Build docker image for ${RED}linux/$$arch${NOCOLOR}; \
			echo ===================; \
	    cp Dockerfile.slim ${BUILD_PATH}/$$arch/Dockerfile ;\
	    docker build -t ${IMAGE}:$$arch ${BUILD_PATH}/$$arch ;\
			docker push ${IMAGE}:$$arch ;\
	done


.PHONY: craete-manifest
craete-manifest: docker-build
	@echo ${GREEN}Create manifest for ${RED} \( ${LINUX_ARCH}\) ${NOCOLOR};
	@docker manifest create ${IMAGE} ${IMAGES}
	@for arch in ${LINUX_ARCH}; do \
			echo ${GREEN}Annotate manifest ${RED}linux/$$arch${NOCOLOR}; \
			echo ===================; \
			docker manifest annotate ${IMAGE} ${IMAGE}:$$arch --os linux --arch $$arch; \
	done

.PHONY: push-manifest
push-manifest: craete-manifest
	docker manifest push ${IMAGE}

clean:
	@go clean
	@docker manifest rm ${IMAGE}
	@rm -fr ./build
