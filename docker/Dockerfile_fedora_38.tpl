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
  git 

LABEL org.opencontainers.image.authors="Sean Gregory. <sean.christopher.gregory@gmail.com>"

.INCLUDE ./docker/snippets/crystal
.INCLUDE ./docker/snippets/build_local.tpl
.INCLUDE ./docker/snippets/docker.tpl