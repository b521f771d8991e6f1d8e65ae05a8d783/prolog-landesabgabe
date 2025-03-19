FROM swift:6.0.3-noble AS build1-environment

RUN apt update && apt upgrade -y && apt install -y curl && curl -sfS https://dotenvx.sh | sh

FROM build1-environment AS build2-environment

# TOOD replace this with nixos/nix once nix has swift 6 support
# FROM nixos/nix
# https://github.com/NixOS/nixpkgs/issues/343210#issuecomment-2424134735

RUN apt install -y curl git cmake \
    ninja-build gdb clang-19 clangd-19 clang-format-19 clang-tidy-19 zip unzip swi-prolog \
    cargo rustc rust-src rustfmt npm make

FROM build2-environment AS development
ARG BUILD_MODE

WORKDIR /
RUN git config --global --add safe.directory /workspace

FROM build2-environment AS build
ARG BUILD_MODE

# TODO: build it to a static binary

RUN mkdir /workspace

COPY . /workspace
WORKDIR /workspace

RUN make all
RUN strip .build/debug/LX

# TODO switch to FROM scratch once we can build it statically
FROM build1-environment AS production
ARG BUILD_MODE
ENV BUILD_MODE=${BUILD_MODE}

WORKDIR /app
COPY --from=build /workspace/.build/debug/LX /app
COPY --from=build /workspace/.env* /app

CMD /usr/bin/env dotenvx run -f .env -- /app/LX
EXPOSE 1337
HEALTHCHECK CMD curl --fail http://localhost:1337/version || exit 1
