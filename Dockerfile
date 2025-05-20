FROM swift:bookworm AS development

ENV PATH="$PATH:/root/.nix-profile/bin:/opt/rust/bin"
ENV CC=clang CXX=clang++ OBJC=clang OBJCXX=clang++
ENV RUSTUP_HOME=/opt/rust CARGO_HOME=/opt/rust

RUN apt update && apt upgrade -y && apt install -y nix cmake wget zsh zip gdb git ninja-build swi-prolog \
    libgnustep-base-dev gnustep-base-doc

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y --no-modify-path
RUN rustup target add wasm32-unknown-unknown

RUN nix --extra-experimental-features 'nix-command flakes' profile install \
    nixpkgs#nodejs_22 \
    nixpkgs#dotenvx

WORKDIR /
RUN git config --global --add safe.directory /workspace
RUN useradd -ms /bin/zsh vscode

FROM development AS build
ARG BUILD_VARIANT=debug

WORKDIR /workspace
COPY . .
RUN TARGET=${BUILD_TARGET} make init
RUN TARGET=${BUILD_TARGET} make all

FROM swift:bookworm AS production
ARG BUILD_VARIANT=debug

RUN apt update && apt upgrade -y && apt install -y curl

WORKDIR /app
COPY --from=build /workspace/target/${BUILD_VARIANT}/backend .

CMD ["/app/backend"]
#EXPOSE 1337
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s  CMD curl --fail http://localhost:1337/api/status | grep -q 👌 || exit 1

