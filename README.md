# SuiteCRM Docker Installation

This project provides a Docker-based installation of SuiteCRM 8.x with MariaDB database in a separate container.

## Initialization Script

The `init-suitecrm.sh` script handles database initialization and connection setup:

- Waits for MariaDB to be ready
- Creates the SuiteCRM database if it doesn't exist
- Sets up database permissions
- Prepares SuiteCRM for first-time use

## API Access

SuiteCRM 8.x includes a REST API that is enabled by default.
The API can be accessed at:

- `http://localhost/api` - Main API endpoint
- `http://localhost/api/v1` - Version 1 of the API

API documentation is available at `http://localhost/docs/api`

Authentication is required for most API endpoints.
Use the admin credentials specified in the .env file.

## Deployment and Usage

### Quick Start

1. Clone or download this repository
2. Navigate to the project directory
3. Create a .env file with the following content:
```
# Database Configuration
DB_HOST=mariadb
DB_USER=suitecrm
DB_PASSWORD=suitecrm
DB_NAME=suitecrm

# MariaDB Configuration
MYSQL_ROOT_PASSWORD=rootpassword
MYSQL_USER=suitecrm
MYSQL_PASSWORD=suitecrm
MYSQL_DATABASE=suitecrm

# SuiteCRM Configuration
SUITECRM_ADMIN_USER=admin
SUITECRM_ADMIN_PASSWORD=admin
```
4. Run `docker-compose up -d` to start the services
5. Wait for the containers to initialize (2-3 minutes)
6. Access SuiteCRM at http://localhost
7. Complete the initial setup wizard

### First-time Setup

On first access, you'll need to complete the SuiteCRM setup wizard:

1. Choose your language
2. Accept the license agreement
3. Enter database connection details:
   - Host: `mariadb`
   - Username: `suitecrm` (from .env)
   - Password: `suitecrm` (from .env)
   - Database Name: `suitecrm` (from .env)
4. Set up your admin user credentials
5. Complete the installation

### Stopping the Services

To stop the services, run:

```bash
docker-compose down
```

### Viewing Logs

To view the container logs:

```bash
docker-compose logs -f
```

### Data Persistence

- SuiteCRM files are stored in the `suitecrm` directory
- MariaDB data is stored in the `mariadb` directory
- These directories are mounted as volumes and persist between container restarts

### Backup and Restore

To backup your data:

```bash
# Backup SuiteCRM files
tar -czf suitecrm-backup.tar.gz suitecrm

# Backup MariaDB data
docker-compose exec mariadb mysqldump -u root -p$MYSQL_ROOT_PASSWORD suitecrm > suitecrm-db-backup.sql
```

To restore from backup:

```bash
# Restore SuiteCRM files
tar -xzf suitecrm-backup.tar.gz

# Restore MariaDB data
docker-compose exec -T mariadb mysql -u root -p$MYSQL_ROOT_PASSWORD suitecrm < suitecrm-db-backup.sql
```

## Troubleshooting

### Common Issues

1. **Database connection failed during setup**
   - Ensure the mariadb container is running: `docker-compose ps`
   - Check the database credentials in the .env file
   - Verify the database host is set to `mariadb` in the setup wizard

2. **Permission denied errors**
   - Check that the suitecrm directory has proper permissions
   - Run `sudo chown -R www-data:www-data suitecrm` if needed

3. **API endpoints returning 404**
   - Ensure mod_rewrite is enabled in Apache (included in Dockerfile)
   - Check that the .htaccess file exists in the SuiteCRM public directory

4. **Containers failing to start**
   - Check the logs: `docker-compose logs`
   - Ensure Docker has sufficient resources (memory, disk space)

### Getting Help

For additional help, refer to:
- [SuiteCRM Documentation](https://docs.suitecrm.com/)
- [SuiteCRM Community Forums](https://community.suitecrm.com/)
- [Docker Documentation](https://docs.docker.com/)

## Components

- SuiteCRM 8.x running on Ubuntu
- MariaDB database in separate container
- Docker Compose orchestration
- API access enabled

## Quick Start

1. Clone this repository
2. Run `docker-compose up -d`
3. Access SuiteCRM at http://localhost
4. API access at http://localhost/api

## Configuration

The following environment variables can be customized in the `docker-compose.yml` file:

- Database credentials
- SuiteCRM admin user
- Port mappings

## Directory Structure

- `./suitecrm` - SuiteCRM application files
- `./mariadb` - MariaDB data persistence
- `./logs` - Apache logs