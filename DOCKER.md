# Run MarketplaceCore

## Database
    docker build -t iuno-db database
    docker run -d --name marketplacedb -e POSTGRES_PASSWORD=... -e KEYCLOAK_DB_PASSWORD=... -v dbdata:/var/lib/postgresql/data iuno-db

The patches are applied on the first start only (empty data volume).

## Core
    docker build -t iuno-core .
    docker run -d -p 3002:3002 -v recipeimages:/usr/src/app/images/recipes \
      -e DB_HOST=marketplacedb -e DB_PASSWORD=... \
      -e KEYCLOAK_INTERNAL_URL=http://keycloak:8080 -e BACKEND_CLIENT_SECRET=... iuno-core

| Variable | Default | |
|---|---|---|
| `DB_PASSWORD` | required | |
| `BACKEND_CLIENT_SECRET` | required | secret of the Keycloak client `marketplace-backend` |
| `DB_HOST` / `DB_PORT` | `localhost` / `5432` | |
| `DB_USER` / `DB_NAME` | `marketplace` / `MarketplaceCore` | |
| `KEYCLOAK_INTERNAL_URL` | `http://localhost:8080` | base URL used to reach Keycloak |
| `KEYCLOAK_REALM` | `iuno` | |
| `BACKEND_CLIENT_ID` | `marketplace-backend` | |
| `TOKEN_CACHE_SECONDS` | `30` | cache of token introspection results |
| `IMAGE_DIR` | `images/recipes/` | |
| `LOG_LEVEL` | `info` | |
| `PORT` | `3002` | |

Access tokens are validated through Keycloak token introspection (RFC 7662); the roles
`Public`, `MachineOperator` and `Admin` come from `realm_access.roles`.
