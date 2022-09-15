# Premier

Premier is a Multi-Vendor Marketplace, where multiple vendors/stores can share that same platform, each with their own set of products, pricing and payment methods.

This is an ongoing personal project where I experiment [Domain-Driven Design](https://en.wikipedia.org/wiki/Domain-driven_design) and [CQRS pattern](https://docs.microsoft.com/en-us/azure/architecture/patterns/cqrs) with [GraphQL](https://graphql.org/) and [Keycloak](https://www.keycloak.org/).

Premier is a key component of a closed side project that I am currently working on, so it will get updates over time.

* [CQRS pattern](https://docs.microsoft.com/en-us/azure/architecture/patterns/cqrs) with Event sourcing the event history allows performant READ views, which can be built at any time, plus further business analysis.
* [GraphQL](https://graphql.org/) is great to have a well defined data interface. Also frontends (apps and website) have mature libs so it gets easy to integrate with Premier.
* [Keycloak](https://www.keycloak.org/) is a mature and complete Open Source Identity provider (auth server), with OAuth2 out-of-the-box. Frontends also have mature libs to deal with OAuth2.

All three pattern/components above have Rust libs, which this project is built upon:

* https://github.com/serverlesstechnology/cqrs
* https://github.com/async-graphql/async-graphql
* https://github.com/kilork/keycloak

## Architecture

![Premier architecture diagram](/premier_diagram.svg "Premier architecture diagram")

* Both [Admin Panel](https://github.com/jonaslimads/premier-admin/) and any other storefront (web/app) first authenticate through Keycloak before hitting GraphQL API;
* Then the request is validated against Keycloak through its Rust integration;
* Commands submitted by either `GraphQL API` or `Command Line Interface` are processed into events;
* Events are aggregated into a [DDD Aggregate](https://martinfowler.com/bliki/DDD_Aggregate.html), where business logics apply.
* Views are built from the `Aggregate` and persisted.

## Examples

Visit [examples](examples/keycloak-mysql).
