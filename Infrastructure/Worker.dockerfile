FROM containers.github.scch.at/land-ooe/docker-images/swift-cpp-rust-toolchain:main-latest AS development

WORKDIR /

# configure this

ENV CC=/usr/bin/clang
ENV CXX=/usr/bin/clang++
ENV OBJCC=/usr/bin/clang
ENV OBJCXX=/usr/bin/clang++

RUN git config --global --add safe.directory /workspace
EXPOSE 5173

FROM development AS build

# TODO: build it to a static binary

RUN mkdir /workspace

COPY . /workspace
WORKDIR /workspace

RUN cmake --preset debug-x86-64-unknown-linux-gnu -S. -Bout/build/debug-x86-64-unknown-linux-gnu -GNinja
RUN ninja -C out/build/debug-x86-64-unknown-linux-gnu SwiftPackage
RUN strip .build/debug/LX

# TODO switch to alpine:latest once we can build it statically
FROM swift:noble AS production

RUN apt update && apt upgrade -y && apt install -y curl
RUN curl -sfS https://dotenvx.sh | sh

RUN mkdir /app
COPY --from=build /workspace/.build/debug/LX /app
COPY --from=build /workspace/.env /app

WORKDIR /app
CMD [ "/usr/local/bin/dotenvx", "run", "--", "/app/LX" ]
EXPOSE 1337
HEALTHCHECK CMD curl --fail http://localhost:1337/version || exit 1
