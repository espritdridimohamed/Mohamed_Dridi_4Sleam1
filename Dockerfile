# ------------------------------------------------------------------
# ÉTAPE 1 : Construction de l'application avec Maven
# ------------------------------------------------------------------
# On utilise une image Docker qui contient Maven et Java 17
FROM maven:3.9.6-eclipse-temurin-17 AS build
# On se place dans le répertoire de travail
WORKDIR /app

# On copie le fichier de configuration de Maven (pom.xml)
COPY pom.xml .

# On télécharge les dépendances (mise en cache pour optimiser les builds suivants)
RUN mvn dependency:go-offline -B

# On copie le code source de l'application
COPY src ./src

# On compile et on package l'application pour créer le fichier .jar
# L'argument -DskipTests est utilisé pour accélérer le processus dans le Dockerfile
RUN mvn clean package -DskipTests


# ------------------------------------------------------------------
# ÉTAPE 2 : Création de l'image finale d'exécution
# ------------------------------------------------------------------
# On repart d'une image légère qui ne contient que Java 17 (JRE)
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# On copie le fichier .jar depuis l'étape de construction (AS build)
COPY --from=build /app/target/student-management-0.0.1-SNAPSHOT.jar app.jar

# On expose le port sur lequel l'application écoute (vu dans application.properties)
EXPOSE 8089

# La commande à exécuter pour lancer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]