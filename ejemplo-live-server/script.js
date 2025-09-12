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
