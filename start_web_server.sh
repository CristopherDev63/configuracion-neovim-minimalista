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
