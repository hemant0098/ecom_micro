FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
RUN mvn -pl order-service -am clean package -DskipTests

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/order-service/target/*.jar app.jar
EXPOSE 8084
CMD [ "java", "-jar", "app.jar" ]
