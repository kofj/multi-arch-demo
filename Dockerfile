FROM golang:1.14 as builder
COPY . /src
WORKDIR /src
RUN ls -al && go build -a -tags netgo -ldflags "-s -w -X github.com/kofj/multi-arch-demo/cmd/info.BuildArch=${BuildArch} -X github.com/kofj/multi-arch-demo/cmd/info.BuildOS=${BuildOS}" -mod=vendor -v -o /src/bin/webapp /src/cmd/main.go

# Final image
FROM ubuntu:18.04
LABEL authors="Fanjian Kong"
COPY --from=builder /src/bin/webapp /app/
WORKDIR /app
CMD ["/app/webapp"]
