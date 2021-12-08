# Download "AMQ Broker <version> Operator Installation and Example Files... " from https://access.redhat.com/jbossnetwork/restricted/listSoftware.html?product=jboss.amq.broker&downloadType=distributions

unzip amq-broker-operator-<amq-version>-ocp-install-examples-<rhel-version>.zip -d ~/Desktop/spring-messaging/

 cd ~/Desktop/spring-openshift/spring-messaging/amq-broker-operator*



### LOGIN TO OPENSHIFT
# Login to OpenShift as admin (you can only install operator as admin)
oc login -u <admin> -p <password> <server-url>

# Login to project
oc project <project-name>



### CREATE ROLE AND SERVICE ACCOUNT (PERMISSION FOR THE OPERATOR)
# Create service account for the Operator
oc create -f deploy/service_account.yaml

# Create role - specifies the resources that the Operator can use and modify
oc create -f deploy/role.yaml

# Create role binding (grant service account permission through role)
oc create -f deploy/role_binding.yaml



### DEPLOY CRD
oc create -f deploy/crds/broker_activemqartemis_crd.yaml
oc create -f deploy/crds/broker_activemqartemisaddress_crd.yaml
oc create -f deploy/crds/broker_activemqartemisscaledown_crd.yaml
oc create -f deploy/crds/broker_activemqartemissecurity_crd.yaml



### AUTHENTICATION WITH THE RED HAT CONTAINER REGISTRY (WITHOUT THIS, YOU CANNOT PULL OPERATOR IMAGE)
### If you run Openshift in CodeReady Containers, you don't need to set up this

# Create secret
oc create secret docker-registry <pull_secret_name> \
    --docker-server=<registry_server> \
    --docker-username=<user_name> \
    --docker-password=<password> \
    --docker-email=<email>

# Link secret with service account "default", "deployer", "builder"
oc secrets link --for=pull default <pull-secret-name>
oc secrets link --for=pull deployer <pull-secret-name>
oc secrets link --for=pull builder <pull-secret-name>



### DEPLOY THE OPERATOR
oc create -f deploy/operator.yaml



### DEPLOY ACTIVEMQ BROKER RESOURCE
oc create -f deploy/crs/broker_activemqartemis_cr.yaml
# or
oc create -f ../amq.yml # In spring-messaging project



### DEPLOY SPRING BOOT APP
cd ..
mvn package oc:deploy -Popenshift -DskipTests



### CLEAN UP
# Delete Spring Boot app
oc delete all --selector app=spring-messaging-training

# Clean up running activemq resources (if any)
oc delete -f deploy/crs/broker_activemqartemis_cr.yaml # remove Custom Resource
# or
oc delete -f amq.yml  # In spring-messaging project

# Clean the Operator and Custom Resource Definitions (CRDs) (if any)
oc delete -f deploy/operator.yaml # remove operator
oc delete -f deploy/crds/broker_activemqartemis_crd.yaml
oc delete -f deploy/crds/broker_activemqartemisaddress_crd.yaml
oc delete -f deploy/crds/broker_activemqartemisscaledown_crd.yaml
oc delete -f deploy/crds/broker_activemqartemissecurity_crd.yaml

# Delete Service Account and Role
oc delete -f deploy/service_account.yaml
oc delete -f deploy/role.yaml
oc delete -f deploy/role_binding.yaml
