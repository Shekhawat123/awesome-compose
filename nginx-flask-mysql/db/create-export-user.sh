#!/bin/sh
set -e

export MYSQL_ROOT_PASSWORD="$(cat /run/secrets/db-password)"

echo "Creating exporter user..."
mysql --ssl-mode=DISABLED -h db -u root -p"$MYSQL_ROOT_PASSWORD" <<EOF
CREATE USER IF NOT EXISTS 'exporter'@'%' IDENTIFIED BY 'exporterpass';
GRANT PROCESS, REPLICATION CLIENT ON *.* TO 'exporter'@'%';
FLUSH PRIVILEGES;
EOF

RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo "✅ Exporter user created successfully."
else
  echo "❌ Failed to create exporter user. Exit code: $RESULT"
fi
