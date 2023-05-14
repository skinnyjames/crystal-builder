FROM fedora:38

RUN dnf -y install \
  gcc \
  gcc-c++ \
  gmp-devel \
  libbsd-devel \
  libedit-devel \
  libevent-devel \
  libxml2-devel \
  libyaml-devel \
  llvm-devel \
  llvm-static \
  libstdc++-static \
  make \
  openssl-devel \
  pcre-devel \
  redhat-rpm-config \
  gc-devel \
  curl \
  git \
  snapd

LABEL org.opencontainers.image.authors="Sean Gregory. <sean.christopher.gregory@gmail.com>"


RUN curl -L https://github.com/crystal-lang/crystal/releases/download/1.8.2/crystal-1.8.2-1-linux-x86_64.tar.gz > crystal.tar.gz
RUN tar -xvf crystal.tar.gz -C/usr/local --strip-components=1

.INCLUDE ./docker/snippets/build_local.tpl
.INCLUDE ./docker/snippets/docker.tpl