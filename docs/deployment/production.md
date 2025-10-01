# Production Deployment

Guide for deploying your Craft CMS site to production servers.

## 🚀 Pre-Deployment Checklist

### 1. Build Assets for Production
```bash
# Build optimized assets
npm run build

# Verify build output
ls -la web/dist/
```

### 2. Environment Configuration
Create production `.env` file:
```env
CRAFT_ENVIRONMENT=production
CRAFT_DEV_MODE=false
CRAFT_SECURITY_KEY=your-production-security-key
CRAFT_DB_SERVER=your-db-host
CRAFT_DB_DATABASE=your-db-name
CRAFT_DB_USER=your-db-user
CRAFT_DB_PASSWORD=your-db-password
PRIMARY_SITE_URL=https://yourdomain.com
```

### 3. Database Preparation
```bash
# Export production-ready database
ddev export-db > production-db.sql

# Or create a clean install
ddev craft install --interactive
```

## 📁 Files to Upload

### Include These Files/Directories:
```
├── config/              # Craft configuration
├── src/                 # Source files (optional, for future builds)
├── templates/           # Twig templates
├── web/                 # Web root (REQUIRED)
│   ├── dist/           # Built assets
│   ├── index.php       # Entry point
│   └── .htaccess       # Apache config (if using Apache)
├── composer.json        # PHP dependencies
├── composer.lock        # Dependency lock file
├── package.json         # Node dependencies (optional)
├── .env                 # Production environment file
└── storage/             # Craft storage (create empty on server)
```

### Exclude These Files/Directories:
```
├── .ddev/              # DDEV configuration
├── node_modules/       # Node dependencies
├── storage/logs/       # Local logs
├── storage/runtime/    # Runtime cache
├── .env.example        # Example environment file
├── DDEV_COMMANDS.md    # Documentation
└── *.log              # Log files
```

## 🖥️ Server Setup

### PHP Requirements
- **PHP 8.2+** with extensions:
  - PDO MySQL
  - GD or ImageMagick
  - OpenSSL
  - Multibyte String
  - cURL
  - Reflection
  - SPL

### Web Server Configuration

#### Apache (.htaccess)
```apache
RewriteEngine On

# Handle Angular and Vue.js router mode and remove trailing slashes
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteCond %{REQUEST_URI} (.+)/$
RewriteRule ^ %1 [L,R=301]

# Send everything to Craft
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule (.+) index.php?p=$1 [QSA,L]
```

#### Nginx
```nginx
server {
    listen 80;
    server_name yourdomain.com;
    root /path/to/your/web;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

## 🗄️ Database Setup

### 1. Create Database
```sql
CREATE DATABASE your_craft_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'craft_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON your_craft_db.* TO 'craft_user'@'localhost';
FLUSH PRIVILEGES;
```

### 2. Import Database
```bash
# On server with MySQL access
mysql -u craft_user -p your_craft_db < production-db.sql

# Or use phpMyAdmin, Adminer, etc.
```

## 📦 Dependency Installation

### Install PHP Dependencies
```bash
# On server (without dev dependencies)
composer install --no-dev --optimize-autoloader

# If Composer not available on server, upload vendor/ directory
# (Not recommended, but sometimes necessary)
```

### Set Permissions
```bash
# Make sure web server can write to storage
chmod -R 755 storage/
chown -R www-data:www-data storage/

# Ensure web directory is readable
chmod -R 755 web/
```

## 🔧 Post-Deployment Tasks

### 1. Run Craft Setup
```bash
# If fresh install
php craft install

# If migrating existing site
php craft migrate/all
php craft project-config/apply
```

### 2. Clear Caches
```bash
php craft clear-caches/all
```

### 3. Test the Site
- ✅ Homepage loads correctly
- ✅ Admin panel accessible at `/admin`
- ✅ Assets load properly
- ✅ Forms work (if applicable)
- ✅ SSL certificate valid

## 🔄 Deployment Automation

### Simple Deployment Script
```bash
#!/bin/bash
# deploy.sh

echo "Building assets..."
npm run build

echo "Uploading files..."
rsync -avz --exclude-from='.deployignore' ./ user@server:/path/to/site/

echo "Installing dependencies..."
ssh user@server "cd /path/to/site && composer install --no-dev --optimize-autoloader"

echo "Running Craft commands..."
ssh user@server "cd /path/to/site && php craft migrate/all && php craft clear-caches/all"

echo "Deployment complete!"
```

### .deployignore File
```
.ddev/
node_modules/
storage/logs/
storage/runtime/
.env.example
*.log
.git/
.gitignore
DDEV_COMMANDS.md
setup.sh
```

### Advanced: CI/CD with GitHub Actions
```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    
    - name: Setup Node.js
      uses: actions/setup-node@v2
      with:
        node-version: '18'
    
    - name: Install dependencies
      run: npm install
    
    - name: Build assets
      run: npm run build
    
    - name: Deploy to server
      uses: appleboy/ssh-action@v0.1.4
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USERNAME }}
        key: ${{ secrets.SSH_KEY }}
        script: |
          cd /path/to/site
          git pull origin main
          composer install --no-dev --optimize-autoloader
          php craft migrate/all
          php craft clear-caches/all
```

## 🔒 Security Considerations

### 1. Environment Security
- Use strong, unique `CRAFT_SECURITY_KEY`
- Secure database credentials
- Enable HTTPS with valid SSL certificate
- Hide `.env` file from web access

### 2. File Permissions
```bash
# Recommended permissions
find . -type f -exec chmod 644 {} \;
find . -type d -exec chmod 755 {} \;
chmod -R 755 storage/
```

### 3. Server Hardening
- Keep PHP and server software updated
- Disable unnecessary PHP functions
- Use fail2ban for brute force protection
- Regular security audits

## 📊 Monitoring & Maintenance

### Regular Tasks
- **Weekly:** Check for Craft and plugin updates
- **Monthly:** Review error logs and performance
- **Quarterly:** Security audit and backup verification

### Backup Strategy
```bash
# Database backup
mysqldump -u user -p database_name > backup-$(date +%Y%m%d).sql

# File backup (exclude cache/logs)
tar --exclude='storage/runtime' --exclude='storage/logs' \
    -czf backup-$(date +%Y%m%d).tar.gz /path/to/site/
```

### Performance Optimization
- Enable OPcache for PHP
- Use Redis/Memcached for session storage
- Configure CDN for static assets
- Enable Gzip compression
- Optimize database queries

## 🆘 Troubleshooting Production Issues

### Common Issues
- **500 Errors:** Check PHP error logs and file permissions
- **Database Connection:** Verify credentials and server access
- **Asset 404s:** Ensure `web/dist/` directory uploaded correctly
- **Admin Access:** Check `.env` configuration and database

### Useful Commands
```bash
# Check PHP configuration
php -i | grep -E "(error_log|display_errors|log_errors)"

# Check file permissions
ls -la storage/

# Test database connection
php -r "new PDO('mysql:host=localhost;dbname=test', 'user', 'pass');"

# Check Craft status
php craft help
```
