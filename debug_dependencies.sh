#!/bin/bash

# install_debug_dependencies.sh
# Script para instalar todas las dependencias necesarias para depuración en Neovim

echo "🔧 Instalando dependencias para depuración Python en Neovim..."
echo "=================================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para verificar si un comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Función para instalar paquetes Python
install_python_package() {
    package=$1
    echo -e "${YELLOW}Instalando $package...${NC}"
    if pip3 install --user "$package"; then
        echo -e "${GREEN}✓ $package instalado correctamente${NC}"
    else
        echo -e "${RED}✗ Error instalando $package${NC}"
        return 1
    fi
}

# Verificar Python3
if ! command_exists python3; then
    echo -e "${RED}Python3 no está instalado. Por favor instálalo primero.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Python3 encontrado${NC}"

# Verificar pip3
if ! command_exists pip3; then
    echo -e "${YELLOW}pip3 no encontrado. Instalando...${NC}"
    python3 -m ensurepip --user
fi

# Actualizar pip
echo -e "${YELLOW}Actualizando pip...${NC}"
python3 -m pip install --upgrade pip

# Instalar paquetes Python necesarios
echo ""
echo "📦 Instalando paquetes Python necesarios..."
echo "-------------------------------------------"

packages=(
    "debugpy"         # Para DAP (Debug Adapter Protocol)
    "pytest"          # Para testing
    "pytest-cov"      # Para coverage en tests
    "black"           # Formateador de código
    "isort"           # Organizador de imports
    "pylint"          # Linter
    "mypy"            # Type checking
    "ipython"         # REPL mejorado
    "jupyter"         # Para trabajar con notebooks
    "jupytext"        # Conversión de notebooks
    "memory_profiler" # Para análisis de memoria
    "line_profiler"   # Para profiling línea por línea
)

failed_packages=()

for package in "${packages[@]}"; do
    if ! install_python_package "$package"; then
        failed_packages+=("$package")
    fi
done

# Instalar herramien
