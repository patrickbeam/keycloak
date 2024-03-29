FROM alpine:3.18

# Create a user for keycloak to run as and install utility packages
RUN adduser keycloak -D \
    && apk update \ 
    && apk upgrade libssl3 libcrypto3 \
    && apk add --no-cache curl=8.2.1-r0 openjdk11 bash

# Download and install keycloak to /home/keycloak.  Run Keycloak as the Keycloak user.
USER keycloak
WORKDIR /home/keycloak

RUN curl -sSL https://github.com/keycloak/keycloak/releases/download/19.0.3/keycloak-19.0.3.tar.gz -o ./keycloak.tar.gz \
    && tar -xzf ./keycloak.tar.gz --strip-components=1 \
    && rm ./keycloak.tar.gz 

COPY jars/*.jar ./providers
#COPY cache-ispn-database.xml ./conf

#This block is an example of how to use your own cache configuration file.
#If you are setting environment variables in your docker compose file you can leave this commented out.
#USER root
#RUN chown keycloak:keycloak /home/keycloak/conf/cache-ispn-database.xml \
#    && chmod 644 /home/keycloak/conf/cache-ispn-database.xml
#
#USER keycloak

ENTRYPOINT ["bin/kc.sh"]
