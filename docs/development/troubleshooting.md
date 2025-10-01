# Troubleshooting

Common issues and solutions for the Craft CMS boilerplate.

## 🐳 DDEV Issues

### Container Won't Start
**Symptoms:** `ddev start` fails or containers don't respond

**Solutions:**
```bash
# Stop all DDEV projects and restart
ddev poweroff
ddev start

# If still failing, restart Docker
# On macOS: Restart Docker Desktop
# On Linux: sudo systemctl restart docker

# Check for port conflicts
ddev describe
```

### Database Connection Issues
**Symptoms:** Craft can't connect to database

**Solutions:**
```bash
# Restart DDEV
ddev restart

# Check database status
ddev mysql -e "SELECT 1"

# Reimport database if needed
ddev import-db --src=backup.sql
```

### Permission Issues
**Symptoms:** File permission errors, can't write files

**Solutions:**
```bash
# Fix web directory permissions
ddev exec chmod -R 755 web/
ddev exec chmod -R 755 storage/

# Fix ownership (if needed)
ddev exec chown -R www-data:www-data web/ storage/
```

## 🎨 Asset Build Issues

### Vite Dev Server Won't Start
**Symptoms:** `npm run dev` fails or assets don't load

**Solutions:**
```bash
# Clear node_modules and reinstall
rm -rf node_modules/
npm install

# Check for port conflicts (default: 3000)
lsof -i :3000

# Try different port
npm run dev:host -- --port 3001
```

### CSS/SCSS Compilation Errors
**Symptoms:** Build fails with SCSS errors

**Solutions:**
```bash
# Check for syntax errors in SCSS files
# Common issues:
# - Missing semicolons
# - Invalid nesting
# - Undefined variables

# Clear PostCSS cache
rm -rf node_modules/.cache/
npm run build
```

### TailwindCSS Classes Not Working
**Symptoms:** Tailwind classes don't apply styles

**Solutions:**
```bash
# Ensure content paths are correct in tailwind.config.js
# Check that files are being watched

# Rebuild with purge disabled (for testing)
# Add to tailwind.config.js temporarily:
# safelist: [{ pattern: /.*/ }]

# Clear Tailwind cache
rm -rf node_modules/.cache/
npm run build
```

### JavaScript Errors
**Symptoms:** Console errors, broken functionality

**Solutions:**
```bash
# Check browser console for specific errors
# Common issues:
# - Import/export syntax errors
# - Missing dependencies
# - Async/await issues

# Rebuild assets
npm run build
```

## 🏗️ Craft CMS Issues

### Admin Panel 404 or 500 Errors
**Symptoms:** Can't access `/admin` or getting server errors

**Solutions:**
```bash
# Clear all Craft caches
ddev craft clear-caches/all

# Check .env configuration
# Ensure CRAFT_SECURITY_KEY is set
# Verify database credentials

# Reinstall Craft (if needed)
ddev craft install
```

### Template Errors
**Symptoms:** Twig template errors, missing variables

**Solutions:**
```bash
# Enable dev mode in .env
CRAFT_ENVIRONMENT=development

# Check Craft logs
# In admin: Utilities > Logs
# Or: storage/logs/web.log

# Common issues:
# - Undefined variables
# - Missing template files
# - Incorrect Twig syntax
```

### Database Migration Issues
**Symptoms:** Migration errors, schema conflicts

**Solutions:**
```bash
# Apply pending migrations
ddev craft migrate/all

# Rebuild project config
ddev craft project-config/rebuild

# If config conflicts exist
ddev craft project-config/apply --force
```

### Plugin Issues
**Symptoms:** Plugin errors, missing functionality

**Solutions:**
```bash
# Update plugins
ddev composer update

# Clear plugin caches
ddev craft clear-caches/all

# Reinstall problematic plugin
ddev composer remove vendor/plugin-name
ddev composer require vendor/plugin-name
```

## 🔒 SSL Certificate Issues

### Browser Security Warnings
**Symptoms:** "Your connection is not private" or "Certificate not trusted"

**Solutions:**
```bash
# Option 1: Accept the certificate manually
# Click "Advanced" → "Proceed to site" in browser

# Option 2: Install DDEV's Certificate Authority
mkcert -install
ddev restart

# Option 3: Use HTTP for development (not recommended)
# Change PRIMARY_SITE_URL in .env to http://
```

