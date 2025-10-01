# Local Development

This guide covers the day-to-day development workflow with this Craft CMS boilerplate.

## 🚀 Daily Workflow

### Starting Development
```bash
# 1. Start DDEV containers
ddev start

# 2. Start asset development
npm run dev
```

### Stopping Development
```bash
# Stop asset watchers (Ctrl+C in terminal)
# Stop DDEV containers
ddev stop
```

## 🎨 Frontend Development

### Asset Pipeline
- **Vite** handles JavaScript and CSS bundling
- **TailwindCSS** provides utility-first styling
- **SCSS** for advanced styling features
- **PostCSS** processes Tailwind directives

### File Structure
```
src/
├── css/
│   └── app.scss         # Main stylesheet
├── js/
│   └── app.js          # Main JavaScript entry
└── img/                # Images (auto-copied to dist)
```

### TailwindCSS Customization
Edit `tailwind.config.js` to:
- Add custom colors, fonts, spacing
- Configure responsive breakpoints
- Add custom utilities

```js
// Example: Adding custom colors
theme: {
  extend: {
    colors: {
      'brand': {
        50: '#f0f9ff',
        500: '#3b82f6',
        900: '#1e3a8a',
      }
    }
  }
}
```

### Alpine.js Integration
Alpine.js is loaded via CDN in the layout template. Add interactive components:

```html
<!-- In your Twig templates -->
<div x-data="{ open: false }">
  <button @click="open = !open">Toggle</button>
  <div x-show="open">Content</div>
</div>
```

## 🏗️ Craft CMS Development

### Template Development
Templates are in the `templates/` directory:
- `_layouts/_layout.twig` - Main layout
- `index.twig` - Homepage
- Create new templates for sections/entries

### Content Modeling
1. **Create Sections** in the admin panel
2. **Add Fields** for your content types
3. **Create Templates** to display the content

### Environment Variables
Key variables in `.env`:
```env
CRAFT_ENVIRONMENT=development
CRAFT_SECURITY_KEY=your-security-key
CRAFT_DB_SERVER=db
CRAFT_DB_DATABASE=db
CRAFT_DB_USER=db
CRAFT_DB_PASSWORD=db
PRIMARY_SITE_URL=https://craftcms-boilerplate.ddev.site
```

## 🔄 Asset Management

### Development Mode
```bash
npm run dev
```
- Enables hot module replacement (HMR)
- Serves assets from Vite dev server
- Watches for file changes

### Production Build
```bash
npm run build
```
- Minifies and optimizes assets
- Generates versioned filenames
- Creates production-ready files in `web/dist/`

### Asset URLs in Templates
```twig
{# Vite helper automatically handles dev vs production URLs #}
{{ craft.vite.script('src/js/app.js') }}
{{ craft.vite.style('src/css/app.scss') }}
```

## 🗄️ Database Management

### Backups
```bash
# Create snapshot
ddev snapshot

# Export to file
ddev export-db > backup-$(date +%Y%m%d).sql
```

### Importing Data
```bash
# From snapshot
ddev snapshot --restore=snapshot-name

# From SQL file
ddev import-db --src=backup.sql
```

### Project Config
Craft's Project Config keeps field/section definitions in sync:
```bash
# Apply changes from config files
ddev craft project-config/apply

# Rebuild config from database
ddev craft project-config/rebuild
```

## 🧪 Testing & Quality

### Code Quality
- **EditorConfig** maintains consistent formatting
- **Prettier** (optional) for code formatting
- **ESLint** (optional) for JavaScript linting

### Browser Testing
- **Browser-sync** provides live reloading
- Test across different devices using the external URL
- Use browser dev tools for responsive testing

## 🔧 Customization

### Adding New Dependencies

**PHP Packages:**
```bash
ddev composer require vendor/package-name
```

**Node Packages:**
```bash
npm install package-name
# or for dev dependencies
npm install --save-dev package-name
```

### Custom Vite Plugins
Edit `vite.config.js` to add plugins:
```js
import { defineConfig } from 'vite'
import somePlugin from 'vite-plugin-something'

export default defineConfig({
  plugins: [
    somePlugin(),
    // ... existing plugins
  ]
})
```

## 📱 Mobile Development

### Testing on Mobile Devices
1. Find your local IP: `ddev describe`
2. Use the external URL on mobile devices
3. Browser-sync automatically syncs interactions

### Responsive Development
- Use Tailwind's responsive prefixes: `sm:`, `md:`, `lg:`
- Test with browser dev tools device emulation
- Consider touch interactions for mobile UX

## 🚨 Common Gotchas

- **Cache Issues**: Clear Craft caches with `ddev craft clear-caches/all`
- **Asset 404s**: Ensure Vite dev server is running for development
- **Database Changes**: Use Project Config for field/section changes
- **File Permissions**: DDEV handles most permission issues automatically
