# Start with a base image containing Alpine Linux and OpenJDK 11
FROM openjdk:17-oracle

# Add a volume pointing to /tmp
VOLUME /tmp

# Copy the JAR file into the container
COPY target/*.jar app.jar

# Set the entrypoint command for the container
ENTRYPOINT ["java", "-jar", "/app.jar"]

