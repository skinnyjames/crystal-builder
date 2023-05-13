FROM ubuntu:22.04 as builder

FROM ubuntu:22.04

# Install required packages
RUN apt-get update -q \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      build-essential \
      ca-certificates \
      libevent-2.1-7 \
      libtool \
      git \
      cmake \
      curl 


LABEL org.opencontainers.image.authors="Sean Gregory. <sean.christopher.gregory@gmail.com>"

.INCLUDE ./docker/snippets/crystal_deb

COPY --from=builder / /

.INCLUDE ./docker/snippets/build_local.tpl
.INCLUDE ./docker/snippets/docker.tpl