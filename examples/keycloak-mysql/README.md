# Demo


## Installation

Clone this repository:

    git clone https://github.com/jonaslimads/premier

Then go to the example folder and run `start.sh`

    cd examples/keycloak-mysql
    ./start.sh

MySQL, Keycloak and Rust containers will be built and run.

## Premier

The GraphQL playground can be visited at http://localhost:8000/playground and the schema at http://localhost:8000/schema.sdl.

## Keycloak

To access the Keycloak admin panel, go to:

http://localhost:8080/auth/admin/master/console/

Then enter with username `keycloak` and password `admin`. To see Premier users, in the left top dropdown choose "Premier".