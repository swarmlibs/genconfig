ARG GOMPLATE_VERSION=alpine
FROM hairyhenderson/gomplate:$GOMPLATE_VERSION
RUN apk add --no-cache bash ca-certificates uuidgen
ADD rootfs /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
