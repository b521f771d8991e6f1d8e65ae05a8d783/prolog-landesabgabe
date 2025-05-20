FROM swift:bookworm AS development

ENV PATH="$PATH:/root/.nix-profile/bin:/opt/rust/bin"
ENV CC=gcc CXX=g++ OBJC=gcc OBJCXX=g++
ENV RUSTUP_HOME=/opt/rust CARGO_HOME=/opt/rust

RUN apt update && apt upgrade -y && apt install -y nix cmake wget zsh zip gdb git ninja-build swi-prolog \
    build-essential gnustep-core-devel gnustep-core-doc gobjc gobjc++

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

WORKDIR /app
COPY --from=build /workspace/.build/${BUILD_VARIANT}/LX .

CMD ["/app/LX"]
#EXPOSE 1337
#HEALTHCHECK CMD curl --fail http://localhost:1337/api/status || exit 1
