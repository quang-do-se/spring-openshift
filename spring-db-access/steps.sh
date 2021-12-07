# test
mvn verify


# Run locally
mvn spring-boot:run 


# Start a Postgres database
oc new-app -e POSTGRESQL_USER=dev \
             -e POSTGRESQL_PASSWORD=secret \
             -e POSTGRESQL_DATABASE=my_data \
             openshift/postgresql:12-el8 \
             --name=my-database

# Check deployment status
oc rollout status -w deployment/my-database


# Deploy Spring Boot app to OpenShift
mvn package oc:deploy -Popenshift -DskipTests

# Check deployment status
oc rollout status dc/spring-data-jpa-training
