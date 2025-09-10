#!/bin/bash

# install_web_dependencies.sh
# Script para instalar todas las dependencias de desarrollo web en Neovim

echo "🌐 Instalando dependencias para desarrollo web completo..."
echo "============================================================"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para verificar si un comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Función para instalar paquetes npm globalmente
install_npm_package() {
    package=$1
    echo -e "${YELLOW}Instalando $package...${NC}"
    if npm install -g "$package"; then
        echo -e "${GREEN}✓ $package instalado correctamente${NC}"
    else
        echo -e "${RED}✗ Error instalando $package${NC}"
        return 1
    fi
}

# ========== VERIFICAR NODE.JS Y NPM ==========
echo -e "${BLUE}1. Verificando Node.js y npm...${NC}"
if ! command_exists node; then
    echo -e "${RED}Node.js no está instalado.${NC}"
    echo -e "${YELLOW}Instalando Node.js...${NC}"
    
    # Instalar Node.js según el sistema
    if command_exists apt; then
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
    elif command_exists yum; then
        curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
        sudo yum install -y nodejs npm
    elif command_exists brew; then
        brew install node
    elif command_exists pacman; then
        sudo pacman -S nodejs npm
    else
        echo -e "${RED}No se pudo instalar Node.js automáticamente${NC}"
        echo -e "${YELLOW}Por favor instala Node.js manualmente desde: https://nodejs.org${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ Node.js encontrado: $(node --version)${NC}"
echo -e "${GREEN}✓ npm encontrado: $(npm --version)${NC}"

# ========== INSTALAR HERRAMIENTAS GLOBALES NPM ==========
echo ""
echo -e "${BLUE}2. Instalando herramientas de desarrollo web globales...${NC}"
echo "-------------------------------------------------------"

# Lista de paquetes npm esenciales
npm_packages=(
    "prettier"              # Formateador de código
    "eslint"               # Linter para JavaScript
    "@typescript-eslint/parser"  # Parser TypeScript para ESLint
    "@typescript-eslint/eslint-plugin"  # Plugin TypeScript para ESLint
    "stylelint"            # Linter para CSS
    "csslint"              # Validador CSS
    "htmlhint"             # Linter para HTML
    "tidy-html5"           # Validador y formateador HTML
    "clean-css-cli"        # Minificador CSS
    "uglify-js"            # Minificador JavaScript
    "typescript"           # Compilador TypeScript
    "ts-node"              # Ejecutor TypeScript
    "live-server"          # Servidor web con recarga automática
    "browser-sync"         # Sincronización entre navegadores
    "sass"                 # Compilador Sass/SCSS
    "postcss-cli"          # Post-procesador CSS
    "autoprefixer"         # Auto-prefijos CSS
    "webpack"              # Bundler
    "webpack-cli"          # CLI de Webpack
    "vite"                 # Build tool moderno
    "parcel"               # Bundler zero-config
)

failed_packages=()

for package in "${npm_packages[@]}"; do
    if ! install_npm_package "$package"; then
        failed_packages+=("$package")
    fi
done

# ========== INSTALAR LSP SERVERS ==========
echo ""
echo -e "${BLUE}3. Instalando Language Servers...${NC}"
echo "----------------------------------"

lsp_packages=(
    "vscode-langservers-extracted"  # HTML, CSS, JSON, ESLint LSP
    "typescript-language-server"    # TypeScript LSP
    "emmet-ls"                      # Emmet Language Server
    "@vtsls/language-server"        # Vue TypeScript LSP
    "svelte-language-server"        # Svelte LSP
)

for package in "${lsp_packages[@]}"; do
    if ! install_npm_package "$package"; then
        failed_packages+=("$package")
    fi
done

# ========== VERIFICAR PYTHON PARA ALGUNOS TOOLS ==========
echo ""
echo -e "${BLUE}4. Verificando Python para herramientas adicionales...${NC}"
if command_exists python3 && command_exists pip3; then
    echo -e "${GREEN}✓ Python3 encontrado${NC}"
    
    # Instalar beautifulsoup para parsing HTML
    echo -e "${YELLOW}Instalando beautifulsoup4...${NC}"
    pip3 install --user beautifulsoup4 html5lib lxml
else
    echo -e "${YELLOW}⚠ Python3 no encontrado. Algunas herramientas no estarán disponibles.${NC}"
fi

# ========== CREAR ARCHIVOS DE CONFIGURACIÓN ==========
echo ""
echo -e "${BLUE}5. Creando archivos de configuración...${NC}"
echo "--------------------------------------------"

# Crear .eslintrc.js
cat > .eslintrc.js << 'EOF'
module.exports = {
    env: {
        browser: true,
        es2021: true,
        node: true
    },
    extends: [
        'eslint:recommended'
    ],
    parserOptions: {
        ecmaVersion: 12,
        sourceType: 'module'
    },
