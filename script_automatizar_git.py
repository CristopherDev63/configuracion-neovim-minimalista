import os


def Agregar_elementos_area_preparacion():
    os.system("git add .")  # Agrega todos los archivos modificados


def Commit_elementos_area_preparacion():
    if input("De sea agregar un nombre al commit?s/n ").lower() == "s":
        os.system(f'git commit -m "{input("Ingrese el nombre del commit: ")}"')
    else:
        os.system('git commit -m "Cambio de elementos en area de preparacion"')


def push_elementos_area_preparacion():
    os.system("git push")


if __name__ == "__main__":
    Agregar_elementos_area_preparacion()
    Commit_elementos_area_preparacion()
    push_elementos_area_preparacion()
