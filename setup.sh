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

# Check for mkcert and offer to install it
print_status "Checking for mkcert (for trusted SSL certificates)..."

if ! command -v mkcert &> /dev/null; then
    print_warning "mkcert is not installed. This tool creates trusted SSL certificates for local development."
    echo ""
    echo "Without mkcert, you'll see browser security warnings when accessing https://localhost"
    echo "You can still proceed and accept the warnings manually."
    echo ""
    
    # Detect OS and offer installation
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            echo "Would you like to install mkcert via Homebrew? (y/n)"
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                print_status "Installing mkcert via Homebrew..."
                brew install mkcert
                print_success "mkcert installed successfully"
            else
                print_warning "Skipping mkcert installation. You can install it later with: brew install mkcert"
            fi
        else
            print_warning "Homebrew not found. You can install mkcert manually:"
            echo "1. Install Homebrew: https://brew.sh/"
            echo "2. Run: brew install mkcert"
        fi
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
        # Windows
        if command -v choco &> /dev/null; then
            echo "Would you like to install mkcert via Chocolatey? (y/n)"
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                print_status "Installing mkcert via Chocolatey..."
                choco install mkcert -y
                print_success "mkcert installed successfully"
            else
                print_warning "Skipping mkcert installation. You can install it later with: choco install mkcert"
            fi
        else
            print_warning "Chocolatey not found. You can install mkcert manually:"
            echo "1. Install Chocolatey: https://chocolatey.org/install"
            echo "2. Run: choco install mkcert"
            echo "Or download from: https://github.com/FiloSottile/mkcert/releases"
        fi
    else
        # Linux
        print_warning "On Linux, you can install mkcert with:"
        echo "sudo apt install libnss3-tools"
        echo "wget -O mkcert https://github.com/FiloSottile/mkcert/releases/latest/download/mkcert-v*-linux-amd64"
        echo "chmod +x mkcert && sudo mv mkcert /usr/local/bin/"
    fi
    echo ""
else
    print_success "mkcert is already installed"
fi

# If mkcert is available, set up the certificate authority
if command -v mkcert &> /dev/null; then
    print_status "Setting up mkcert certificate authority..."
    mkcert -install
    print_success "Certificate authority installed - SSL certificates will be trusted by browsers"
fi

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
echo "1. Visit your site:"
echo "   • https://craftcms-boilerplate.ddev.site"
echo "   • https://localhost (alternative URL)"
echo "2. Admin panel:"
echo "   • https://localhost/admin"
echo "   • Username: admin"
echo "   • Password: password"
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

# Add SSL certificate note based on mkcert availability
if command -v mkcert &> /dev/null; then
    echo "🔒 SSL certificates are trusted by your browser (mkcert installed)"
else
    echo "🔒 SSL Note: You may see browser warnings for https://localhost"
    echo "   Click 'Advanced' → 'Proceed to site' to accept the certificate"
    echo "   Or install mkcert later: brew install mkcert && mkcert -install && ddev restart"
fi
echo ""

print_success "Happy coding! 🚀"
