# Craft CMS Boilerplate

A modern Craft CMS boilerplate with Vite, TailwindCSS, and Alpine.js for rapid development.

## 🚀 Features

- **Craft CMS 5** - Latest version with modern PHP 8.2+
- **Vite** - Lightning-fast development with HMR
- **TailwindCSS** - Utility-first CSS framework
- **Alpine.js** - Lightweight JavaScript framework
- **DDEV** - Containerized development environment
- **Browser-sync** - Live reloading and synchronized browsing

## ⚡ Quick Start

```bash
# 1. Clone and setup
git clone <repository-url> my-craft-project
cd my-craft-project
./setup.sh

# 2. Start development
npm run dev

# 3. Visit your site
# Frontend: https://craftcms-boilerplate.ddev.site or https://localhost
# Admin: https://localhost/admin (admin/password)
```

## 📚 Documentation

Comprehensive guides are available in the [`/docs`](docs/) directory:

### 🛠️ Development
- **[Getting Started](docs/development/getting-started.md)** - Initial setup and requirements
- **[Local Development](docs/development/local-development.md)** - Daily workflow and best practices
- **[DDEV Commands](docs/development/ddev-commands.md)** - Complete DDEV reference
- **[Troubleshooting](docs/development/troubleshooting.md)** - Common issues and solutions

### 🚀 Deployment
- **[Production Deployment](docs/deployment/production.md)** - Deploy to production servers

### 📖 Quick Reference
- **Requirements:** [DDEV](https://ddev.readthedocs.io/en/stable/#installation) + [Node.js](https://nodejs.org/) (v18+)
- **Commands:** `ddev start` → `npm run dev` → start coding!
- **Admin Panel:** `/admin`
  - Username: `admin`
  - Password: `password`
  - ⚠️ Change in production!

## 📁 Project Structure

```
├── config/              # Craft CMS configuration
├── docs/                # Documentation
├── src/                 # Source assets (CSS, JS, images)
├── templates/           # Twig templates
├── web/                 # Web root (index.php, built assets)
├── .ddev/              # DDEV configuration
├── package.json        # Node.js dependencies
├── composer.json       # PHP dependencies
├── vite.config.js      # Vite configuration
├── tailwind.config.js  # TailwindCSS configuration
└── setup.sh           # Setup script
```

## 🎨 Tech Stack

- **Backend:** Craft CMS 5 (PHP 8.2+)
- **Frontend:** Vite + TailwindCSS + Alpine.js
- **Development:** DDEV + Browser-sync
- **Database:** MySQL (via DDEV)

## 🔌 Included Plugins

- **Vite Plugin** - Modern asset management
- **SEOmatic** - SEO optimization

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
