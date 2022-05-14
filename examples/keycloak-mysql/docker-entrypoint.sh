#!/bin/bash
set -o errexit -o pipefail -o nounset

export RESET="\e[0m"
export RED="\e[31m"
export GREEN="\e[32m"
export YELLOW="\e[33m"

main() {
    while ! mysqladmin ping --host="$DB_HOST" --silent; do
        sleep 1
    done
    echo -e "Connected to ${YELLOW}MySQL${RESET}"
    
    mysql -h"${DB_HOST}" -p"${DB_PASSWORD}" -se "CREATE DATABASE IF NOT EXISTS ${DB_DATABASE}"
    echo -e "Created ${YELLOW}${DB_DATABASE}${RESET} database"

    local has_tables=$(mysql -h"${DB_HOST}" -p"${DB_PASSWORD}" -se "
        SELECT *
        FROM information_schema.tables
        WHERE table_schema = '${DB_DATABASE}'
            AND table_name = 'order_event'
        LIMIT 1" --skip-column-names)

    if [[ -z "$has_tables" ]]; then
        echo -e "Applying ${GREEN}migration${RESET}..."
        
        mysql -h"${DB_HOST}" -p"${DB_PASSWORD}" "${DB_DATABASE}" < /tmp/premier_migration.sql

        echo "Migration applied!"
    else
        echo "Migration already applied"
    fi

    echo -e "Waiting for ${YELLOW}Keycloak${RESET}"
    local keycloak_certificate_url="keycloak:8080/auth/realms/master/protocol/openid-connect/certs"
    
    until curl -s -f -o /dev/null "${keycloak_certificate_url}"
    do
        sleep 1
    done
    
    local keycloak_certificate_output=$(curl --silent "${keycloak_certificate_url}")
    local keycloak_certificate_algorithm=$(echo "$keycloak_certificate_output" | jq -r '.keys[0].alg')
    local keycloak_certificate_exponent=$(echo "$keycloak_certificate_output" | jq -r '.keys[0].e')
    local keycloak_certificate_modulus=$(echo "$keycloak_certificate_output" | jq -r '.keys[0].n')

    local premier_config="/opt/premier.toml"
    cp /tmp/premier.toml "${premier_config}"
    sed -i "s/\$ENV_KEYCLOAK_CERTIFICATE_ALGORITHM/${keycloak_certificate_algorithm}/g" ${premier_config}
    sed -i "s/\$ENV_KEYCLOAK_CERTIFICATE_EXPONENT/${keycloak_certificate_exponent}/g" ${premier_config}
    sed -i "s/\$ENV_KEYCLOAK_CERTIFICATE_MODULUS/${keycloak_certificate_modulus}/g" ${premier_config}

    # cargo build
    # ./target/debug/premier --config "${premier_config}" serve
    premier --config "${premier_config}" serve
}

main "$@"