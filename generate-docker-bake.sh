#!/bin/sh

set -e

GOCRONVER="v0.0.11"
IMAGE_NAME="db-backup-local"

PG_MAIN="18"
PG_EXTRA="17 16 15 14 13"
MONGO_MAIN="8"

PLATFORMS_PG='"linux/amd64", "linux/arm64", "linux/arm/v7", "linux/s390x", "linux/ppc64le"'
PLATFORMS_MONGO='"linux/amd64", "linux/arm64"'

DOCKER_BAKE_FILE="${1:-docker-bake.hcl}"

cd "$(dirname "$0")"

BODY_FILE=$(mktemp)
trap 'rm -f "$BODY_FILE"' EXIT

TARGETS=""

emit_target() {
	NAME="$1"
	INHERITS="$2"
	PLATS="$3"
	BASE_IMAGE="$4"
	TAG_PREFIX="$5"
	LATEST_ALIAS="$6"

	if [ -z "$TARGETS" ]; then
		TARGETS="\"$NAME\""
	else
		TARGETS="$TARGETS, \"$NAME\""
	fi

	TAGS="		\"\${REGISTRY_PREFIX}\${IMAGE_NAME}:$TAG_PREFIX\""
	TAGS="$TAGS,
		notequal(\"\", BUILD_REVISION) ? \"\${REGISTRY_PREFIX}\${IMAGE_NAME}:$TAG_PREFIX-\${BUILD_REVISION}\" : \"\""
	TAGS="$TAGS,
		notequal(\"\", RELEASE_VERSION) ? \"\${REGISTRY_PREFIX}\${IMAGE_NAME}:$TAG_PREFIX-\${RELEASE_VERSION}\" : \"\""
	TAGS="$TAGS,
		notequal(\"\", RELEASE_VERSION_MINOR) ? \"\${REGISTRY_PREFIX}\${IMAGE_NAME}:$TAG_PREFIX-\${RELEASE_VERSION_MINOR}\" : \"\""
	TAGS="$TAGS,
		notequal(\"\", RELEASE_VERSION_MAJOR) ? \"\${REGISTRY_PREFIX}\${IMAGE_NAME}:$TAG_PREFIX-\${RELEASE_VERSION_MAJOR}\" : \"\""
	if [ -n "$LATEST_ALIAS" ]; then
		TAGS="$TAGS,
		\"\${REGISTRY_PREFIX}\${IMAGE_NAME}:$LATEST_ALIAS\""
	fi

	cat >> "$BODY_FILE" << EOF

target "$NAME" {
	inherits = ["$INHERITS"]
	platforms = [$PLATS]
	args = {"BASE_IMAGE" = "$BASE_IMAGE"}
	tags = [
$TAGS
	]
}
EOF
}

# PostgreSQL: debian + alpine, all versions
for VER in $PG_MAIN $PG_EXTRA; do
	if [ "$VER" = "$PG_MAIN" ]; then
		emit_target "postgresql-debian-$VER" "debian" "$PLATFORMS_PG" "postgres:$VER" "postgresql-$VER" "postgresql"
		emit_target "postgresql-alpine-$VER" "alpine" "$PLATFORMS_PG" "postgres:$VER-alpine" "postgresql-$VER-alpine" "postgresql-alpine"
	else
		emit_target "postgresql-debian-$VER" "debian" "$PLATFORMS_PG" "postgres:$VER" "postgresql-$VER" ""
		emit_target "postgresql-alpine-$VER" "alpine" "$PLATFORMS_PG" "postgres:$VER-alpine" "postgresql-$VER-alpine" ""
	fi
done

# MongoDB: debian only (no official mongo alpine image)
for VER in $MONGO_MAIN; do
	emit_target "mongodb-debian-$VER" "debian" "$PLATFORMS_MONGO" "mongo:$VER" "mongodb-$VER" "mongodb"
done

cat > "$DOCKER_BAKE_FILE" << EOF
group "default" {
	targets = [$TARGETS]
}

variable "REGISTRY_PREFIX" {
	default = ""
}

variable "IMAGE_NAME" {
	default = "$IMAGE_NAME"
}

variable "BUILD_REVISION" {
	default = ""
}

variable "RELEASE_VERSION" {
	default = ""
}

variable "RELEASE_VERSION_MINOR" {
	default = ""
}

variable "RELEASE_VERSION_MAJOR" {
	default = ""
}

target "debian" {
	args = {"GOCRONVER" = "$GOCRONVER"}
	dockerfile = "debian.Dockerfile"
}

target "alpine" {
	args = {"GOCRONVER" = "$GOCRONVER"}
	dockerfile = "alpine.Dockerfile"
}
EOF

cat "$BODY_FILE" >> "$DOCKER_BAKE_FILE"
