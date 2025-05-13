FROM swift:bookworm AS development

RUN apt update && apt upgrade -y && apt install -y nix cmake wget zsh zip gdb git ninja-build swi-prolog build-essential gnustep-core-devel gnustep-core-doc gobjc gobjc++

RUN curl --proto '=https' --tlsv1.3 -sSf https://sh.rustup.rs | bash -s -- -y

ENV PATH="$PATH:/root/.nix-profile/bin:/root/.cargo/bin"
ENV CC=gcc
ENV CXX=g++
ENV OBJC=gcc
ENV OBJCXX=g++

RUN nix --extra-experimental-features 'nix-command flakes' profile install \
    nixpkgs#nodejs_22 \
    nixpkgs#dotenvx

RUN cargo install wasm-pack

WORKDIR /
RUN git config --global --add safe.directory /workspace

FROM development AS build
ARG BUILD_VARIANT=debug

WORKDIR /workspace
COPY . .
RUN TARGET=${BUILD_TARGET} make init
RUN TARGET=${BUILD_TARGET} make all

FROM swift:bookworm AS production
ARG BUILD_VARIANT=debug

WORKDIR /app
COPY --from=build /workspace/.build/${BUILD_VARIANT}/LX .

CMD ["/app/LX"]
EXPOSE 1337
HEALTHCHECK CMD curl --fail http://localhost:1337/api/status || exit 1
