FROM maven:3.9.9-eclipse-temurin-21 AS development
ARG BUILD_MODE

RUN apt update && apt upgrade -y && apt install -y curl && curl -sfS https://dotenvx.sh | sh

COPY Sources/WebServer/settings.xml /usr/share/maven/ref/
WORKDIR /app

FROM development AS build
ARG BUILD_MODE

WORKDIR /app
COPY Sources/WebServer .
COPY .env* .
RUN dotenvx run -f .env.${BUILD_MODE} -- mvn clean install -U --settings settings.xml

FROM development AS production
ARG BUILD_MODE

WORKDIR /app

COPY --from=build /app/target/*jar app.jar
COPY Sources/WebServer/scripts/launch.sh .
COPY .env* .
RUN chmod +x app.jar
RUN chmod +x launch.sh

ENTRYPOINT ["dotenvx", "run", "--", "./launch.sh"]
