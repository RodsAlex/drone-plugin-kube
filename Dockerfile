FROM golang:alpine as builder

RUN apk update && apk upgrade && apk add --no-cache ca-certificates
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

RUN update-ca-certificates

COPY ./ /src

WORKDIR /src

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o main .

FROM scratch

COPY --from=builder /src/main /main
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/



CMD ["/main"]
