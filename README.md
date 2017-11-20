# Fully Self-Contained Userland QEMU in a Container
[![Docker Build Status](https://img.shields.io/docker/build/fkrull/qemu-user-static.svg?style=flat-square)](https://hub.docker.com/r/fkrull/qemu-user-static/)

This image provides execution support for foreign-architecture binaries on
amd64, using Debian's
[qemu-user-static](https://packages.debian.org/sid/qemu-user-static) build of
QEMU's user mode emulator.

[QEMU's user mode emulation](https://qemu.weilnetz.de/doc/qemu-doc.html#QEMU-User-space-emulator)
doesn't emulate a full system but runs a foreign binary by translating
instructions and system calls. By registering this emulator with Linux's
`binfmt_misc` feature, foreign binaries can be executed "magically" by
transparently handing them off to QEMU (so long as all userland binaries are
present).

This image registers the emulator binaries with the `F - fix binary` flag (see
the relevant
[Linux docs](https://www.kernel.org/doc/html/latest/admin-guide/binfmt-misc.html)),
a new feature in Linux 4.8. This makes the emulator work properly even within
chroots and containers so that it's possible to build and run
foreign-architecture Docker images.

## Requirements
* an amd64 Docker host
* Linux 4.8 or newer with `binfmt_misc` support, either built-in or as a module
* shell access to the Docker host, to load the kernel module if necessary

## Usage
```
# modprobe binfmt_misc
# docker run --rm --privileged fkrull/qemu-user-static enable
```

The `binfmt_misc` module may already be loaded on your system; unfortunately, it
can't be loaded inside the container so you need to do it manually.

To disable the integration again, either reboot the system or run the following
command:
```
$ docker run --rm --privileged fkrull/qemu-user-static disable
```

## Cross-Building Docker Images
After registering the emulator as above, it's possible to run Docker images for
other architectures:
```
$ docker run --rm -it arm32v7/debian
root@ac8b1d976479:/#
```

There is currently no way to specify what architecture to use when pulling an
image from a
[manifest list](https://blog.docker.com/2017/09/docker-official-images-now-multi-platform/).
That means it's not possible to cross-build an image from a Dockerfile that
starts with an unadorned:
```
FROM debian:stable
...
```

To cross-build an image, the target architecture needs to be specified in the
`FROM`:
```
FROM arm32v7/debian:stable
...
```

The architecture can be specified as a build argument if one wants to target
multiple architectures:
```
ARG TARGET_ARCH
FROM ${TARGET_ARCH}/debian:stable
...
```

Note that it depends on the image how specific architectures are referenced. The
official Docker Hub images (the ones without the initial `namespace/`) use the
convention shown above, but others may use other forms like separate
repositories or architecture tags.

## License
Copyright (c) 2017 Felix Krull. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
may be used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
