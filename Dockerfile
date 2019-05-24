# syntax = docker/dockerfile:experimental

###############################
# Build container
###############################
FROM golang:1.12.5-alpine as builder

# Ca-certificates is required to call HTTPS endpoints.
RUN \
    --mount=type=cache,target=/var/cache/apk \
    apk --update add upx tzdata ca-certificates &&\
    update-ca-certificates

RUN adduser -D -g '' appuser

ENV APP_DIR /app
RUN mkdir -p $APP_DIR

WORKDIR $APP_DIR

RUN \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    --mount=type=bind,target=. \
    CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -a -installsuffix cgo -o /bin/app &&\
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

USER appuser

EXPOSE 3000

ENTRYPOINT ["/bin/app"]
