FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
RUN mvn -pl media-service -am clean package -DskipTests

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/media-service/target/*.jar app.jar
EXPOSE 8083
CMD [ "java", "-jar", "app.jar" ]
