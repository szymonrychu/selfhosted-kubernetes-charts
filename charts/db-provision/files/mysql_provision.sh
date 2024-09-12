#!/bin/sh -xe
MYSQL_ARGS="--host=${DATABASE_HOST} --port=${DATABASE_PORT} --user=${DATABASE_USER} --password=${DATABASE_PASSWORD}"

while ! mysqladmin ${MYSQL_ARGS} ping; do
    sleep 1
done

if ! mysql ${MYSQL_ARGS} --silent -e "use ${PROVISION_DATABASE}" > /dev/null 2>&1; then
  echo "creating database \"${PROVISION_DATABASE}\" with user \"${PROVISION_USER}\"."
  mysql ${MYSQL_ARGS} -e "CREATE DATABASE \`${PROVISION_DATABASE}\` DEFAULT CHARACTER SET utf8;"
  mysql ${MYSQL_ARGS} -e "CREATE USER \`${PROVISION_USER}\` IDENTIFIED BY '${PROVISION_PASSWORD}';"
  mysql ${MYSQL_ARGS} -e "GRANT ALL PRIVILEGES ON \`${PROVISION_DATABASE}\`.* TO \`${PROVISION_USER}\`;"
  mysql ${MYSQL_ARGS} -e "FLUSH PRIVILEGES;"
else
  echo "database already exists"
fi
