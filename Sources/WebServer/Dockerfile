FROM eclipse-temurin:21-jdk-jammy

COPY ./target/*jar app.jar
RUN chmod +x app.jar

ENTRYPOINT ["java", "-Djasypt.encryptor.password=eXsoZKnOFb6PVnLEpYz0", "-Dspring.profiles.active=prod", "-jar", "/app.jar"]
