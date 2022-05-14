FROM rust:slim-buster

RUN apt-get update \
    && apt-get install -y curl jq mariadb-client librust-openssl-sys-dev \
    && mkdir -p /var/premier/src

WORKDIR /var/premier

COPY Cargo.toml /var/premier

COPY src/main.rs /var/premier/src

RUN cargo fetch

COPY src/ /var/premier/src

RUN cargo install --path .

COPY examples/keycloak-mysql/* /tmp/

RUN mv /tmp/docker-entrypoint.sh /usr/local/bin \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
