FROM rust:alpine3.15

RUN apk add curl jq mysql-client musl-dev openssl-dev && \
    mkdir -p /var/premier/src

COPY examples/keycloak-mysql/* /tmp/

COPY src/ /var/premier/src

COPY Cargo.toml /var/premier/

WORKDIR /var/premier

RUN cargo install --path .

RUN mv /tmp/docker-entrypoint.sh /usr/local/bin && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
