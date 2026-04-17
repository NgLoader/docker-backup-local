# db-backup-local build instructions

Builds all image variants (PostgreSQL 13–18 × debian/alpine; MongoDB 8 debian) via `docker buildx bake`.

## Prepare environment

- Configure your system to use [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/).
- Prepare the crosscompile environment (see below) for multi-arch builds.

### Prepare crosscompile environment

On Arch Linux (for example):

```sh
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx rm multibuilder
docker buildx create --name multibuilder --platform linux/amd64,linux/arm64,linux/arm/v7,linux/s390x,linux/ppc64le --driver docker-container --use
docker buildx inspect --bootstrap
```

## Regenerate docker-bake.hcl

`docker-bake.hcl` is generated — do not edit by hand. Change `generate-docker-bake.sh` and regenerate:

```sh
./generate-docker-bake.sh docker-bake.hcl
```

CI verifies the checked-in `docker-bake.hcl` matches the generator output.

## Build locally

Build all targets:

```sh
docker buildx bake --pull
```

Build a specific target:

```sh
docker buildx bake --pull postgresql-debian-18
docker buildx bake --pull mongodb-debian-8
```

## Build with a custom image name or registry

```sh
REGISTRY_PREFIX="ghcr.io/my-org/" IMAGE_NAME="db-backup-local" docker buildx bake --pull
```

## Push to a registry

```sh
REGISTRY_PREFIX="ghcr.io/my-org/" docker buildx bake --pull --push
```

With a build revision suffix:

```sh
REGISTRY_PREFIX="ghcr.io/my-org/" \
  BUILD_REVISION=$(git rev-parse --short HEAD) \
  docker buildx bake --pull --push
```

With release version tags:

```sh
REGISTRY_PREFIX="ghcr.io/my-org/" \
  RELEASE_VERSION=v1.2.3 \
  RELEASE_VERSION_MINOR=v1.2 \
  RELEASE_VERSION_MAJOR=v1 \
  docker buildx bake --pull --push
```
