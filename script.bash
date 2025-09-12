#!/bin/bash

# install_live_server_dependencies.sh
# Script para instalar todas las dependencias para servidor web en tiempo real

echo "🌐 Instalando dependencias para servidor web en tiempo real..."
echo "============================================================="

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

# ========== INSTALAR LIVE SERVERS ==========
echo ""
echo -e "${BLUE}2. Instalando servidores web...${NC}"
echo "--------------------------------"

# Lista de servidores web esenciales
web_servers=(
    "live-server"              # Servidor con recarga automática
    "browser-sync"             # Sincronización entre navegadores
    "http-server"              # Servidor HTTP simple
    "serve"                    # Servidor estático moderno
)

failed_packages=()

for package in "${web_servers[@]}"; do
    if ! install_npm_package "$package"; then
        failed_packages+=("$package")
    fi
done

# ========== VERIFICAR PYTHON PARA SERVIDOR SIMPLE ==========
echo ""
echo -e "${BLUE}3. Verificando Python para servidor HTTP simple...${NC}"
if command_exists python3; then
    echo -e "${GREEN}✓ Python3 encontrado: $(python3 --version)${NC}"
    echo -e "${GREEN}✓ Servidor Python disponible: python3 -m http.server${NC}"
elif command_exists python; then
    echo -e "${GREEN}✓ Python encontrado: $(python --version)${NC}"
    echo -e "${GREEN}✓ Servidor Python disponible: python -m SimpleHTTPServer${NC}"
else
    echo -e "${YELLOW}⚠ Python no encontrado. Instálalo para usar servidor HTTP simple.${NC}"
fi

# ========== VERIFICAR NAVEGADORES ==========
echo ""
echo -e "${BLUE}4. Verificando navegadores disponibles...${NC}"
browsers=("firefox" "google-chrome" "chromium" "safari")
available_browsers=()

for browser in "${browsers[@]}"; do
    if command_exists "$browser"; then
        available_browsers+=("$browser")
        echo -e "${GREEN}✓ $browser encontrado${NC}"
    fi
done

if [ ${#available_browsers[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠ No se encontraron navegadores. Instala Firefox o Chrome.${NC}"
else
    echo -e "${GREEN}✓ Navegadores disponibles: ${available_browsers[*]}${NC}"
fi

# ========== CREAR ARCHIVOS DE EJEMPLO ==========
echo ""
echo -e "${BLUE}5. Creando proyecto de ejemplo...${NC}"
echo "--------------------------------"

# Crear directorio de ejemplo
mkdir -p ejemplo-live-server
cd ejemplo-live-server

# Crear index.html
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🌐 Live Server Test</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <header>
        <h1>🚀 ¡Servidor Web Funcionando!</h1>
        <p>Este archivo se recarga automáticamente</p>
    </header>
    
    <main>
        <div class="card">
            <h2>🎉 Todo funciona correctamente</h2>
            <p>Edita este archivo en Neovim y verás los cambios en tiempo real.</p>
            <button id="test-btn">Click para probar JavaScript</button>
            <p id="result"></p>
        </div>
        
        <div class="info">
            <h3>📋 Comandos disponibles en Neovim:</h3>
            <ul>
                <li><code>&lt;leader&gt;ws</code> - Iniciar Bracey</li>
                <li><code>&lt;leader&gt;ls</code> - Iniciar Live Server</li>
                <li><code>&lt;leader&gt;ps</code> - Servidor Python</li>
                <li><code>&lt;leader&gt;bs</code> - Browser-Sync</li>
                <li><code>:WebServer</code> - Menú de servidores</li>
            </ul>
        </div>
    </main>
    
    <footer>
        <p>🔄 Auto-reload habilitado | 💻 Desarrollado con Neovim</p>
    </footer>
    
    <script src="script.js"></script>
</body>
</html>
EOF

# Crear style.css
cat > style.css << 'EOF'
/* Estilos para demo de Live Server */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    line-height: 1.6;
    color: #333;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
}

header {
    text-align: center;
    padding: 2rem;
    color: white;
}

header h1 {
    font-size: 3rem;
    margin-bottom: 0.5rem;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
}

main {
    max-width: 800px;
    margin: 0 auto;
    padding: 0 1rem;
}

.card {
    background: white;
    padding: 2rem;
    border-radius: 10px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.2);
    margin-bottom: 2rem;
    text-align: center;
}

.info {
    background: rgba(255, 255, 255, 0.9);
    padding: 1.5rem;
    border-radius: 10px;
    margin-bottom: 2rem;
}

.info ul {
    list-style: none;
    margin-top: 1rem;
}

