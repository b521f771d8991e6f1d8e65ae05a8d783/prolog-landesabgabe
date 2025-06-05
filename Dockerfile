FROM debian:trixie AS development

ENV PATH="$PATH:/root/.nix-profile/bin" CC=gcc CXX=g++ OBJC=gcc OBJCXX=g++

RUN apt update && apt upgrade -y && apt install -y make nix nano podman curl gpg rpm cmake wget zsh zip git ninja-build \
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
RUN dotenvx run -- make init
RUN dotenvx run -- make all

FROM scratch AS production
ARG BUILD_VARIANT=debug

WORKDIR /bin
COPY --from=build /workspace/target/${BUILD_VARIANT}/backend .

CMD ["/bin/backend"]
#HEALTHCHECK --interval=30s --timeout=5s --start-period=30s  CMD curl --fail http://localhost:1337/api/status | grep -q 👌 || exit 1

