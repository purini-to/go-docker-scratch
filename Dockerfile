# syntax = docker/dockerfile:experimental

###############################
# Build container
###############################
FROM golang:1.12.5-alpine as builder

RUN \
    --mount=type=cache,target=/var/cache/apk \
    apk --update add upx shadow tzdata

RUN groupadd -r app && useradd --no-log-init -r -g app app

ENV GOOS=linux
ENV GOARCH=amd64
ENV GO111MODULE=auto

ENV APP_DIR /app
RUN mkdir -p $APP_DIR

WORKDIR $APP_DIR

RUN \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    --mount=type=bind,target=. \
    CGO_ENABLED=0 go build -ldflags '-d -w -s' -o /bin/app &&\
    upx /bin/app


###############################
# Run container
###############################
FROM scratch as runner

ENV TZ=Asia/Tokyo
ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8

ENV APP_DIR /bin

WORKDIR $APP_DIR

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
#COPY --from=builder /usr/share/zoneinfo/Asia/Tokyo /usr/share/zoneinfo

COPY --from=builder /bin/app $APP_DIR/

USER app

EXPOSE 3000

ENTRYPOINT ["/bin/app"]
