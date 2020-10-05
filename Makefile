# IMAGE?=nightly.harbor.kongfanjian.com/library/multi-arch
IMAGE?=kofj/multi-demo

build:
	docker buildx build --no-cache --platform linux/amd64,linux/arm64 -t ${IMAGE} --push .

build-tar:
	docker buildx build --no-cache --platform linux/amd64,linux/arm64 -t ${IMAGE} --output=tar .

run-arm64:
	docker run --rm --platform=arm64 --name arm64web -p 9090:9090 ${IMAGE}

run-amd64:
	docker run --rm --platform=amd64 --name amd64web -p 9090:9090 ${IMAGE}
