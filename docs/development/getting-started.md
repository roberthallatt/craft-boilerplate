# Getting Started

This guide will help you set up the Craft CMS boilerplate for local development.

## 📋 Requirements

- [DDEV](https://ddev.readthedocs.io/en/stable/#installation) (includes PHP and Composer)
- [Node.js](https://nodejs.org/) (v18+)

## 🛠️ Quick Start

### 1. Clone or Download
```bash
# If cloning from a repository
git clone <repository-url> my-craft-project
cd my-craft-project
```

### 2. Run Setup Script
```bash
./setup.sh
```

This script will:
- Start DDEV containers
- Install PHP dependencies via Composer
- Install Node.js dependencies
- Set up initial Craft CMS configuration

### 3. Start Development
```bash
npm run dev
```

This command runs both Vite (for asset building) and Browser-sync (for live reloading).

### 4. Access Your Site
- **Frontend**: https://craftcms-boilerplate.ddev.site
- **Admin Panel**: https://craftcms-boilerplate.ddev.site/admin
  - Username: `admin`
  - Password: `password`

## 📁 Project Structure

```
├── config/              # Craft CMS configuration
├── docs/                # Documentation (you are here!)
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

## 🎯 Next Steps

1. **Explore the admin panel** - Create your first entry or section
2. **Customize the design** - Edit `src/css/app.scss` and Tailwind config
3. **Add content** - Create templates in the `templates/` directory
4. **Learn DDEV** - Check out the [DDEV Commands Reference](ddev-commands.md)

## 🆘 Need Help?

- Check the [Troubleshooting Guide](troubleshooting.md)
- Review [Local Development](local-development.md) for detailed workflow
- See [DDEV Commands](ddev-commands.md) for container management