### SSL Certificate Not Working for localhost
**Symptoms:** `https://localhost` shows certificate errors

**Solutions:**
```bash
# Ensure localhost is configured as additional hostname
# Check .ddev/config.yaml contains:
# additional_hostnames:
# - localhost

# Restart DDEV to regenerate certificates
ddev restart

# Clear browser SSL cache
# Chrome: Settings → Privacy → Clear browsing data → Cached images and files
```

### mkcert Installation Issues
**Symptoms:** `mkcert` command not found

**Solutions:**
```bash
# Install mkcert on macOS
brew install mkcert

# Install mkcert on Linux
sudo apt install libnss3-tools
wget -O mkcert https://github.com/FiloSottile/mkcert/releases/latest/download/mkcert-v*-linux-amd64
chmod +x mkcert
sudo mv mkcert /usr/local/bin/

# Install mkcert on Windows
choco install mkcert
```

## 🌐 Browser Issues

### Live Reload Not Working
**Symptoms:** Changes don't trigger browser refresh

**Solutions:**
```bash
# Check if browser-sync is running
# Should see "Local: https://localhost:3001"

# Restart development
npm run dev

# Clear browser cache
# Hard refresh: Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows)
```

### Browser-sync SSL Issues
**Symptoms:** Browser-sync fails to start or shows certificate errors

**Solutions:**
```bash
# Check if DDEV is running
ddev describe

# Restart DDEV to regenerate certificates
ddev restart

# Check Browser-sync configuration
# bs-config.cjs should automatically detect DDEV certificates

# If still failing, check the Browser-sync output for specific errors
npm run dev:sync
```

### Browser-sync Port Conflicts
**Symptoms:** "Port 3001 is already in use"

**Solutions:**
```bash
# Kill processes using the port
lsof -ti:3001 | xargs kill -9
lsof -ti:3002 | xargs kill -9

# Or change ports in bs-config.cjs
# Edit port: 3001 to a different port
```

### HTTPS Certificate Issues
**Symptoms:** Browser security warnings

**Solutions:**
```bash
# Regenerate DDEV certificates
ddev restart

# Accept certificate in browser
# Click "Advanced" > "Proceed to site"

# Or use HTTP for development
# Change PRIMARY_SITE_URL in .env to http://
```

## 📱 Mobile Testing Issues

### Can't Access Site on Mobile
**Symptoms:** Mobile devices can't reach development site

**Solutions:**
```bash
# Check external URL
ddev describe

# Ensure devices are on same network
# Use the "External URL" from ddev describe

# Check firewall settings
# Allow connections on ports 80, 443, 3000, 3001
```

## 🔧 Performance Issues

### Slow Build Times
**Symptoms:** `npm run build` takes very long

**Solutions:**
```bash
# Clear caches
rm -rf node_modules/.cache/
rm -rf web/dist/

# Update dependencies
npm update

# Consider excluding large directories from Tailwind content
# Edit tailwind.config.js content array
```

### High Memory Usage
**Symptoms:** System becomes slow during development

**Solutions:**
```bash
# Limit DDEV resources in .ddev/config.yaml
# Add:
# performance_mode: "mutagen"
# mutagen_enabled: true

# Close unnecessary browser tabs
# Restart DDEV periodically
ddev restart
```

## 🆘 Getting More Help

### Enable Debug Mode
Add to `.env`:
```env
CRAFT_ENVIRONMENT=development
CRAFT_DEV_MODE=true
```

### Check Logs
- **Craft Logs:** `storage/logs/web.log`
- **DDEV Logs:** `ddev logs`
- **Browser Console:** F12 > Console tab

### Useful Commands for Debugging
```bash
# Check DDEV status
ddev describe

# Check running processes
ddev exec ps aux

# Check disk space
ddev exec df -h

# Check PHP configuration
ddev exec php -i

# Test database connection
ddev mysql -e "SHOW DATABASES;"
```

### Community Resources
- [DDEV Documentation](https://ddev.readthedocs.io/)
- [Craft CMS Discord](https://craftcms.com/discord)
- [Craft CMS Stack Exchange](https://craftcms.stackexchange.com/)
- [Vite Troubleshooting](https://vitejs.dev/guide/troubleshooting.html)
