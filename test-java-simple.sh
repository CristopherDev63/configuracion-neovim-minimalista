#!/bin/bash

echo "🧪 Test rápido de Java en Neovim"
echo ""

# Crear archivo de prueba
cat > /tmp/HelloWorld.java << 'EOF'
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");

        // Error intencional para probar detección de errores
        // int x = "hola"; // Descomentar para ver error

        String name = "Java";
        System.out.println("Lenguaje: " + name);
    }
}
EOF

echo "✅ Archivo creado: /tmp/HelloWorld.java"
echo ""
echo "📝 INSTRUCCIONES:"
echo ""
echo "1. Abre Neovim:"
echo "   nvim /tmp/HelloWorld.java"
echo ""
echo "2. Espera 3-5 segundos a que se active el LSP"
echo ""
echo "3. Deberías ver:"
echo "   ✅ Mensaje en la parte inferior: '✅ LSP configurado...'"
echo ""
echo "4. PRUEBA EL AUTOCOMPLETADO:"
echo "   - En modo INSERT, escribe:  Sys"
echo "   - Presiona: Tab o Ctrl+Space"
echo "   - Deberías ver: System, SystemProperties, etc."
echo ""
echo "5. PRUEBA DETECCIÓN DE ERRORES:"
echo "   - Descomentar la línea: int x = \"hola\";"
echo "   - Deberías ver una línea roja/subrayado"
echo "   - Presiona: <leader>e  (para ver detalles del error)"
echo ""
echo "6. PRUEBA IR A DEFINICIÓN:"
echo "   - Pon cursor sobre 'println'"
echo "   - Presiona: gd"
echo ""
echo "7. PRUEBA DOCUMENTACIÓN:"
echo "   - Pon cursor sobre 'System'"
echo "   - Presiona: K"
echo ""
echo "8. EJECUTAR EL CÓDIGO:"
echo "   - Presiona: <F9>"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Si NO funciona, ejecuta en Neovim:"
echo "  :Mason       (instala jdtls si no está)"
echo "  :LspInfo     (verifica que jdtls esté attached)"
echo "  :LspRestart  (reinicia el LSP)"
echo ""
