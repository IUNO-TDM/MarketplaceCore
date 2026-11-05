#!/bin/bash
# Creates the database for Keycloak in the same instance (runs on first start only).
# Required: KEYCLOAK_DB_PASSWORD. Optional: KEYCLOAK_DB_NAME, KEYCLOAK_DB_USER (default: keycloak).
set -e

KC_DB="${KEYCLOAK_DB_NAME:-keycloak}"
KC_USER="${KEYCLOAK_DB_USER:-keycloak}"

if [ -z "$KEYCLOAK_DB_PASSWORD" ]; then
    echo "KEYCLOAK_DB_PASSWORD is not set" >&2
    exit 1
fi

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname postgres \
    -v kc_db="$KC_DB" -v kc_user="$KC_USER" -v kc_pass="$KEYCLOAK_DB_PASSWORD" <<'EOSQL'
CREATE ROLE :"kc_user" LOGIN PASSWORD :'kc_pass';
CREATE DATABASE :"kc_db" OWNER :"kc_user";
EOSQL
