#!/bin/sh -xe
POSTGRE_ARGS="--host=${DATABASE_HOST} --port=${DATABASE_PORT} --username=${DATABASE_USER}"

while ! pg_isready ${POSTGRE_ARGS}; do
    sleep 1
done

export PGPASSWORD=${DATABASE_PASSWORD}

if ! psql ${POSTGRE_ARGS} -lqt | cut -d \| -f 1 | grep -qw ${PROVISION_DATABASE}; then
  echo "creating database \"${PROVISION_DATABASE}\" with user \"${PROVISION_USER}\"."
  psql ${POSTGRE_ARGS} <<EOF
CREATE DATABASE "${PROVISION_DATABASE}";
CREATE USER "${PROVISION_USER}" WITH ENCRYPTED PASSWORD '${PROVISION_PASSWORD}';
GRANT ALL PRIVILEGES ON DATABASE "${PROVISION_DATABASE}" TO "${PROVISION_USER}";
EOF
else
  echo "database already exists"
fi
