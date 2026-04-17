group "default" {
	targets = ["postgresql-debian-18", "postgresql-alpine-18", "postgresql-debian-17", "postgresql-alpine-17", "postgresql-debian-16", "postgresql-alpine-16", "postgresql-debian-15", "postgresql-alpine-15", "postgresql-debian-14", "postgresql-alpine-14", "postgresql-debian-13", "postgresql-alpine-13", "mongodb-debian-8"]
}

variable "REGISTRY_PREFIX" {
	default = ""
}

variable "IMAGE_NAME" {
	default = "db-backup-local"
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
	args = {"GOCRONVER" = "v0.0.11"}
	dockerfile = "debian.Dockerfile"
}

target "alpine" {
	args = {"GOCRONVER" = "v0.0.11"}
	dockerfile = "alpine.Dockerfile"
}

target "postgresql-debian-18" {
	inherits = ["debian"]
	platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7", "linux/s390x", "linux/ppc64le"]
	args = {"BASE_IMAGE" = "postgres:18"}
	tags = [
		"${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-18",
		notequal("", BUILD_REVISION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-18-${BUILD_REVISION}" : "",
		notequal("", RELEASE_VERSION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-18-${RELEASE_VERSION}" : "",
		notequal("", RELEASE_VERSION_MINOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-18-${RELEASE_VERSION_MINOR}" : "",
		notequal("", RELEASE_VERSION_MAJOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-18-${RELEASE_VERSION_MAJOR}" : "",
		"${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql"
	]
}

target "postgresql-alpine-18" {
	inherits = ["alpine"]
	platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7", "linux/s390x", "linux/ppc64le"]
	args = {"BASE_IMAGE" = "postgres:18-alpine"}
	tags = [
		"${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-18-alpine",
		notequal("", BUILD_REVISION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-18-alpine-${BUILD_REVISION}" : "",
		notequal("", RELEASE_VERSION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-18-alpine-${RELEASE_VERSION}" : "",
		notequal("", RELEASE_VERSION_MINOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-18-alpine-${RELEASE_VERSION_MINOR}" : "",
		notequal("", RELEASE_VERSION_MAJOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-18-alpine-${RELEASE_VERSION_MAJOR}" : "",
		"${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-alpine"
	]
}

target "postgresql-debian-17" {
	inherits = ["debian"]
	platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7", "linux/s390x", "linux/ppc64le"]
	args = {"BASE_IMAGE" = "postgres:17"}
	tags = [
		"${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-17",
		notequal("", BUILD_REVISION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-17-${BUILD_REVISION}" : "",
		notequal("", RELEASE_VERSION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-17-${RELEASE_VERSION}" : "",
		notequal("", RELEASE_VERSION_MINOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-17-${RELEASE_VERSION_MINOR}" : "",
		notequal("", RELEASE_VERSION_MAJOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-17-${RELEASE_VERSION_MAJOR}" : ""
	]
}

target "postgresql-alpine-17" {
	inherits = ["alpine"]
	platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7", "linux/s390x", "linux/ppc64le"]
	args = {"BASE_IMAGE" = "postgres:17-alpine"}
	tags = [
		"${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-17-alpine",
		notequal("", BUILD_REVISION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-17-alpine-${BUILD_REVISION}" : "",
		notequal("", RELEASE_VERSION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-17-alpine-${RELEASE_VERSION}" : "",
		notequal("", RELEASE_VERSION_MINOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-17-alpine-${RELEASE_VERSION_MINOR}" : "",
		notequal("", RELEASE_VERSION_MAJOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-17-alpine-${RELEASE_VERSION_MAJOR}" : ""
	]
}

target "postgresql-debian-16" {
	inherits = ["debian"]
	platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7", "linux/s390x", "linux/ppc64le"]
	args = {"BASE_IMAGE" = "postgres:16"}
	tags = [
		"${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-16",
		notequal("", BUILD_REVISION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-16-${BUILD_REVISION}" : "",
		notequal("", RELEASE_VERSION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-16-${RELEASE_VERSION}" : "",
		notequal("", RELEASE_VERSION_MINOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-16-${RELEASE_VERSION_MINOR}" : "",
		notequal("", RELEASE_VERSION_MAJOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-16-${RELEASE_VERSION_MAJOR}" : ""
	]
}

target "postgresql-alpine-16" {
	inherits = ["alpine"]
	platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7", "linux/s390x", "linux/ppc64le"]
	args = {"BASE_IMAGE" = "postgres:16-alpine"}
	tags = [
		"${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-16-alpine",
		notequal("", BUILD_REVISION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-16-alpine-${BUILD_REVISION}" : "",
		notequal("", RELEASE_VERSION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-16-alpine-${RELEASE_VERSION}" : "",
		notequal("", RELEASE_VERSION_MINOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-16-alpine-${RELEASE_VERSION_MINOR}" : "",
		notequal("", RELEASE_VERSION_MAJOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-16-alpine-${RELEASE_VERSION_MAJOR}" : ""
	]
}

target "postgresql-debian-15" {
	inherits = ["debian"]
	platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7", "linux/s390x", "linux/ppc64le"]
	args = {"BASE_IMAGE" = "postgres:15"}
	tags = [
		"${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-15",
		notequal("", BUILD_REVISION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-15-${BUILD_REVISION}" : "",
		notequal("", RELEASE_VERSION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-15-${RELEASE_VERSION}" : "",
		notequal("", RELEASE_VERSION_MINOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-15-${RELEASE_VERSION_MINOR}" : "",
		notequal("", RELEASE_VERSION_MAJOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-15-${RELEASE_VERSION_MAJOR}" : ""
	]
}

target "postgresql-alpine-15" {
	inherits = ["alpine"]
	platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7", "linux/s390x", "linux/ppc64le"]
	args = {"BASE_IMAGE" = "postgres:15-alpine"}
	tags = [
		"${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-15-alpine",
		notequal("", BUILD_REVISION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-15-alpine-${BUILD_REVISION}" : "",
		notequal("", RELEASE_VERSION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-15-alpine-${RELEASE_VERSION}" : "",
		notequal("", RELEASE_VERSION_MINOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-15-alpine-${RELEASE_VERSION_MINOR}" : "",
		notequal("", RELEASE_VERSION_MAJOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-15-alpine-${RELEASE_VERSION_MAJOR}" : ""
	]
}

target "postgresql-debian-14" {
	inherits = ["debian"]
	platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7", "linux/s390x", "linux/ppc64le"]
	args = {"BASE_IMAGE" = "postgres:14"}
	tags = [
		"${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-14",
		notequal("", BUILD_REVISION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-14-${BUILD_REVISION}" : "",
		notequal("", RELEASE_VERSION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-14-${RELEASE_VERSION}" : "",
		notequal("", RELEASE_VERSION_MINOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-14-${RELEASE_VERSION_MINOR}" : "",
		notequal("", RELEASE_VERSION_MAJOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-14-${RELEASE_VERSION_MAJOR}" : ""
	]
}

target "postgresql-alpine-14" {
	inherits = ["alpine"]
	platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7", "linux/s390x", "linux/ppc64le"]
	args = {"BASE_IMAGE" = "postgres:14-alpine"}
	tags = [
		"${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-14-alpine",
		notequal("", BUILD_REVISION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-14-alpine-${BUILD_REVISION}" : "",
		notequal("", RELEASE_VERSION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-14-alpine-${RELEASE_VERSION}" : "",
		notequal("", RELEASE_VERSION_MINOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-14-alpine-${RELEASE_VERSION_MINOR}" : "",
		notequal("", RELEASE_VERSION_MAJOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-14-alpine-${RELEASE_VERSION_MAJOR}" : ""
	]
}

target "postgresql-debian-13" {
	inherits = ["debian"]
	platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7", "linux/s390x", "linux/ppc64le"]
	args = {"BASE_IMAGE" = "postgres:13"}
	tags = [
		"${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-13",
		notequal("", BUILD_REVISION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-13-${BUILD_REVISION}" : "",
		notequal("", RELEASE_VERSION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-13-${RELEASE_VERSION}" : "",
		notequal("", RELEASE_VERSION_MINOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-13-${RELEASE_VERSION_MINOR}" : "",
		notequal("", RELEASE_VERSION_MAJOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-13-${RELEASE_VERSION_MAJOR}" : ""
	]
}

target "postgresql-alpine-13" {
	inherits = ["alpine"]
	platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7", "linux/s390x", "linux/ppc64le"]
	args = {"BASE_IMAGE" = "postgres:13-alpine"}
	tags = [
		"${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-13-alpine",
		notequal("", BUILD_REVISION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-13-alpine-${BUILD_REVISION}" : "",
		notequal("", RELEASE_VERSION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-13-alpine-${RELEASE_VERSION}" : "",
		notequal("", RELEASE_VERSION_MINOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-13-alpine-${RELEASE_VERSION_MINOR}" : "",
		notequal("", RELEASE_VERSION_MAJOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:postgresql-13-alpine-${RELEASE_VERSION_MAJOR}" : ""
	]
}

target "mongodb-debian-8" {
	inherits = ["debian"]
	platforms = ["linux/amd64", "linux/arm64"]
	args = {"BASE_IMAGE" = "mongo:8"}
	tags = [
		"${REGISTRY_PREFIX}${IMAGE_NAME}:mongodb-8",
		notequal("", BUILD_REVISION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:mongodb-8-${BUILD_REVISION}" : "",
		notequal("", RELEASE_VERSION) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:mongodb-8-${RELEASE_VERSION}" : "",
		notequal("", RELEASE_VERSION_MINOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:mongodb-8-${RELEASE_VERSION_MINOR}" : "",
		notequal("", RELEASE_VERSION_MAJOR) ? "${REGISTRY_PREFIX}${IMAGE_NAME}:mongodb-8-${RELEASE_VERSION_MAJOR}" : "",
		"${REGISTRY_PREFIX}${IMAGE_NAME}:mongodb"
	]
}
