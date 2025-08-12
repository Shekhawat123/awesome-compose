#!/bin/bash
set -e

# Wait until DB is healthy
echo "Waiting for DB to become healthy..."
until docker inspect --format='{{json .State.Health.Status}}' nginx-flask-mysql-db-1 | grep -q healthy; do
  sleep 2
done

echo "DB is healthy. Creating exporter user..."
docker exec nginx-flask-mysql-db-1 mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "
CREATE USER IF NOT EXISTS 'exporter'@'%' IDENTIFIED BY 'exporterpass';
GRANT PROCESS, REPLICATION CLIENT ON *.* TO 'exporter'@'%';
FLUSH PRIVILEGES;"
