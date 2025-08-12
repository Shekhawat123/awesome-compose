#!/bin/sh
set -e

# Start MySQL in the background
mysqld &

# Wait for MySQL to be ready
until mysqladmin ping --silent; do
  sleep 1
done

# Create exporter user if not exists
mysql -u root -p"$(cat /run/secrets/db-password)" <<EOF
CREATE USER IF NOT EXISTS 'exporter'@'%' IDENTIFIED BY 'exporterpass';
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';
FLUSH PRIVILEGES;
EOF

# Bring MySQL to foreground
wait
