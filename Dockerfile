FROM golang:alpine as builder

RUN apk update && apk upgrade && apk add --no-cache ca-certificates

RUN update-ca-certificates

COPY ./ /src

RUN ls


WORKDIR /src

RUN ls


RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o main .

FROM ubuntu:latest

COPY --from=builder /src/main /main
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

CMD ["/main"]
