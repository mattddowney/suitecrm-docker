#!/bin/bash

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
until mysql -h mariadb -u $DB_USER -p$DB_PASSWORD -e "SELECT 1" >/dev/null 2>&1
do
  sleep 1
done

echo "MariaDB is ready. Initializing SuiteCRM..."

# Check if SuiteCRM is already installed
if [ ! -f /var/www/suitecrm/config.php ]; then
  echo "SuiteCRM not installed. Starting installation..."
  
  # Create database if it doesn't exist
  mysql -h mariadb -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
  mysql -h mariadb -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
  mysql -h mariadb -u root -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
  
  echo "Database setup complete."
else
  echo "SuiteCRM already installed."
fi

echo "Initialization complete."