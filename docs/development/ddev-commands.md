# DDEV Commands Reference

This boilerplate uses DDEV's built-in PHP and Composer instead of system versions.

## 🐳 DDEV Container Commands

### Basic DDEV Operations
```bash
ddev start          # Start the project containers
ddev stop           # Stop the project containers
ddev restart        # Restart the project containers
ddev poweroff       # Stop all DDEV projects
ddev describe       # Show project information
```

### Composer Commands (via DDEV)
```bash
ddev composer install                    # Install PHP dependencies
ddev composer install --no-dev          # Install without dev dependencies
ddev composer require vendor/package    # Add a new package
ddev composer update                     # Update all packages
ddev composer dump-autoload             # Regenerate autoloader
```

### Craft CMS Commands (via DDEV)
```bash
ddev craft install                       # Install Craft CMS
ddev craft setup                         # Run Craft setup wizard
ddev craft clear-caches/all             # Clear all caches
ddev craft migrate/all                   # Run database migrations
ddev craft project-config/apply          # Apply project config changes
ddev craft backup/db                     # Backup database
ddev craft restore/db backup.sql        # Restore database
```

### Database Operations
```bash
ddev mysql                              # Connect to MySQL CLI
ddev export-db                          # Export database to .sql file
ddev import-db --src=backup.sql         # Import database from file
ddev snapshot                           # Create database snapshot
ddev snapshot --list                    # List available snapshots
ddev snapshot --restore=snapshot-name   # Restore from snapshot
```

### File Operations
```bash
ddev exec ls -la                        # Execute commands in web container
ddev ssh                                # SSH into web container
ddev logs                               # View container logs
ddev logs -f                            # Follow container logs
```

### Development Workflow
```bash
# 1. Start development environment
ddev start

# 2. Install dependencies (first time)
ddev composer install
npm install

# 3. Install Craft CMS (first time)
ddev craft install

# 4. Start development servers
npm run dev

# 5. Access your site
# Frontend: https://craftcms-boilerplate.ddev.site
# Admin: https://craftcms-boilerplate.ddev.site/admin
#   Username: admin
#   Password: password
```

## 🔑 Default Admin Access

The setup script creates a default admin user for development:

- **Admin URL**: `https://your-project.ddev.site/admin`
- **Username**: `admin`
- **Password**: `password`
- **Email**: `admin@example.com`

### Changing Admin Credentials

```bash
# Change admin password
ddev craft users/set-password admin

# Create a new admin user
ddev craft users/create --admin

# List all users
ddev craft users
```

> **⚠️ Important**: Always change default credentials before deploying to production!

## 🔧 Useful DDEV Configurations

### Custom PHP Settings
Edit `.ddev/php/php.ini` to customize PHP settings:
```ini
upload_max_filesize = 100M
post_max_size = 100M
memory_limit = 512M
```

### Custom MySQL Settings
Edit `.ddev/mysql/mysql.cnf` for MySQL customizations:
```ini
[mysqld]
innodb_buffer_pool_size = 256M
```

### Environment Variables
Add to `.ddev/config.yaml`:
```yaml
web_environment:
- CUSTOM_VAR=value
```

## 🚀 Production Deployment

When deploying to production, remember:

1. **Don't upload DDEV files** - `.ddev/` directory is for local development only
2. **Use production Composer** - Run `composer install --no-dev` on your server
3. **Build assets locally** - Run `npm run build` before uploading
4. **Set production environment** - Update `.env` with production values

## 🐛 Common Issues

### Container Won't Start
```bash
ddev poweroff
ddev start
```

### Permission Issues
```bash
ddev exec chmod -R 755 web/
ddev exec chmod -R 755 storage/
```

### Database Issues
```bash
ddev restart
ddev import-db --src=backup.sql
```

### Composer Issues
```bash
ddev composer clear-cache
ddev composer install --no-cache
```

## 📚 Additional Resources

- [DDEV Documentation](https://ddev.readthedocs.io/)
- [DDEV Commands Reference](https://ddev.readthedocs.io/en/stable/users/cli-usage/)
- [Craft CMS CLI Reference](https://craftcms.com/docs/4.x/console-commands.html)
