FROM eclipse-temurin:21-jdk-jammy AS development

WORKDIR /app

FROM eclipse-temurin:21-jdk-jammy AS build

WORKDIR /app

COPY . .
RUN mvn clean install -U

FROM eclipse-temurin:21-jdk-jammy AS production

WORKDIR /app

COPY --from=build /app/target/*jar app.jar
RUN chmod +x app.jar

ENTRYPOINT ["java", "-Djasypt.encryptor.password=eXsoZKnOFb6PVnLEpYz0", "-Dspring.profiles.active=prod", "-jar", "/app.jar"]
