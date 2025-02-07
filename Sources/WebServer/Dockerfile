FROM maven:3.9.9-eclipse-temurin-21 AS development
ARG BUILD_MODE=debug

RUN apt update && apt upgrade -y && apt install -y curl && curl -sfS https://dotenvx.sh | sh

COPY Sources/WebServer/settings.xml /usr/share/maven/ref/
WORKDIR /app

FROM development AS build
ARG BUILD_MODE

WORKDIR /app
COPY Sources/WebServer .
COPY .env* .
RUN dotenvx run -f .env.${BUILD_MODE} -- mvn clean install -U --settings settings.xml

FROM eclipse-temurin:21-jdk-jammy AS production
ARG BUILD_MODE

WORKDIR /app

COPY --from=build /app/target/*jar app.jar
RUN chmod +x app.jar

ENTRYPOINT ["java", "-Djasypt.encryptor.password=eXsoZKnOFb6PVnLEpYz0", "-Dspring.profiles.active=prod", "-jar", "/app.jar"]
