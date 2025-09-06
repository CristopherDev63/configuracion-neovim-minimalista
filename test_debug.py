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
