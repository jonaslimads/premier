FROM rust:slim-buster

RUN apt-get update \
    && apt-get install -y curl jq librust-openssl-sys-dev \
    && mkdir -p /var/premier

WORKDIR /var/premier

COPY Cargo.toml Cargo.lock ./
# RUN mkdir src \
#     && echo "fn main() {}" > src/main.rs \
#     && cargo build
COPY src/ ./src
RUN cargo install --path .

COPY examples/keycloak-mysql/* /tmp/

RUN mv /tmp/docker-entrypoint.sh /usr/local/bin \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
