# Toolchain image for C jobs: c-pipeline's `container` input runs every job
# inside it, so self-hosted runners only need Docker.
#
# Debian/Ubuntu on purpose: JavaScript actions (checkout, upload-artifact,
# sbom-action) run the runner's own Node inside the container, which needs
# glibc. Alpine/musl doesn't work.
#
# Version: see VERSION. Bump the major when a toolchain change can break
# builds (e.g. a new GCC major).
FROM ubuntu:26.04@sha256:f144425ff09be612d6d9ad965196e9cdc23dae1f42110a8a11a3e9a8198759f7

ARG DEBIAN_FRONTEND=noninteractive

# git:        checkout needs it to fetch tags (otherwise versions fall back
#             to 0.0.0-unknown)
# gh:         the release job creates GitHub releases with it
# curl, jq:   Artifactory upload, scripts
# libasan/ubsan ship with gcc (build-essential)
# pebble:     ships in the base image outside any package; nothing here uses
#             it, and its Go stdlib trips Trivy
RUN apt-get update \
 && apt-get upgrade -y --no-install-recommends \
 && apt-get install -y --no-install-recommends \
      build-essential \
      cmake \
      ninja-build \
      pkg-config \
      git \
      gh \
      curl \
      ca-certificates \
      jq \
      file \
      tar \
      gzip \
      xz-utils \
      zstd \
      unzip \
 && rm -rf /var/lib/apt/lists/* \
 && rm -f /usr/bin/pebble

LABEL org.opencontainers.image.source="https://github.com/HamiltonHills/pipeline-actions" \
      org.opencontainers.image.description="C build toolchain for HamiltonHills c-pipeline (GCC, CMake, git, gh, curl)"

# Runs as root: GitHub mounts the workspace into the container and container
# jobs expect root. c/build skips sudo when it's already root.
CMD ["bash"]
