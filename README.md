# crystal_builder

Produce distributions of [Crystal](https://github.com/crystal-lang/crystal).

This is a work in progress and a draft idea.

## Quickstart

```
./build_image ubuntu_22.04
mkdir ./volume-cache
docker run -v ./volume-cache:/cache -it crystal-builder:ubuntu_22.04
LOG_LEVEL=debug ./crystal-builder -t quick 1.8.2
mv /opt/barista/package/crystal-quick_1.8.2-1_amd64.deb /cache
```

## Usage

The idea behind this project is to

* create a build docker image for different platforms
* build a type and version of crystal lang into a package for that platform

### Making the build image

The `build_image` script at the project root generates a Dockerfile for the intended platform and builds an image from it.

The image name is `crystal-builder` and the tag is one of the available suffixes found in `docker/snippets/Dockerfile_(.*)`

For instance, to build an debian package for ubuntu, we can:

`./build_image ubuntu_22.04`

### Running a build

The build image contains a builder binary that compiles crystal (and its dependencies) to generates a platform package.

The builder will build each dependency in isolation for caching.  To cache the build artifacts, provide a volume mount to the container.

`mkdir ./volume-cache`
`docker run -v ./volume-cache:/cache -it crystal-builder:ubuntu_22.04`

The builder binary has a command `build` and it takes some options as well as a crystal sha/tag/branch as an argument.

```
# ./crystal-builder build --help
Description:
  Builds a Crystal package

Usage:
  build [options] [--] [<crystal-version>]

Arguments:
  crystal-version          The version of Crystal to build from source (default `master`)

Options:
  -t, --type[=TYPE]        Type of build <quick|full|static> (default quick)
  -w, --workers[=WORKERS]  The number of concurrent build workers to use (default 11)
  -p, --prefix[=PREFIX]    The directory to where the package will be installed to
  -c, --clean              Cleans current install before building
```

Note on `type`

* `quick` will build a dynamically linked Crystal, and specify its runtime dependencies in the platform package.
  * The build contains the interpreter and is not a release build currently.
* `full` will build a dynamically linked Crystal **with** all of its runtime dependencies.  Maybe this is useful for embedded systems? I don't know.
  * I haven't been able to fully test because LLVM takes a very long time to build.
* `static` does nothing yet.  Whoops!

Putting it together it may look like:

`./crystal-builder -t quick 1.8.2`

### After the build

The build should populate your volume mount with a cache so that subsequent builds of the same platform and type will consume from it.

It also makes a package in `/opt/barista/package`.  Feel free to copy it to your volume mount when finished.

### Installing the package

When installing the package, Crystal is installed to `prefix` (default `/opt/crystal`), with a symlink being generated in `/usr/local/bin`.

Please keep in mind that `/usr/local/bin/crystal` **will** be removed upon uninstalling.

## Contributing

1. Fork it (<https://github.com/your-github-user/crystal-build/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Sean Gregory](https://github.com/skinnyjames) - creator and maintainer
