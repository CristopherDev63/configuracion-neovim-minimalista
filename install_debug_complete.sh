#!/bin/bash

# install_debug_complete.sh
# Script completo para instalar TODAS las dependencias de debugging

echo "🔧 Instalando dependencias completas para debugging en Neovim..."
echo "================================================================"

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

# ========== VERIFICAR PYTHON3 ==========
echo -e "${BLUE}1. Verificando Python3...${NC}"
if ! command_exists python3; then
    echo -e "${RED}Python3 no está instalado. Por favor instálalo primero.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Python3 encontrado${NC}"

# ========== VERIFICAR PIP3 ==========
echo -e "${BLUE}2. Verificando pip3...${NC}"
if ! command_exists pip3; then
    echo -e "${YELLOW}pip3 no encontrado. Instalando...${NC}"
    python3 -m ensurepip --user
fi
echo -e "${GREEN}✓ pip3 disponible${NC}"

# Actualizar pip
echo -e "${YELLOW}Actualizando pip...${NC}"
python3 -m pip install --upgrade pip

# ========== INSTALAR PAQUETES PYTHON ESENCIALES ==========
echo ""
echo -e "${BLUE}3. Instalando paquetes Python para debugging...${NC}"
echo "------------------------------------------------------"

packages=(
    "debugpy"    # CRÍTICO: Para DAP Python
    "pytest"     # Para testing
    "pytest-cov" # Para coverage
    "black"      # Formateador
    "isort"      # Organizador imports
    "mypy"       # Type checking
    "ipython"    # REPL mejorado
)

failed_packages=()

for package in "${packages[@]}"; do
    if ! install_python_package "$package"; then
        failed_packages+=("$package")
    fi
done

# ========== VERIFICAR INSTALACIÓN DEBUGPY ==========
echo ""
echo -e "${BLUE}4. Verificando debugpy...${NC}"
if python3 -c "import debugpy; print('debugpy OK')" 2>/dev/null; then
    echo -e "${GREEN}✓ debugpy instalado y funcionando${NC}"
else
    echo -e "${RED}✗ debugpy falló. Reintentando instalación...${NC}"
    pip3 install --user --force-reinstall debugpy
fi

# ========== INSTALAR NODE.JS PARA JS/TS DEBUGGING ==========
echo ""
echo -e "${BLUE}5. Verificando Node.js para JavaScript debugging...${NC}"
if command_exists node; then
    echo -e "${GREEN}✓ Node.js encontrado: $(node --version)${NC}"
else
    echo -e "${YELLOW}Node.js no encontrado. Instalando...${NC}"
    # Instalar Node.js según el sistema
    if command_exists apt; then
        sudo apt update && sudo apt install -y nodejs npm
    elif command_exists yum; then
        sudo yum install -y nodejs npm
    elif command_exists brew; then
        brew install node
    else
        echo -e "${RED}No se pudo instalar Node.js automáticamente${NC}"
        echo -e "${YELLOW}Por favor instala Node.js manualmente desde: https://nodejs.org${NC}"
    fi
fi

# ========== VERIFICAR BASH PARA BASH DEBUGGING ==========
echo ""
echo -e "${BLUE}6. Verificando Bash...${NC}"
if command_exists bash; then
    echo -e "${GREEN}✓ Bash encontrado: $(bash --version | head -1)${NC}"
else
    echo -e "${RED}✗ Bash no encontrado${NC}"
fi

# ========== VERIFICAR PHP PARA PHP DEBUGGING ==========
echo ""
echo -e "${BLUE}7. Verificando PHP...${NC}"
if command_exists php; then
    echo -e "${GREEN}✓ PHP encontrado: $(php --version | head -1)${NC}"

    # Verificar si Xdebug está instalado
    if php -m | grep -i xdebug >/dev/null; then
        echo -e "${GREEN}✓ Xdebug encontrado${NC}"
    else
        echo -e "${YELLOW}⚠ Xdebug no encontrado. Para debugging PHP completo, instala Xdebug:${NC}"
        echo -e "${YELLOW}  sudo apt install php-xdebug  # Ubuntu/Debian${NC}"
        echo -e "${YELLOW}  sudo yum install php-xdebug  # CentOS/RHEL${NC}"
    fi
else
    echo -e "${YELLOW}⚠ PHP no encontrado. Instálalo si planeas debuggear PHP${NC}"
fi

# ========== CREAR ARCHIVO DE PRUEBA PYTHON ==========
echo ""
echo -e "${BLUE}8. Creando archivo de prueba para debugging...${NC}"
cat >test_debug.py <<'EOF'
#!/usr/bin/env python3
"""
Archivo de prueba para debugging en Neovim
Usa Ctrl+C para iniciar el debugging
"""

def calcular_factorial(n):
    """Calcula el factorial de un número"""
    if n <= 1:
        return 1
    else:
        resultado = 1
        for i in range(1, n + 1):
            resultado *= i
        return resultado

def main():
    """Función principal"""
    numero = 5
    print(f"Calculando factorial de {numero}")
    
    # Pon un breakpoint aquí con <leader>b
    factorial = calcular_factorial(numero)
    
    print(f"El factorial de {numero} es: {factorial}")
    
    # Ejemplo con lista
    numeros = [1, 2, 3, 4, 5]
    print("Números:", numeros)
    
    for num in numeros:
        cuadrado = num ** 2
        print(f"{num}² = {cuadrado}")

if __name__ == "__main__":
    main()
EOF

echo -e "${GREEN}✓ Archivo test_debug.py creado${NC}"

# ========== INSTRUCCIONES FINALES ==========
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}🎉 INSTALACIÓN COMPLETADA${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}📋 INSTRUCCIONES DE USO:${NC}"
echo ""
echo -e "${YELLOW}1. Abre Neovim: nvim test_debug.py${NC}"
echo -e "${YELLOW}2. Pon un breakpoint: <leader>b en una línea${NC}"
echo -e "${YELLOW}3. Inicia debugging: Ctrl+C${NC}"
echo -e "${YELLOW}4. Usa F10 para step over, F11 para step into${NC}"
echo -e "${YELLOW}5. Termina debugging: <leader>dt${NC}"
echo ""
echo -e "${BLUE}🎯 ATAJOS PRINCIPALES:${NC}"
echo -e "${GREEN}  Ctrl+C     ${NC}→ Iniciar debugging"
echo -e "${GREEN}  <leader>b  ${NC}→ Toggle breakpoint"
echo -e "${GREEN}  F5         ${NC}→ Continuar"
echo -e "${GREEN}  F10        ${NC}→ Step over"
echo -e "${GREEN}  F11        ${NC}→ Step into"
echo -e "${GREEN}  F12        ${NC}→ Step out"
echo -e "${GREEN}  <leader>dt ${NC}→ Terminar debug"
echo -e "${GREEN}  <leader>du ${NC}→ Toggle Debug UI"
echo ""

# ========== REPORTE DE FALLOS ==========
if [ ${#failed_packages[@]} -ne 0 ]; then
    echo -e "${RED}⚠ PAQUETES QUE FALLARON:${NC}"
    for package in "${failed_packages[@]}"; do
        echo -e "${RED}  ✗ $package${NC}"
    done
    echo -e "${YELLOW}Puedes intentar instalarlos manualmente con: pip3 install --user PAQUETE${NC}"
    echo ""
fi

echo -e "${GREEN}¡Debugging configurado y listo para usar!${NC}"
echo -e "${BLUE}Prueba con: nvim test_debug.py${NC}"
