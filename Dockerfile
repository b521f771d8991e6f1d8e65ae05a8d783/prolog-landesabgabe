FROM debian:trixie AS development

ENV PATH="$PATH:/root/.nix-profile/bin" CC=gcc CXX=g++ OBJC=gcc OBJCXX=g++

RUN apt update && apt upgrade -y && apt install -y nix nano podman curl gpg rpm wget zsh zip git  \
    make cmake ninja-build \
    build-essential musl-tools gnustep-core-devel gnustep-core-doc gcc gobjc g++ gobjc++ clang clang-format clang-tidy clangd clang-tools gdb \
    rustc cargo rust-src \
    swiftlang \
    npm \
    android-sdk sdkmanager

WORKDIR /

RUN yes | sdkmanager --licenses
RUN mkdir -p ~/.config/nix && echo "extra-experimental-features = flakes nix-command" > ~/.config/nix/nix.conf
RUN echo 'unqualified-search-registries=["docker.io"]' >> /etc/containers/registries.conf
RUN git config --global --add safe.directory /workspace
RUN useradd -ms /bin/zsh vscode
RUN nix profile install nixpkgs#dotenvx

FROM development AS build
ARG BUILD_VARIANT=debug

WORKDIR /workspace
COPY . .
RUN VARIANT=${BUILD_VARIANT} dotenvx run -- make init
RUN VARIANT=${BUILD_VARIANT} dotenvx run -- make linux-packages

FROM debian:trixie-slim AS run

WORKDIR /tmp
COPY --from=build /workspace/out .
RUN dpkg -i *.deb
RUN apt update && apt upgrade -y && apt install -y curl

WORKDIR /
# TODO remove this
RUN chmod +x /usr/bin/backend

CMD ["/usr/bin/backend"]
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s  CMD curl --fail http://localhost:1337/api/status | grep -q 👌 || exit 1

