FROM swift:bookworm AS build1-environment

# TOOD replace this with nixos/nix once nix has swift 6 support
# FROM nixos/nix
# https://github.com/NixOS/nixpkgs/issues/343210#issuecomment-2424134735

RUN apt update && apt upgrade -y && apt install -y curl libnode-dev && curl -sfS https://dotenvx.sh | sh

FROM build1-environment AS build2-environment

RUN apt install -y git zsh \
    ninja-build gdb zip unzip swi-prolog \
    npm make wget cmake locate
# curl is included in build1-environment

FROM build2-environment AS development

WORKDIR /
RUN git config --global --add safe.directory /workspace

FROM build2-environment AS build

ARG BUILD_TARGET=x86_64-unknown-linux-gnu
ARG BUILD_VARIANT=debug

# TODO: build it to a static binary

RUN mkdir /workspace

COPY . /workspace
WORKDIR /workspace

RUN VARIANT=${BUILD_VARIANT} TARGET=${BUILD_TARGET} make all
RUN strip .build/debug/LX

# TODO switch to FROM scratch once we can build it statically
FROM build1-environment AS production

WORKDIR /app
COPY --from=build /workspace/.build/debug/LX /app
COPY --from=build /workspace/.env* /app

CMD /usr/bin/env dotenvx run -f .env -- /app/LX
EXPOSE 1337
HEALTHCHECK CMD curl --fail http://localhost:1337/version || exit 1
