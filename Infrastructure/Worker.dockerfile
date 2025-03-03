FROM containers.github.scch.at/land-ooe/docker-images/swift-cpp-rust-toolchain:main-latest AS vcpkg-builder

VOLUME "/vcpkg-cache"
ENV VCPKG_BUILD_PARALLEL_LEVEL=8
ENV VCPKG_BINARY_SOURCES=clear;files,/vcpkg-cache

RUN apt update && apt install -y zip unzip build-essential pkg-config wget
RUN wget -O vcpkg.tar.gz https://github.com/microsoft/vcpkg/archive/master.tar.gz
RUN mkdir /opt/vcpkg
RUN tar xf vcpkg.tar.gz --strip-components=1 -C /opt/vcpkg
RUN /opt/vcpkg/bootstrap-vcpkg.sh
RUN ln -s /opt/vcpkg/vcpkg /usr/local/bin/vcpkg

COPY vcpkg.json .
RUN vcpkg install --triplet x64-linux

FROM vcpkg-builder AS development
ARG BUILD_MODE

WORKDIR /
RUN git config --global --add safe.directory /workspace

FROM development AS build
ARG BUILD_MODE

VOLUME "/nix"

# TODO: build it to a static binary

RUN mkdir /workspace

COPY . /workspace
WORKDIR /workspace

RUN dotenvx run -f .env.${BUILD_MODE} -- cmake \
    --preset debug-x86-64-unknown-linux-gnu \
    -S . \
    -B out/build/debug-x86-64-unknown-linux-gnu \
    -G Ninja

RUN dotenvx run -f .env.${BUILD_MODE} -- ninja \
    -C out/build/debug-x86-64-unknown-linux-gnu \
    SwiftPackage

RUN strip .build/debug/LX

# TODO switch to alpine:latest once we can build it statically
FROM swift:noble AS production
ARG BUILD_MODE
ENV BUILD_MODE ${BUILD_MODE}

RUN apt update && apt upgrade -y && apt install -y curl && curl -sfS https://dotenvx.sh | sh

RUN mkdir /app
COPY --from=build /workspace/.build/debug/LX /app
COPY --from=build /workspace/.env* /app

WORKDIR /app
CMD /usr/bin/env dotenvx run -f .env.${BUILD_MODE} -- /app/LX
EXPOSE 1337
HEALTHCHECK CMD curl --fail http://localhost:1337/version || exit 1
