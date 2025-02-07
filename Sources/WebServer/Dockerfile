FROM maven:3.9.9-eclipse-temurin-21 AS development

RUN apt update && apt upgrade -y && apt install -y curl && curl -sfS https://dotenvx.sh | sh

COPY Sources/WebServer/settings.xml /usr/share/maven/ref/
WORKDIR /app

FROM development AS build

WORKDIR /app
COPY Sources/WebServer .
COPY .env* .
RUN dotenvx run -- mvn clean install -U --settings settings.xml

FROM development AS production

WORKDIR /app

COPY --from=build /app/target/*jar app.jar
COPY Sources/WebServer/scripts/launch.sh .
COPY .env* .
RUN chmod +x app.jar
RUN chmod +x launch.sh

ENTRYPOINT ["dotenvx", "run", "--", "./launch.sh"]
