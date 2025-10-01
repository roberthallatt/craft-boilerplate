#!/bin/bash

# Quick test script to verify the boilerplate setup
echo "🧪 Testing Craft CMS Boilerplate Setup..."
echo "========================================"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Test function
test_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✅${NC} $1 exists"
    else
        echo -e "${RED}❌${NC} $1 missing"
    fi
}

test_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✅${NC} $1/ directory exists"
    else
        echo -e "${RED}❌${NC} $1/ directory missing"
    fi
}

echo "📁 Testing directory structure..."
test_dir "config"
test_dir "templates"
test_dir "src/css"
test_dir "src/js"
test_dir "src/img"
test_dir "web"
test_dir ".ddev"

echo ""
echo "📄 Testing configuration files..."
test_file "package.json"
test_file "composer.json"
test_file "vite.config.js"
test_file "tailwind.config.js"
test_file "bs-config.cjs"
test_file ".env.example"
test_file "setup.sh"

echo ""
echo "🎨 Testing source files..."
test_file "src/css/app.scss"
test_file "src/js/app.js"

echo ""
echo "🏗️ Testing Craft CMS files..."
test_file "config/general.php"
test_file "config/db.php"
test_file "config/vite.php"
test_file "web/index.php"
test_file "web/.htaccess"

echo ""
echo "📋 Testing templates..."
test_file "templates/_layouts/_layout.twig"
test_file "templates/index.twig"

echo ""
echo "🔧 Testing DDEV configuration..."
test_file ".ddev/config.yaml"
test_file ".ddev/nginx/nginx-site.conf"

echo ""
echo "📚 Testing documentation..."
test_file "README.md"
test_file ".gitignore"

echo ""
echo "🎉 Setup test complete!"
echo ""
echo "To get started:"
echo "1. cd /Users/webdeveloper/Web/boilerplates/craftcms"
echo "2. ./setup.sh"
echo "3. npm run dev"
