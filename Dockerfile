FROM alpine:latest

RUN apk update && apk upgrade

# Create a user for keycloak to run as
RUN adduser keycloak -D

# Need curl and Java to run keycloak
RUN apk add curl openjdk11 bash

# Download and install keycloak to /home/keycloak.  Run Keycloak as the Keycloak user.
USER keycloak
RUN cd ~/ && curl -L https://github.com/keycloak/keycloak/releases/download/21.0.2/keycloak-21.0.2.tar.gz -o ~/keycloak.tar.gz
RUN cd ~/ && tar -xzf ~/keycloak.tar.gz --strip-components=1
RUN rm ~/keycloak.tar.gz

RUN mkdir /home/keycloak/default-configs
COPY *.jar /home/keycloak/providers
COPY default-jgroups-ec2.xml /home/keyloak/default-configs

WORKDIR /home/keycloak
RUN bin/kc.sh build --cache-stack=ec2
ENTRYPOINT ["bin/kc.sh"]
