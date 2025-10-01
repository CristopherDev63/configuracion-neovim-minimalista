# ☕ Configuración de Java en Neovim

## 📦 Instalación

1. **Reinicia Neovim** para que se instalen los plugins automáticamente
2. **Abre Mason** para verificar la instalación de herramientas:
   ```vim
   :Mason
   ```
3. **Verifica que estén instalados**:
   - ✅ jdtls (Java Language Server)
   - ✅ java-debug-adapter (Debugging)
   - ✅ java-test (Testing)

Si no están instalados, ejecuta:
```vim
:MasonInstall jdtls java-debug-adapter java-test
```

## 🚀 Características

### 1. **Autocompletado Inteligente**
- Autocompletado de clases, métodos y variables
- Snippets de código
- Imports automáticos
- Documentación en hover (presiona `K`)

### 2. **Detección de Errores en Tiempo Real**
- Errores de sintaxis
- Errores de compilación
- Warnings
- Sugerencias de código

### 3. **Debugging Completo**
- Breakpoints
- Step over / Step into / Step out
- Variables en tiempo real
- REPL para evaluar expresiones

## ⌨️ Atajos de Teclado

### LSP (Navegación y Refactoring)
| Atajo | Acción |
|-------|--------|
| `gd` | Ir a definición |
| `gD` | Ir a declaración |
| `gi` | Ir a implementación |
| `gr` | Ver referencias |
| `K` | Ver documentación |
| `<C-k>` | Ver firma de método |
| `<leader>rn` | Renombrar símbolo |
| `<leader>ca` | Code actions |
| `<leader>f` | Formatear código |

### Diagnósticos (Errores)
| Atajo | Acción |
|-------|--------|
| `[d` | Ir al error anterior |
| `]d` | Ir al siguiente error |
| `<leader>e` | Ver detalles del error |

### Java Específico
| Atajo | Acción |
|-------|--------|
| `<leader>jo` | Organizar imports |
| `<leader>jv` | Extraer variable |
| `<leader>jc` | Extraer constante |
| `<leader>jm` | Extraer método (modo visual) |
| `<leader>tc` | Ejecutar tests de clase |
| `<leader>tm` | Ejecutar test del método |

### Debugging
| Atajo | Acción |
|-------|--------|
| `<C-c>` | Iniciar debugging |
| `<leader>b` | Toggle breakpoint |
| `<F5>` | Continuar |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>dt` | Terminar debug |

### Ejecutar Código
| Atajo | Acción |
|-------|--------|
| `<F9>` | Ejecutar archivo Java |

## 💡 Flujo de Trabajo Recomendado

### 1. **Programar con Autocompletado**
```java
public class Main {
    public static void main(String[] args) {
        // Empieza a escribir y presiona <Tab> para autocompletar
        System.out.println("Hello");
    }
}
```

### 2. **Detectar Errores**
- Los errores aparecen automáticamente subrayados
- Presiona `<leader>e` para ver detalles
- Presiona `<leader>ca` para ver soluciones sugeridas

### 3. **Debugging**
```java
public class Main {
    public static void main(String[] args) {
        int x = 5;  // <-- Pon breakpoint con <leader>b
        int y = 10;
        System.out.println(x + y);
    }
}
```

1. Pon breakpoint en la línea deseada (`<leader>b`)
2. Presiona `<C-c>` para iniciar debug
3. Usa `<F10>` para avanzar paso a paso
4. Las variables se muestran en el panel lateral

### 4. **Refactoring**
```java
// Selecciona código y presiona <leader>jm para extraer a método
public void ejemplo() {
    // Selecciona estas líneas
    int suma = a + b;
    System.out.println(suma);
    // Presiona <leader>jm en modo visual
}
```

## 🔧 Solución de Problemas

### El LSP no se inicia
1. Verifica que Java esté instalado: `java --version`
2. Reinstala jdtls: `:MasonUninstall jdtls` y `:MasonInstall jdtls`
3. Reinicia Neovim

### No hay autocompletado
1. Verifica que nvim-cmp esté funcionando
2. Asegúrate de estar en modo INSERT
3. Presiona `<C-Space>` para forzar el autocompletado

### El debugging no funciona
1. Asegúrate de que java-debug-adapter esté instalado
2. Pon un breakpoint antes de iniciar debug
3. Verifica que el archivo se pueda compilar

## 📚 Recursos Adicionales

- [Documentación de jdtls](https://github.com/mfussenegger/nvim-jdtls)
- [Documentación de nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [Ejemplos de Java](https://docs.oracle.com/javase/tutorial/)

## 🎯 Comandos Útiles

```vim
:LspInfo           " Ver información del LSP
:LspRestart        " Reiniciar LSP
:Mason             " Abrir gestor de paquetes
:DapToggleBreakpoint " Toggle breakpoint (alternativa)
```
