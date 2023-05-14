FROM ubuntu:22.04 as builder

FROM ubuntu:22.04

# Install required packages
RUN apt-get update -q \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      build-essential \
      ca-certificates \
      git \
      cmake \
      curl \
      automake \
      libbsd-dev \
      libtool \
      lld \
      llvm \
      llvm-dev \
      libz-dev \
      automake \
      make \
      lzip \
      python3 \
      autoconf

LABEL org.opencontainers.image.authors="Sean Gregory. <sean.christopher.gregory@gmail.com>"

.INCLUDE ./docker/snippets/crystal

COPY --from=builder / /

.INCLUDE ./docker/snippets/static_deb
.INCLUDE ./docker/snippets/build_local.tpl
.INCLUDE ./docker/snippets/docker.tpl

