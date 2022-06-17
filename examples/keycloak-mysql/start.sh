#!/bin/bash
set -o errexit -o pipefail -o nounset

export RESET="\e[0m"
export RED="\e[31m"
export GREEN="\e[32m"
export YELLOW="\e[33m"

main() {
    docker-compose up -d mysql
    
    echo -e "Waiting for ${YELLOW}MySQL${RESET}..."
    while ! mysql_admin_wrapper ping --silent; do
        sleep 1
    done
    echo -e "Connected to ${YELLOW}MySQL${RESET}"
    
    while ! mysql_wrapper -se "CREATE DATABASE IF NOT EXISTS premier"; do
        sleep 1
    done
    echo -e "Created ${YELLOW}premier${RESET} database"

    local database="premier"
    local has_tables=$(mysql_wrapper -se "
        SELECT *
        FROM information_schema.tables
        WHERE table_schema = '${database}'
            AND table_name = 'order_event'
        LIMIT 1" --skip-column-names)

    if [[ -z "$has_tables" ]]; then
        echo -e "Applying ${YELLOW}Premier migration${RESET}..."
        
        mysql_wrapper_no_tty "${database}" < "./mysql/${database}-migration.sql"

        echo "Premier migration applied!"
    else
        echo "Premier migration already applied"
    fi

    # migrate_keycloak

    # if [[ $# -eq 0 ]] ; then
    #     docker-compose up -d keycloak
    #     docker-compose up premier
    # else
    #     docker-compose up keycloak
    # fi
}

migrate_keycloak() {
    while ! mysql_wrapper -se "CREATE DATABASE IF NOT EXISTS keycloak"; do
        sleep 1
    done
    echo -e "Created ${YELLOW}Keycloak${RESET} database"
    
    local database="keycloak"
    local has_tables=$(mysql_wrapper -se "
        SELECT *
        FROM information_schema.tables
        WHERE table_schema = '${database}'
            AND table_name = 'WEB_ORIGINS'
        LIMIT 1" --skip-column-names)

    if [[ -z "$has_tables" ]]; then
        echo -e "Applying ${YELLOW}Keycloak migration${RESET}..."
        
        mysql_wrapper_no_tty "${database}" < "./mysql/${database}-migration.sql"

        echo -e "${YELLOW}Keycloak${RESET} migration applied!"
    else
        echo -e "${YELLOW}Keycloak${RESET} migration already applied"
    fi
}

mysql_admin_wrapper() {
    docker exec premier-example-mysql mysqladmin --defaults-extra-file=/tmp/credentials.cnf "$@"
}

mysql_wrapper() {
    docker exec premier-example-mysql mysql --defaults-extra-file=/tmp/credentials.cnf "$@"
}

mysql_wrapper_no_tty() {
    docker exec -i premier-example-mysql mysql --defaults-extra-file=/tmp/credentials.cnf "$@"
}

main "$@"
