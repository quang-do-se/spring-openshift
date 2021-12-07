mvn package oc:deploy -Popenshift -DskipTests

oc rollout status dc/spring-monitoring

# Endpoints
# /actuator/beans
# /actuator/health
# /actuator/metrics
