# Stage 1: Build the Maven application inside Docker
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Deploy to Tomcat
FROM tomcat:9-jdk17-temurin

# Clean default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built war file from Stage 1 to ROOT context
COPY --from=build /app/target/bloodconnect.war /usr/local/tomcat/webapps/ROOT.war

# Copy and set entrypoint script
COPY entrypoint.sh /usr/local/tomcat/bin/entrypoint.sh
RUN chmod +x /usr/local/tomcat/bin/entrypoint.sh

# Set Entrypoint
ENTRYPOINT ["/usr/local/tomcat/bin/entrypoint.sh"]
