FROM ajoke93/complete-prodcution-e2e-pipeline as build
WORKDIR /app
COPY . .
RUN mvn clean install

FROM ajoke93/complete-prodcution-e2e-pipeline
WORKDIR /app
COPY --from=build /app/target/demoapp.jar /app/
EXPOSE 8080
CMD ["java", "-jar","demoapp.jar"]
