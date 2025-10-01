# 🚀 Instalación Rápida de Java en Neovim

## ✅ Pasos para Activar Java

### 1. Reinicia Neovim
Cierra Neovim completamente y vuelve a abrirlo:
```bash
nvim
```

### 2. Instala los Plugins
Cuando Neovim se abra, espera a que se instalen automáticamente los plugins (verás notificaciones).

Si no se instalan automáticamente, ejecuta:
```vim
:Lazy sync
```

### 3. Instala jdtls con Mason
```vim
:Mason
```
Busca `jdtls` y presiona `i` para instalarlo.

También instala:
- `java-debug-adapter` (para debugging)
- `java-test` (para tests)

### 4. Reinicia Neovim de nuevo
```bash
:qa
nvim
```

### 5. Abre un archivo Java de prueba
```bash
nvim Test.java
```

Escribe este código de prueba:
```java
public class Test {
    public static void main(String[] args) {
        System.out.println("Hello World");
    }
}
```

Deberías ver:
- ✅ Mensaje: "☕ Java LSP activado correctamente"
- ✅ Autocompletado al escribir `Sys` y presionar `<Tab>`
- ✅ Errores subrayados en rojo si hay problemas

## 🎯 Probar Funcionalidades

### Autocompletado
1. Escribe `Sys` y presiona `<Tab>` o `<C-Space>`
2. Deberías ver sugerencias de `System`, `SystemProperties`, etc.

### Detección de Errores
1. Escribe `int x = "hola";` (error de tipo)
2. Deberías ver una línea roja bajo el error
3. Presiona `<leader>e` para ver el detalle del error

### Ir a Definición
1. Pon el cursor sobre `println`
2. Presiona `gd` para ir a la definición
3. Presiona `K` para ver la documentación

### Code Actions (Arreglar Errores)
1. Pon el cursor sobre un error
2. Presiona `<leader>ca`
3. Verás opciones para arreglar el error

### Debugging
1. Pon un breakpoint con `<leader>b`
2. Presiona `<C-c>` para iniciar debug
3. Usa `<F10>` para avanzar paso a paso

### Ejecutar Código
1. Guarda el archivo (`:w`)
2. Presiona `<F9>` para compilar y ejecutar

## ❌ Si No Funciona

### Problema 1: "nvim-java not found"
```vim
:Lazy sync
:qa
nvim
```

### Problema 2: "jdtls not found"
```vim
:Mason
# Instala jdtls manualmente
:qa
nvim
```

### Problema 3: No hay autocompletado
```vim
:LspInfo
# Verifica que jdtls esté "attached"
```

Si dice "not attached", reinicia el LSP:
```vim
:LspRestart
```

### Problema 4: Verificar que Java esté instalado
```bash
java --version
javac --version
```

Si no están instalados:
- macOS: `brew install openjdk`
- Linux: `sudo apt install openjdk-17-jdk`

## 📋 Resumen de Atajos

| Atajo | Función |
|-------|---------|
| `gd` | Ir a definición |
| `K` | Ver documentación |
| `<leader>ca` | Code actions (arreglar errores) |
| `<leader>e` | Ver detalles del error |
| `[d` | Error anterior |
| `]d` | Siguiente error |
| `<leader>rn` | Renombrar |
| `<leader>f` | Formatear código |
| `<C-c>` | Iniciar debug |
| `<F9>` | Ejecutar archivo |

## 🎉 ¡Listo!

Si ves el mensaje "☕ Java LSP activado correctamente" cuando abres un archivo .java, **todo está funcionando**.

Prueba escribir código y deberías ver:
- ✅ Autocompletado mientras escribes
- ✅ Errores subrayados en rojo
- ✅ Sugerencias de código con `<leader>ca`
- ✅ Documentación con `K`
