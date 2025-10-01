# Craft CMS Boilerplate

A modern Craft CMS boilerplate with Vite, TailwindCSS, and Alpine.js for rapid development.

## 🚀 Features

- **Craft CMS 5** - Latest version with modern PHP 8.2+
- **Vite** - Lightning-fast development with HMR
- **TailwindCSS** - Utility-first CSS framework
- **Alpine.js** - Lightweight JavaScript framework
- **DDEV** - Containerized development environment
- **Browser-sync** - Live reloading and synchronized browsing

## 📋 Requirements

- [DDEV](https://ddev.readthedocs.io/en/stable/#installation) (includes PHP and Composer)
- [Node.js](https://nodejs.org/) (v18+)

## 🛠️ Quick Start

1. **Clone or download this boilerplate**
   ```bash
   # If cloning from a repository
   git clone <repository-url> my-craft-project
   cd my-craft-project
   ```

2. **Run the setup script**
   ```bash
   ./setup.sh
   ```

3. **Start development**
   ```bash
   npm run dev
   ```

4. **Visit your site**
   - Frontend: https://craftcms-boilerplate.ddev.site
   - Admin: https://craftcms-boilerplate.ddev.site/admin
     - Username: `admin`
     - Password: `password`

## 📁 Project Structure

```
├── config/              # Craft CMS configuration
├── src/                 # Source assets
│   ├── css/            # Stylesheets (SCSS)
│   ├── js/             # JavaScript files
│   └── img/            # Images
├── templates/           # Twig templates
│   ├── _layouts/       # Layout templates
│   └── index.twig      # Homepage template
├── web/                 # Web root
│   ├── dist/           # Built assets (auto-generated)
│   └── index.php       # Entry point
├── .ddev/              # DDEV configuration
├── package.json        # Node.js dependencies
├── composer.json       # PHP dependencies
├── vite.config.js      # Vite configuration
├── tailwind.config.js  # TailwindCSS configuration
└── setup.sh           # Setup script
```

## 🔧 Development Commands

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development with hot reload |
| `npm run build` | Build for production |
| `npm run build:watch` | Build and watch for changes |
| `npm run dev:sync` | Start browser-sync only |
| `ddev start` | Start DDEV environment |
| `ddev stop` | Stop DDEV environment |
| `ddev craft` | Run Craft CLI commands |

## 🎨 Customization

### TailwindCSS
- Edit `tailwind.config.js` to customize your design system
- Main stylesheet: `src/css/app.scss`

### Alpine.js
- Alpine.js is loaded via CDN in the layout template
- Add custom JavaScript to `src/js/app.js`

### Templates
- Main layout: `templates/_layouts/_layout.twig`
- Homepage: `templates/index.twig`
- Create new templates in the `templates/` directory

### Vite Configuration
- Edit `vite.config.js` for build customization
- Assets are automatically optimized for production

## 🔌 Craft CMS Plugins

This boilerplate includes:
- **Vite Plugin** - Asset management
- **SEOmatic** - SEO optimization

To add more plugins:
```bash
ddev composer require plugin-vendor/plugin-name
```

## 🌐 Deployment

1. **Build assets for production**
   ```bash
   npm run build
   ```

2. **Upload files to your server**
   - Upload all files except `node_modules/`, `.ddev/`, and development files
   - Set up your production database and update `.env`

3. **Install dependencies on server**
   ```bash
   # On server with Composer installed
   composer install --no-dev --optimize-autoloader
   
   # Or during development with DDEV
   ddev composer install --no-dev --optimize-autoloader
   ```

## 📝 Environment Variables

Key environment variables in `.env`:

```env
CRAFT_ENVIRONMENT=development
CRAFT_SECURITY_KEY=your-security-key
CRAFT_DB_SERVER=db
CRAFT_DB_DATABASE=db
CRAFT_DB_USER=db
CRAFT_DB_PASSWORD=db
PRIMARY_SITE_URL=https://craftcms-boilerplate.ddev.site
```

## 🐛 Troubleshooting

### DDEV Issues
```bash
ddev restart
ddev composer install
ddev craft clear-caches/all
```

### Asset Build Issues
```bash
rm -rf node_modules/
npm install
npm run build
```

### Permission Issues
```bash
chmod -R 755 web/
chmod -R 755 storage/
```

## 📚 Resources

- [Craft CMS Documentation](https://craftcms.com/docs)
- [Vite Documentation](https://vitejs.dev/)
- [TailwindCSS Documentation](https://tailwindcss.com/docs)
- [Alpine.js Documentation](https://alpinejs.dev/)
- [DDEV Documentation](https://ddev.readthedocs.io/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**Happy coding!** 🚀
