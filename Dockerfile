FROM golang:1.15.0-alpine3.12 AS builder

ENV GO111MODULE on
ENV GOPROXY https://goproxy.cn

RUN apk upgrade \
    && apk add git \
    && go get github.com/shadowsocks/go-shadowsocks2

FROM alpine:3.12 AS dist

LABEL maintainer="mritd <mritd@linux.com>"

RUN apk upgrade \
    && apk add tzdata \
    && rm -rf /var/cache/apk/*

COPY --from=builder /go/bin/go-shadowsocks2 /usr/bin/shadowsocks

# Expose shadowsocks server port
EXPOSE 10800/tcp
EXPOSE 10800/udp

# Set default command to run as server
ENTRYPOINT ["shadowsocks"]
CMD ["-s", "ss://AEAD_CHACHA20_POLY1305:xi207760@:10800"]
