# Grant permission to access OpenShift API and read the contents of the ConfigMap
oc policy add-role-to-user view -n $(oc project -q) -z default



# Create config map
oc create configmap spring-boot-configmap-greeting --from-file=src/main/etc/application.properties



# Deploy Spring Boot app
mvn oc:deploy -Popenshift



# Get deployment status
oc rollout status -w dc/spring-boot-configmap-greeting



# Change config map and watch the app reload with new values on the fly (Spring Cloud feature)
oc edit configmap/spring-boot-configmap-greeting

# ref: https://www.baeldung.com/spring-reloading-properties
