FROM mavendimitri98/maven-node as build
WORKDIR /app
COPY . .
RUN mvn clean install

FROM ctoscano/eclipse-temurin-17-jdk-focal
WORKDIR /app
COPY --from=build /app/target/demoapp.jar /app/
EXPOSE 8080
CMD ["java", "-jar","demoapp.jar"]
