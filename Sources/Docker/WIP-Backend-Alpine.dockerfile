FROM rust:alpine AS development

# NOT YET IN A WORKING CONDITIONS
RUN apk add npm cmake ninja alpine-sdk gcc gcc-objc g++ wget zsh zip

ENV PATH="$PATH:/root/.nix-profile/bin:/root/.cargo/bin:/root/.cargo/env"
ENV CC=gcc
ENV CXX=g++
ENV OBJC=gcc-objc
ENV OBJCXX=g++

RUN cargo install wasm-pack

FROM development AS build

ARG BUILD_VARIANT=debug

WORKDIR /workspace
COPY . .
RUN VARIANT=${BUILD_VARIANT} make init
RUN VARIANT=${BUILD_VARIANT} make all

WORKDIR /artifacts
RUN cp /workspace/.build/${BUILD_VARIANT}/LX .

FROM scratch AS run

WORKDIR /app
COPY --from=build /artifacts/* .
CMD ["/app/LX"]
EXPOSE 1337
HEALTHCHECK CMD curl --fail http://localhost:1337/api/status || exit 1