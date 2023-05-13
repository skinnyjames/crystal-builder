% 
    if [ -z "$CI" ]; then
%
WORKDIR /usr/src/app

# Build the project
COPY shard.yml shard.lock ./
RUN shards install
COPY src src
COPY LICENSE LICENSE
COPY .git .git
RUN shards build
RUN mv bin/crystal-builder /

# Copy assets
RUN mkdir -p /opt/barista/resources

COPY ./src/files /opt/barista/resources/files

WORKDIR /
%
    fi
%
