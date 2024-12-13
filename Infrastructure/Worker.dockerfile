FROM swift:noble AS dev
# TOOD replace this with nixos/nix once nix has swift 6 support
# https://github.com/NixOS/nixpkgs/issues/343210#issuecomment-2424134735

# install swift static SDK
RUN swift sdk install https://download.swift.org/swift-6.0.2-release/static-sdk/swift-6.0.2-RELEASE/swift-6.0.2-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz --checksum aa5515476a403797223fc2aad4ca0c3bf83995d5427fb297cab1d93c68cee075

RUN apt update -y
RUN apt upgrade -y

RUN apt install -y zsh
RUN apt install -y curl
RUN apt install -y git
RUN apt install -y gpg
RUN apt install -y cmake
RUN apt install -y ninja-build
RUN apt install -y gdb
# clang is already included in the base image
RUN apt install -y clangd
RUN apt install -y clang-format
RUN apt install -y clang-tidy
RUN apt install -y zip
RUN apt install -y python3

# for GNU builds
RUN apt install -y gcc-14
RUN apt install -y gobjc-14
RUN apt install -y g++-14
RUN apt install -y gobjc++-14

# Haskell & Rust tools
RUN apt install -y cargo
RUN apt install -y rustc
RUN apt install -y ghc

# tools
RUN apt install -y swi-prolog

# Node modules
RUN apt install -y npm

# we do not need to install clang since it is included in the swift:noble image

WORKDIR /

# configure this

ENV CC=/usr/bin/gcc-14
ENV CXX=/usr/bin/g++-14
ENV OBJCC=/usr/bin/gcc-14
ENV OBJCXX=/usr/bin/g++-14

ENV CMAKE_C_COMPILER=/usr/bin/gcc-14
ENV CMAKE_CXX_COMPILER=/usr/bin/g++-14
ENV CMAKE_OBJC_COMPILER=/usr/bin/gcc-14
ENV CMAKE_OBJCXX_COMPILER=/usr/bin/g++-14

RUN git config --global --add safe.directory /workspace

FROM dev AS build

# TODO: build it to a static binary

RUN mkdir /build
RUN mkdir /source

COPY . /source

RUN cmake -S /source -B /build -G Ninja --preset release-x86-64-unknown-linux-gnu
RUN ninja -C /build SwiftPackage
RUN strip /build/SPM/x86_64-unknown-linux-gnu/debug/LX

# TODO switch to alpine:latest once we can build it statically
FROM swift:noble AS run

RUN mkdir /app
COPY --from=build /build/SPM/x86_64-unknown-linux-gnu/debug/LX /app
CMD [ "/app/LX" ]