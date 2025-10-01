#!/bin/bash

# Craft CMS Boilerplate Setup Script
# This script sets up a complete Craft CMS development environment

set -e  # Exit on any error

echo "🚀 Setting up Craft CMS Boilerplate..."
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "composer.json" ] || [ ! -f "package.json" ]; then
    print_error "This script must be run from the project root directory"
    exit 1
fi

# Check for required tools
print_status "Checking for required tools..."

if ! command -v ddev &> /dev/null; then
    print_error "DDEV is required but not installed. Please install DDEV first."
    echo "Visit: https://ddev.readthedocs.io/en/stable/#installation"
    exit 1
fi

# Note: We'll use DDEV's built-in Composer instead of system Composer

if ! command -v node &> /dev/null; then
    print_error "Node.js is required but not installed. Please install Node.js first."
    echo "Visit: https://nodejs.org/"
    exit 1
fi

print_success "All required tools are available"

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    print_status "Creating .env file from .env.example..."
    cp .env.example .env
    
    # Generate random keys (URL-safe base64)
    SECURITY_KEY=$(openssl rand -base64 32 2>/dev/null | tr -d "=+/" | tr -d "\n" || head -c 32 /dev/urandom | base64 | tr -d "=+/" | tr -d "\n")
    COOKIE_KEY=$(openssl rand -base64 32 2>/dev/null | tr -d "=+/" | tr -d "\n" || head -c 32 /dev/urandom | base64 | tr -d "=+/" | tr -d "\n")
    APP_ID=$(openssl rand -hex 16 2>/dev/null || head -c 16 /dev/urandom | xxd -p | tr -d "\n")
    
    # Update .env file using a safer approach
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s|CRAFT_SECURITY_KEY=|CRAFT_SECURITY_KEY=$SECURITY_KEY|" .env
        sed -i '' "s|CRAFT_COOKIE_VALIDATION_KEY=|CRAFT_COOKIE_VALIDATION_KEY=$COOKIE_KEY|" .env
        sed -i '' "s|CRAFT_APP_ID=|CRAFT_APP_ID=$APP_ID|" .env
    else
        # Linux
        sed -i "s|CRAFT_SECURITY_KEY=|CRAFT_SECURITY_KEY=$SECURITY_KEY|" .env
        sed -i "s|CRAFT_COOKIE_VALIDATION_KEY=|CRAFT_COOKIE_VALIDATION_KEY=$COOKIE_KEY|" .env
        sed -i "s|CRAFT_APP_ID=|CRAFT_APP_ID=$APP_ID|" .env
    fi
    
    print_success ".env file created with generated keys"
else
    print_warning ".env file already exists, skipping creation"
fi

# Start DDEV
print_status "Starting DDEV environment..."
ddev start

# Install Composer dependencies
print_status "Installing PHP dependencies..."
ddev composer install

# Install Node.js dependencies
print_status "Installing Node.js dependencies..."
npm install

# Create Craft console command
print_status "Creating Craft console command..."
cat > craft << 'EOF'
#!/usr/bin/env php
<?php
/**
 * Craft console bootstrap file
 */

// Set path constants
define('CRAFT_BASE_PATH', __DIR__);
define('CRAFT_VENDOR_PATH', CRAFT_BASE_PATH.'/vendor');

// Load Composer's autoloader
require_once CRAFT_VENDOR_PATH.'/autoload.php';

// Load dotenv?
if (class_exists('Dotenv\Dotenv') && file_exists(CRAFT_BASE_PATH.'/.env')) {
    $dotenv = Dotenv\Dotenv::createUnsafeImmutable(CRAFT_BASE_PATH);
    $dotenv->load();
}

// Load and run Craft
define('CRAFT_ENVIRONMENT', $_ENV['CRAFT_ENVIRONMENT'] ?? $_SERVER['CRAFT_ENVIRONMENT'] ?? 'production');
$app = require CRAFT_VENDOR_PATH.'/craftcms/cms/bootstrap/console.php';
$exitCode = $app->run();
exit($exitCode);
EOF

chmod +x craft

# Install Craft CMS
print_status "Installing Craft CMS..."
ddev craft install --interactive=0 \
    --username=admin \
    --password=password \
    --email=admin@example.com \
    --siteName="Craft CMS Boilerplate" \
    --siteUrl="https://craftcms-boilerplate.ddev.site" \
    --language=en-US

# Build assets
print_status "Building initial assets..."
npm run build

# Install and enable plugins
print_status "Installing Craft CMS plugins..."
ddev craft plugin/install vite
ddev craft plugin/install seomatic

# Create some sample content
print_status "Creating sample content..."
ddev craft sections/create \
    --name="Pages" \
    --handle="pages" \
    --type="structure"

# Note: Field creation via CLI is complex, we'll skip this for the boilerplate
# Users can create fields through the admin panel

# Set proper permissions
print_status "Setting proper permissions..."
chmod -R 755 web/
chmod -R 755 storage/
chmod +x setup.sh

print_success "Setup complete!"
echo ""
echo "🎉 Your Craft CMS boilerplate is ready!"
echo "======================================"
echo ""
echo "📋 Next steps:"
echo "1. Visit your site: https://craftcms-boilerplate.ddev.site"
echo "2. Admin panel: https://craftcms-boilerplate.ddev.site/admin"
echo "   - Username: admin"
echo "   - Password: password"
echo ""
echo "🛠️  Development commands:"
echo "• npm run dev          - Start development with hot reload"
echo "• npm run build        - Build for production"
echo "• ddev craft           - Run Craft CLI commands"
echo "• ddev stop            - Stop the development environment"
echo ""
echo "📁 Important files:"
echo "• templates/           - Twig templates"
echo "• src/css/app.scss     - Main stylesheet"
echo "• src/js/app.js        - Main JavaScript file"
echo "• config/              - Craft CMS configuration"
echo ""
print_success "Happy coding! 🚀"
