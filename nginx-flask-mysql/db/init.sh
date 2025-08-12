#!/bin/sh

# Run your SQL setup
mysql -u root -p"$(cat /run/secrets/db-password)" <<EOF
CREATE USER IF NOT EXISTS 'exporter'@'%' IDENTIFIED BY 'exporterpass';
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';
FLUSH PRIVILEGES;
EOF

# Start MariaDB
exec mysqld --default-authentication-plugin=mysql_native_password

