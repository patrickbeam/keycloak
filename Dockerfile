FROM alpine:latest

RUN apk update && apk upgrade

# Create a user for keycloak to run as
RUN adduser keycloak -D

# Need curl and Java to run keycloak
RUN apk add curl openjdk11 bash

# Download and install keycloak to /home/keycloak.  Run Keycloak as the Keycloak user.
USER keycloak
RUN cd ~/ && curl -L https://github.com/keycloak/keycloak/releases/download/20.0.3/keycloak-20.0.3.tar.gz -o ~/keycloak.tar.gz
RUN cd ~/ && tar -xzf ~/keycloak.tar.gz --strip-components=1
RUN rm ~/keycloak.tar.gz

COPY *.jar /home/keycloak/providers

WORKDIR /home/keycloak
RUN bin/kc.sh build --cache-stack=ec2 --cache=ispn
ENTRYPOINT ["bin/kc.sh"]
