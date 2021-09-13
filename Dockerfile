FROM alpine:latest

RUN apk update && apk add \
    dhcp \
    && rm -rf /var/cache/apk/*