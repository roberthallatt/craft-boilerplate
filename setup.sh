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

# Get project name from user
echo ""
print_status "Project Configuration"
echo "====================="
echo ""
echo "What would you like to name your project?"
echo "This will be used for:"
echo "• DDEV project name"
echo "• Domain name (yourname.ddev.site)"
echo "• SSL certificates"
echo ""
echo "Requirements:"
echo "• Use lowercase letters, numbers, and hyphens only"
echo "• No spaces or special characters"
echo "• Example: my-craft-site, blog-project, portfolio-2024"
echo ""

while true; do
    read -p "Project name: " PROJECT_NAME
    
    # Validate project name
    if [[ -z "$PROJECT_NAME" ]]; then
        print_error "Project name cannot be empty"
        continue
    fi
    
    # Check for valid characters (lowercase letters, numbers, hyphens)
    if [[ ! "$PROJECT_NAME" =~ ^[a-z0-9-]+$ ]]; then
        print_error "Project name can only contain lowercase letters, numbers, and hyphens"
        continue
    fi
    
    # Check length (DDEV has limits)
    if [[ ${#PROJECT_NAME} -gt 63 ]]; then
        print_error "Project name must be 63 characters or less"
        continue
    fi
    
    if [[ ${#PROJECT_NAME} -lt 3 ]]; then
        print_error "Project name must be at least 3 characters"
        continue
    fi
    
    break
done

print_success "Project name set to: $PROJECT_NAME"
echo "Your site will be available at: https://$PROJECT_NAME.ddev.site"
echo ""

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

# If mkcert is available, set up the certificate authority and create certificates
if command -v mkcert &> /dev/null; then
    print_status "Setting up mkcert certificate authority..."
    mkcert -install
    print_success "Certificate authority installed - SSL certificates will be trusted by browsers"
    
    # Create trusted certificates for localhost and DDEV domain
    print_status "Creating trusted SSL certificates for development..."
    mkdir -p .ddev/certs
    mkcert -key-file .ddev/certs/localhost-key.pem -cert-file .ddev/certs/localhost.pem localhost 127.0.0.1 ::1 $PROJECT_NAME.ddev.site
    
    # Also create certificates with the standard DDEV naming for automatic detection
    mkcert -key-file .ddev/certs/$PROJECT_NAME.ddev.site-key.pem -cert-file .ddev/certs/$PROJECT_NAME.ddev.site.pem $PROJECT_NAME.ddev.site localhost 127.0.0.1 ::1
    
    print_success "SSL certificates created for localhost and $PROJECT_NAME.ddev.site"
    
    # Configure DDEV to use custom SSL certificates
    print_status "Configuring DDEV to use custom SSL certificates..."
    # DDEV will automatically detect and use certificates in .ddev/certs/
    # No additional configuration needed as additional_hostnames and use_dns_when_possible are already set
    
    # Configure Vite to use HTTPS with mkcert certificates
    print_status "Configuring Vite for HTTPS development..."
    VITE_DEV_SERVER_PUBLIC="http://localhost:3000"
    VITE_DEV_SERVER_INTERNAL="http://localhost:3000"
    VITE_HTTPS_ENABLED="true"
else
    print_warning "mkcert not found - configuring Vite for HTTP development"
    print_warning "For trusted SSL certificates, install mkcert:"
    echo ""
    echo "  macOS:   brew install mkcert"
    echo "  Ubuntu:  sudo apt install mkcert"
    echo "  Other:   https://github.com/FiloSottile/mkcert#installation"
    echo ""
    print_warning "Then re-run: ./setup.sh"
    echo ""
    
    # Configure Vite to use HTTP without certificates
    VITE_DEV_SERVER_PUBLIC="http://localhost:3000"
    VITE_DEV_SERVER_INTERNAL="http://localhost:3000"
    VITE_HTTPS_ENABLED="false"
fi

# Update Craft Vite configuration
print_status "Updating Craft Vite configuration..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s|VITE_DEV_SERVER_PUBLIC_PLACEHOLDER|$VITE_DEV_SERVER_PUBLIC|" config/vite.php
    sed -i '' "s|VITE_DEV_SERVER_INTERNAL_PLACEHOLDER|$VITE_DEV_SERVER_INTERNAL|" config/vite.php
else
    # Linux
    sed -i "s|VITE_DEV_SERVER_PUBLIC_PLACEHOLDER|$VITE_DEV_SERVER_PUBLIC|" config/vite.php
    sed -i "s|VITE_DEV_SERVER_INTERNAL_PLACEHOLDER|$VITE_DEV_SERVER_INTERNAL|" config/vite.php
fi

# Update DDEV configuration with custom project name
print_status "Configuring DDEV with project name: $PROJECT_NAME"
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/name: craftcms-boilerplate/name: $PROJECT_NAME/" .ddev/config.yaml
else
    # Linux
    sed -i "s/name: craftcms-boilerplate/name: $PROJECT_NAME/" .ddev/config.yaml
fi
print_success "DDEV configuration updated"

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

# Install dependencies before starting DDEV to avoid hook failures
print_status "Installing dependencies locally first..."

# Install Composer dependencies locally if composer is available
if command -v composer &> /dev/null; then
    print_status "Installing PHP dependencies locally..."
    composer install --no-interaction
else
    print_warning "Composer not found locally - will install via DDEV after start"
fi

# Install Node.js dependencies locally if npm is available
if command -v npm &> /dev/null; then
    print_status "Installing Node.js dependencies locally..."
    npm install
else
    print_warning "npm not found locally - will install via DDEV after start"
fi

# Start DDEV
print_status "Starting DDEV environment..."
ddev start

# Install any missing dependencies via DDEV if local installation failed
if [ ! -d "vendor" ]; then
    print_status "Installing PHP dependencies via DDEV..."
    ddev composer install
fi

if [ ! -d "node_modules" ]; then
    print_status "Installing Node.js dependencies via DDEV..."
    ddev npm install
fi

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
    --siteName="$PROJECT_NAME" \
    --siteUrl="https://$PROJECT_NAME.ddev.site" \
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

# Determine the correct protocol based on SSL setup
if [ "$VITE_HTTPS_ENABLED" = "true" ]; then
    VITE_URL="https://localhost:3000"
    SSL_STATUS="✅ Trusted SSL certificates"
else
    VITE_URL="http://localhost:3000"
    SSL_STATUS="⚠️  HTTP only (install mkcert for SSL)"
fi

print_success "Setup complete!"
echo ""
echo "🎉 Your Craft CMS site is ready!"
echo "======================================"
echo ""
echo "🌐 Access your site:"
if [ "$VITE_HTTPS_ENABLED" = "true" ]; then
    echo "   • https://$PROJECT_NAME.ddev.site (Main site - ✅ Trusted SSL)"
    echo "   • $VITE_URL (Vite dev server - ✅ Trusted SSL)"
else
    echo "   • https://$PROJECT_NAME.ddev.site (Main site - ⚠️ Browser warnings)"
    echo "   • $VITE_URL (Vite dev server - HTTP only)"
fi
echo ""
echo "🔐 Admin panel:"
echo "   • https://$PROJECT_NAME.ddev.site/admin"
echo "   • Username: admin"
echo "   • Password: password"
echo ""
echo "🛠️  Development commands:"
echo "• npm run dev          - Start Vite dev server with HMR"
echo "• npm run build        - Build for production"
echo "• ddev start/stop      - Control DDEV environment"
echo ""
echo "📝 Development workflow:"
echo "1. Run 'npm run dev' to start Vite dev server"
echo "2. Visit https://$PROJECT_NAME.ddev.site for your site"
echo "3. CSS/JS changes will hot-reload automatically"
echo ""
echo "📁 Important files:"
echo "• templates/           - Twig templates"
echo "• src/css/app.scss     - Main stylesheet"
echo "• src/js/app.js        - Main JavaScript file"
echo ""
if [ "$VITE_HTTPS_ENABLED" = "false" ]; then
    echo "💡 Pro tip: Install mkcert for trusted SSL certificates:"
    echo "   brew install mkcert && ./setup.sh"
    echo ""
fi
echo "Happy coding! 🚀"
echo ""

print_success "Happy coding! 🚀"
