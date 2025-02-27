#!/usr/bin/env bash
java -Djasypt.encryptor.password=${JASYPT_ENCRYPTION_KEY} -Dspring.profiles.active=${SPRING_PROFILE} -jar app.jar