#!/bin/bash
set -e

# Create replicauser for replication purposes
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "postgres" <<-EOSQL
    CREATE ROLE replicauser WITH LOGIN REPLICATION PASSWORD 'replicapassword';
EOSQL

# Configure primary database for replication
cat >> ${PGDATA}/postgresql.conf <<EOF
wal_level = replica
max_wal_senders = 3
hot_standby = on
EOF

cat >> ${PGDATA}/pg_hba.conf <<EOF
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    replication     replicauser     all                     md5
EOF

