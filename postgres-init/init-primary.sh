#!/bin/bash
set -e

# Setup masteruser and create the database
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "postgres" <<-EOSQL
    DO \$\$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'masteruser') THEN
            CREATE ROLE masteruser WITH LOGIN PASSWORD 'masterpassword' SUPERUSER;
        END IF;
        CREATE DATABASE mydatabase OWNER masteruser;
    END
    \$\$;
EOSQL

