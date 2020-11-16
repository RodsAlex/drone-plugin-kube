FROM golang:alpine as builder

RUN apk update && apk upgrade && apk add --no-cache ca-certificates
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

RUN update-ca-certificates

WORKDIR /src

COPY . .

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o main .

FROM docker:stable

RUN apk add --update --no-cache ca-certificates bash build-base curl python-dev py-pip libevent-dev libffi-dev openssl-dev \
    && pip install docker-compose

COPY --from=builder /src/main /main
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/



CMD ["/main"]
