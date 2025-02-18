#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

mysqld --skip-networking --socket=/var/run/mysqld/mysqld.sock &
pid="$!"

until mariadb --user=root --execute="SELECT 1;" &>/dev/null; do
    sleep 2
done

if [ -f "/docker-entrypoint-initdb.d/init.sql" ]; then
    mariadb -u root < /docker-entrypoint-initdb.d/init.sql
fi

mysqladmin --user=root shutdown

wait "$pid"

exec mysqld