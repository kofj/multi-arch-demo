FROM golang:1.14 as builder
COPY . /src
WORKDIR /src
RUN ls -al && go build -mod=vendor -v -o /src/bin/webapp /src/cmd/main.go

# Final image
FROM alpine
WORKDIR /app
LABEL authors="Fanjian Kong"
COPY --from=builder /src/bin/webapp /app/webapp
CMD ["/app/webapp"]
