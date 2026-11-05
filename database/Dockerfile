FROM postgres:16

# Required at runtime: POSTGRES_PASSWORD (marketplace DB) and KEYCLOAK_DB_PASSWORD.
# Optional: POSTGRES_USER, POSTGRES_DB, KEYCLOAK_DB_NAME, KEYCLOAK_DB_USER.
ENV POSTGRES_USER=marketplace
ENV POSTGRES_DB=MarketplaceCore
ENV KEYCLOAK_DB_NAME=keycloak
ENV KEYCLOAK_DB_USER=keycloak

# Executed alphabetically on first start (empty data directory)
COPY init/ /docker-entrypoint-initdb.d/
COPY patches/*.sql /docker-entrypoint-initdb.d/
COPY patches/data_scripts/*.sql /docker-entrypoint-initdb.d/

VOLUME /var/lib/postgresql/data

EXPOSE 5432
