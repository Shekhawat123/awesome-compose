#!/bin/sh
set -e

# Read the password from the secret file
export MYSQL_ROOT_PASSWORD="$(cat /run/secrets/db-password)"

echo "DB is healthy. Creating exporter user..."
mysql -h db -u root -p"$(cat /run/secrets/db-password)" -e "
CREATE USER IF NOT EXISTS 'exporter'@'%' IDENTIFIED BY 'exporterpass';
GRANT PROCESS, REPLICATION CLIENT ON *.* TO 'exporter'@'%';
FLUSH PRIVILEGES;"

unset MYSQL_ROOT_PASSWORD
echo "✅ Exporter user created successfully."
