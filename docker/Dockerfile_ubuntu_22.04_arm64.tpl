FROM ubuntu:22.04 as builder

.INCLUDE ./docker/VERSIONS

ENV TZ="Etc/UTC"

# Install required packages
RUN apt-get update -q \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      build-essential \
      libevent-2.1-7

FROM ubuntu:22.04

LABEL org.opencontainers.image.authors="Sean Gregory. <sean.christopher.gregory@gmail.com>"

.INCLUDE ./docker/snippets/crystal

COPY --from=builder / /

.INCLUDE ./docker/snippets/build_local.tpl
.INCLUDE ./docker/snippets/docker.tpl