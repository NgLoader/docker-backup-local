ARG BASE_IMAGE=postgres:18
FROM ${BASE_IMAGE}

ARG GOCRONVER=v0.0.11
ARG TARGETOS
ARG TARGETARCH

# FIX Debian cross build
ARG DEBIAN_FRONTEND=noninteractive
RUN set -x \
	&& ln -sf /usr/bin/dpkg-split /usr/sbin/dpkg-split \
	&& ln -sf /usr/bin/dpkg-deb /usr/sbin/dpkg-deb \
	&& ln -sf /bin/tar /usr/sbin/tar \
	&& ln -sf /bin/rm /usr/sbin/rm \
	&& ln -sf /usr/bin/dpkg-split /usr/local/sbin/dpkg-split \
	&& ln -sf /usr/bin/dpkg-deb /usr/local/sbin/dpkg-deb \
	&& ln -sf /bin/tar /usr/local/sbin/tar \
	&& ln -sf /bin/rm /usr/local/sbin/rm
#

RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && apt-get clean && rm -rf /var/lib/apt/lists/* \
	&& curl --fail --retry 4 --retry-all-errors -o /usr/local/bin/go-cron.gz -L https://github.com/prodrigestivill/go-cron/releases/download/$GOCRONVER/go-cron-$TARGETOS-$TARGETARCH.gz \
	&& gzip -vnd /usr/local/bin/go-cron.gz && chmod a+x /usr/local/bin/go-cron

ENV DB_TYPE="**None**" \
    DB_HOST="**None**" \
    DB_PORT="**None**" \
    DB_NAME="**None**" \
    DB_NAME_FILE="**None**" \
    DB_USER="**None**" \
    DB_USER_FILE="**None**" \
    DB_PASS="**None**" \
    DB_PASS_FILE="**None**" \
    DB_PASSFILE_STORE="**None**" \
    DB_AUTH="**None**" \
    DB_CLUSTER="FALSE" \
    DB_EXTRA_OPTS="" \
    SCHEDULE="@daily" \
    VALIDATE_ON_START="TRUE" \
    BACKUP_ON_START="FALSE" \
    BACKUP_DIR="/backups" \
    BACKUP_SUFFIX=".sql.gz" \
    BACKUP_LATEST_TYPE="symlink" \
    BACKUP_KEEP_DAYS=7 \
    BACKUP_KEEP_WEEKS=4 \
    BACKUP_KEEP_MONTHS=6 \
    BACKUP_KEEP_MINS=1440 \
    HEALTHCHECK_PORT=8080 \
    WEBHOOK_URL="**None**" \
    WEBHOOK_ERROR_URL="**None**" \
    WEBHOOK_PRE_BACKUP_URL="**None**" \
    WEBHOOK_POST_BACKUP_URL="**None**" \
    WEBHOOK_EXTRA_ARGS=""

COPY hooks /hooks
COPY backup.sh env.sh init.sh /

VOLUME /backups

ENTRYPOINT []
CMD ["/init.sh"]

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f "http://localhost:$HEALTHCHECK_PORT/" || exit 1
