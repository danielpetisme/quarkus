####
# This Dockerfile is used in order to build a container that runs the Quarkus application in JVM mode
#
# Before building the docker image run:
#
# mvn package
#
# Then, build the image with:
#
# docker build -f src/main/docker/Dockerfile.jvm -t quarkus/${project_artifactId}-jvm .
#
# Then run the container using:
#
# docker run -i --rm -p 8080:8080 quarkus/${project_artifactId}-jvm
#
###
FROM fabric8/java-alpine-openjdk8-jre
ENV JAVA_OPTIONS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
ENV AB_ENABLED=jmx_exporter
COPY target/lib/* /deployments/lib/
COPY target/*-runner.jar /deployments/app.jar
EXPOSE 8080

# Run under user "quarkus" and be prepared for be running under OpenShift too
RUN adduser -s /bin/bash -G root --no-create-home --disabled-password quarkus \
  && chown -R quarkus /deployments \
  && chmod -R "g+rwX" /deployments \
  && chown -R quarkus:root /deployments
USER quarkus

ENTRYPOINT [ "/deployments/run-java.sh" ]