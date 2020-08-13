# IMAGE?=nightly.harbor.kongfanjian.com/library/multi-arch
IMAGE?=m

build:
	docker buildx build --no-cache --platform linux/amd64,linux/arm64 -t ${IMAGE} --push .

run-arm64:
	docker run --rm --platform=arm64 --name arm64web -p 9090:9090 ${IMAGE}

run-amd64:
	docker run --rm --platform=amd64 --name amd64web -p 9090:9090 ${IMAGE}
