#!/bin/bash

# Script para probar la configuración de Java

echo "🧪 Probando configuración de Java en Neovim..."
echo ""

# 1. Verificar Java
echo "1️⃣ Verificando instalación de Java..."
if command -v java &> /dev/null; then
    echo "✅ Java encontrado:"
    java --version
else
    echo "❌ Java NO está instalado"
    echo "   Instala Java con: brew install openjdk"
    exit 1
fi

echo ""

# 2. Verificar javac
echo "2️⃣ Verificando compilador de Java..."
if command -v javac &> /dev/null; then
    echo "✅ javac encontrado:"
    javac --version
else
    echo "❌ javac NO está instalado"
    exit 1
fi

echo ""

# 3. Crear archivo de prueba
echo "3️⃣ Creando archivo de prueba..."
cat > /tmp/Test.java << 'EOF'
public class Test {
    public static void main(String[] args) {
        System.out.println("Hello from Java!");
    }
}
EOF
echo "✅ Archivo creado: /tmp/Test.java"

echo ""

# 4. Compilar y ejecutar
echo "4️⃣ Compilando y ejecutando Java..."
cd /tmp
javac Test.java
if [ $? -eq 0 ]; then
    echo "✅ Compilación exitosa"
    echo "🚀 Ejecutando..."
    java Test
else
    echo "❌ Error en compilación"
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Java está funcionando correctamente en tu sistema"
echo ""
echo "📝 Ahora abre el archivo de prueba en Neovim:"
echo "   nvim /tmp/Test.java"
echo ""
echo "Deberías ver:"
echo "  ✅ Mensaje: '☕ Java LSP activado correctamente'"
echo "  ✅ Autocompletado al escribir 'Sys' + Tab"
echo "  ✅ Errores subrayados en rojo si hay problemas"
echo ""
echo "⌨️  Atajos útiles:"
echo "  K          = Ver documentación"
echo "  gd         = Ir a definición"
echo "  <leader>ca = Code actions (arreglar errores)"
echo "  <leader>e  = Ver detalles del error"
echo "  <F9>       = Ejecutar archivo"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
