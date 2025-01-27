FROM swift:noble AS dev
# TOOD replace this with nixos/nix once nix has swift 6 support
# FROM nixos/nix
# https://github.com/NixOS/nixpkgs/issues/343210#issuecomment-2424134735

# install swift static SDK
RUN swift sdk install https://download.swift.org/swift-6.0.2-release/static-sdk/swift-6.0.2-RELEASE/swift-6.0.2-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz --checksum aa5515476a403797223fc2aad4ca0c3bf83995d5427fb297cab1d93c68cee075

RUN apt update -y && apt upgrade -y && apt install -y curl git gpg cmake \
    ninja-build gdb clangd clang-format clang-tidy zip python3 swi-prolog \
    cargo rustc rust-src rustfmt
# clang is already included in the base image

# we do not need to install clang since it is included in the swift:noble image

WORKDIR /

# configure this

ENV CC=/usr/bin/clang
ENV CXX=/usr/bin/clang++
ENV OBJCC=/usr/bin/clang
ENV OBJCXX=/usr/bin/clang++

RUN git config --global --add safe.directory /workspace
EXPOSE 5173

FROM dev AS build

# TODO: build it to a static binary

RUN mkdir /source
RUN mkdir /build
VOLUME [ "/build" ]

COPY . /source

RUN cmake -S /source -B /build -G Ninja --preset release-x86-64-unknown-linux-gnu
RUN ninja -C /build SwiftPackage
RUN strip /build/.build/release/LX

# TODO switch to alpine:latest once we can build it statically
FROM swift:noble AS run

RUN mkdir /app
COPY --from=build /build/.build/release/LX /app

CMD [ "/app/LX" ]
EXPOSE 1337
HEALTHCHECK CMD curl --fail http://localhost:1337/version || exit 1