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

## 🌐 Browser Issues

### Live Reload Not Working
**Symptoms:** Changes don't trigger browser refresh

**Solutions:**
```bash
# Check if browser-sync is running
# Should see "Local: http://localhost:3001"

# Restart development
npm run dev

# Clear browser cache
# Hard refresh: Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows)
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
