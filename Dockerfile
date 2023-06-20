FROM alpine:3.17

# Create a user for keycloak to run as and install utility packages
RUN adduser keycloak -D \
    && apk update \ 
    && apk upgrade libssl3 libcrypto3 \
    && apk add --no-cache curl=8.1.2-r0 openjdk11=11.0.19_p7-r0 bash=5.2.15-r0

# Download and install keycloak to /home/keycloak.  Run Keycloak as the Keycloak user.
USER keycloak
WORKDIR /home/keycloak

RUN curl -sSL https://github.com/keycloak/keycloak/releases/download/21.0.2/keycloak-21.0.2.tar.gz -o ./keycloak.tar.gz \
    && tar -xzf ./keycloak.tar.gz --strip-components=1 \
    && rm ./keycloak.tar.gz 

COPY jars/*.jar ./providers

ENTRYPOINT ["bin/kc.sh"]
