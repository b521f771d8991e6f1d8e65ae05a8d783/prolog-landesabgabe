# see here: https://www.swi-prolog.org/build/WebAssembly.html
FROM ubuntu:22.04

RUN apt update
RUN apt upgrade -y

WORKDIR /tmp
RUN apt install -y wget
RUN wget https://apt.kitware.com/kitware-archive.sh
RUN bash kitware-archive.sh

WORKDIR /

RUN apt install -y git
RUN apt install -y ninja-build
RUN apt install -y cmake
RUN apt install -y clang-tidy
RUN apt install -y perl
RUN apt install -y zsh
RUN apt install -y nodejs
RUN apt install -y emscripten

RUN git config --global --add safe.directory /workspace

# set up swift and swift-wasm
RUN apt-get -y install \
    binutils \
    git \
    gnupg2 \
    libc6-dev \
    libcurl4-openssl-dev \
    libedit2 \
    libgcc-11-dev \
    libpython3-dev \
    libsqlite3-0 \
    libstdc++-11-dev \
    libxml2-dev \
    libz3-dev \
    pkg-config \
    python3-lldb-13 \
    #tzdata \
    unzip \
    zlib1g-dev
RUN mkdir /swift
WORKDIR /swift
RUN apt install -y wget
RUN wget https://github.com/swiftwasm/swift/releases/download/swift-wasm-5.10.0-RELEASE/swift-wasm-5.10.0-RELEASE-ubuntu22.04_x86_64.tar.gz
RUN tar xzf swift-wasm-5.10.0-RELEASE-ubuntu22.04_x86_64.tar.gz

ENV CC=emcc
ENV CXX=em++
ENV SWIFTC=/swift/swift-wasm-5.10.0-RELEASE/usr/bin/swiftc

# to run tests
RUN apt install -y curl
RUN curl https://wasmtime.dev/install.sh -sSf | bash

WORKDIR /workspace/Sources/ActBuilder/act-builder
CMD ["npm", "start"]