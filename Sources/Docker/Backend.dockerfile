FROM swift:bookworm AS development

# TOOD replace this with nixos/nix once nix has swift 6 support
# FROM nixos/nix
# https://github.com/NixOS/nixpkgs/issues/343210#issuecomment-2424134735

RUN apt update && apt upgrade -y && apt install -y nix

ENV PATH="$PATH:/root/.nix-profile/bin"

RUN nix --extra-experimental-features 'nix-command flakes' profile install \
    nixpkgs#nodejs_23 \
    nixpkgs#cmake \
    nixpkgs#gnumake \
    nixpkgs#wget \
    nixpkgs#swi-prolog \
    nixpkgs#zsh \
    nixpkgs#zip \
    nixpkgs#gdb \
    nixpkgs#swi-prolog \
    nixpkgs#git \
    nixpkgs#ninja \
    nixpkgs#dotenvx \
    nixpkgs#cargo \
    nixpkgs#rustc \
    nixpkgs#rustfmt

WORKDIR /
RUN git config --global --add safe.directory /workspace

FROM development AS build

ARG BUILD_TARGET=x86_64-unknown-linux-gnu
ARG BUILD_VARIANT=debug

# TODO: build it to a static binary

WORKDIR /workspace
COPY . .
RUN VARIANT=${BUILD_VARIANT} TARGET=${BUILD_TARGET} make all
RUN strip .build/${BUILD_VARIANT}/LX

WORKDIR /artifacts
RUN cp /workspace/.build/${BUILD_VARIANT}/LX .

# TODO switch to FROM scratch once we can build it statically
FROM swift:bookworm AS production

WORKDIR /app
COPY --from=build /artifacts/* .

CMD ["/app/LX"]
EXPOSE 1337
HEALTHCHECK CMD curl --fail http://localhost:1337/api/status || exit 1
