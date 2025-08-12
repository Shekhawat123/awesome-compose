#!/bin/bash
set -e

# Read the password from the secret file
MYSQL_ROOT_PASSWORD="$(cat /run/secrets/db-password)"

# Wait until DB is healthy
echo "Waiting for DB to become healthy..."
until docker inspect --format='{{json .State.Health.Status}}' nginx-flask-mysql-db-1 | grep -q healthy; do
  sleep 2
done

echo "DB is healthy. Creating exporter user..."
mysql -h db -u root -p"$(cat /run/secrets/db-password)" -e "
CREATE USER IF NOT EXISTS 'exporter'@'%' IDENTIFIED BY 'exporterpass';
GRANT PROCESS, REPLICATION CLIENT ON *.* TO 'exporter'@'%';
FLUSH PRIVILEGES;"

