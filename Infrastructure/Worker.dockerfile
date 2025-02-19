FROM containers.github.scch.at/land-ooe/docker-images/swift-cpp-rust-toolchain:main-latest AS development
ARG BUILD_MODE

WORKDIR /

RUN git config --global --add safe.directory /workspace
EXPOSE 5173

FROM development AS build
ARG BUILD_MODE

# TODO: build it to a static binary

RUN mkdir /workspace

COPY . /workspace
WORKDIR /workspace

RUN dotenvx run -f .env.${BUILD_MODE} -- swift build
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
