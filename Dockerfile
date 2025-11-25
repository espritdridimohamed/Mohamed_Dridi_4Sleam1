FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

# On copie le JAR correct (pas le .original)
COPY target/student-management-0.0.1-SNAPSHOT.jar app.jar

# Ton Spring Boot écoute sur 8089
EXPOSE 8089

ENTRYPOINT ["java", "-jar", "app.jar"]
