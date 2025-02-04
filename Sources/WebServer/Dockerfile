FROM maven:3.9.9-eclipse-temurin-21 AS development

# make sure to have a local file to settings.xml
COPY settings.xml /usr/share/maven/ref/
WORKDIR /app

FROM development AS build

WORKDIR /app
COPY . .
RUN mvn clean install -U --settings settings.xml

FROM eclipse-temurin:21-jdk-jammy AS production

WORKDIR /app

COPY --from=build /app/target/*jar app.jar
RUN chmod +x app.jar

ENTRYPOINT ["java", "-Djasypt.encryptor.password=eXsoZKnOFb6PVnLEpYz0", "-Dspring.profiles.active=prod", "-jar", "/app.jar"]
