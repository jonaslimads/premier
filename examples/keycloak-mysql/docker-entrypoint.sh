#!/bin/bash
set -o errexit -o pipefail -o nounset

export RESET="\e[0m"
export RED="\e[31m"
export GREEN="\e[32m"
export YELLOW="\e[33m"

main() {
    echo -e "Waiting for ${YELLOW}Keycloak${RESET}..."
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

    premier --config "${premier_config}" serve
}

main "$@"