.info li {
    padding: 0.5rem 0;
    border-bottom: 1px solid #eee;
}

.info code {
    background: #f1f5f9;
    padding: 0.2rem 0.4rem;
    border-radius: 4px;
    font-family: 'Monaco', 'Menlo', monospace;
}

button {
    background: #667eea;
    color: white;
    border: none;
    padding: 12px 24px;
    border-radius: 6px;
    cursor: pointer;
    font-size: 1rem;
    margin: 1rem;
    transition: all 0.3s ease;
}

button:hover {
    background: #5a67d8;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

#result {
    margin-top: 1rem;
    padding: 1rem;
    background: #f0f9ff;
    border-radius: 6px;
    font-weight: bold;
}

footer {
    text-align: center;
    padding: 2rem;
    color: white;
    margin-top: 2rem;
}

/* Animación de entrada */
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}

.card, .info {
    animation: fadeIn 0.6s ease-out;
}
EOF

# Crear script.js
cat > script.js << 'EOF'
// JavaScript para demo de Live Server
console.log('🚀 Live Server Demo cargado!');

// Función para mostrar la hora actual
function updateTime() {
    const now = new Date();
    const timeString = now.toLocaleTimeString();
    document.title = `🌐 Live Server - ${timeString}`;
}

// Actualizar título cada segundo
setInterval(updateTime, 1000);

// Event listener para el botón de prueba
document.getElementById('test-btn').addEventListener('click', function() {
    const result = document.getElementById('result');
    const messages = [
        '✅ JavaScript funcionando perfectamente!',
        '🎉 Live reload detectado!',
        '🔄 Cambios en tiempo real!',
        '⚡ Servidor web activo!',
        '💻 Desarrollando con Neovim!'
    ];
    
    const randomMessage = messages[Math.floor(Math.random() * messages.length)];
    result.textContent = randomMessage;
    result.style.color = '#059669';
    
    // Efecto visual
    this.style.background = '#10b981';
    setTimeout(() => {
        this.style.background = '#667eea';
    }, 200);
});

// Mostrar información del navegador
console.log('📱 Navegador:', navigator.userAgent);
console.log('📍 URL actual:', window.location.href);

// Auto-reload indicator para desarrollo
if (location.hostname === 'localhost' || location.hostname === '127.0.0.1') {
    console.log('🔄 Modo desarrollo activo');
    
    // Agregar indicador visual de desarrollo
    const devIndicator = document.createElement('div');
    devIndicator.innerHTML = '🔄 DEV';
    devIndicator.style.cssText = `
        position: fixed;
        top: 10px;
        right: 10px;
        background: #ef4444;
        color: white;
        padding: 5px 10px;
        border-radius: 4px;
        font-size: 12px;
        z-index: 9999;
        animation: pulse 2s infinite;
    `;
    document.body.appendChild(devIndicator);
    
    // CSS para animación
    const style = document.createElement('style');
    style.textContent = `
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }
    `;
    document.head.appendChild(style);
}
EOF

cd ..

echo -e "${GREEN}✓ Proyecto de ejemplo creado en: ejemplo-live-server/${NC}"

# ========== CREAR SCRIPT DE INICIO RÁPIDO ==========
echo ""
echo -e "${BLUE}6. Creando script de inicio rápido...${NC}"

cat > start_web_server.sh << 'EOF'
#!/bin/bash

# Script para iniciar servidor web rápido
echo "🌐 Selecciona un servidor web:"
echo "1) Live Server (puerto 8080)"
echo "2) Browser-Sync (puerto 3000)"
echo "3) Python HTTP (puerto 8000)"
echo "4) HTTP Server (puerto 8080)"

read -p "Opción [1-4]: " choice

case $choice in
    1)
        echo "🚀 Iniciando Live Server..."
        live-server --port=8080 --open=false
        ;;
    2)
        echo "🔄 Iniciando Browser-Sync..."
        browser-sync start --server . --port 3000 --files "*.html, *.css, *.js"
        ;;
    3)
        echo "🐍 Iniciando servidor Python..."
        if command -v python3 &> /dev/null; then
            python3 -m http.server 8000
        else
            python -m SimpleHTTPServer 8000
        fi
        ;;
    4)
        echo "⚡ Iniciando HTTP Server..."
        http-server -p 8080
        ;;
    *)
        echo "❌ Opción no válida"
        exit 1
        ;;
esac
EOF

chmod +x start_web_server.sh
echo -e "${GREEN}✓ Script start_web_server.sh creado${NC}"

# ========== INSTRUCCIONES FINALES ==========
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}
