import re

def censurar_texto():
    """
    Función principal que solicita datos al usuario y realiza la censura
    de palabras prohibidas en un texto dado.
    """
    print("--- Sistema de Censura de Texto ---")

    # 1. Solicitar el texto original
    texto_original = input("\nIngrese el texto a procesar:\n> ")

    # 2. Solicitar palabras prohibidas y limpiarlas
    input_prohibidas = input("\nIngrese las palabras prohibidas separadas por comas:\n> ")
    # Convertimos el string en una lista, eliminamos espacios y filtramos vacíos
    lista_prohibidas = [palabra.strip() for palabra in input_prohibidas.split(",") if palabra.strip()]

    # Variables para el procesamiento
    texto_censurado = texto_original
    total_censuradas = 0

    # Procesar cada palabra prohibida
    for palabra in lista_prohibidas:
        # Creamos un patrón de expresión regular:
        # \b indica límites de palabra (evita censurar "carne" dentro de "carnicería")
        # re.escape asegura que caracteres especiales en la palabra prohibida no rompan el regex
        patron = rf"\b{re.escape(palabra)}\b"
        
        # Buscamos todas las ocurrencias (ignorando mayúsculas/minúsculas) para contar
        encontrados = re.findall(patron, texto_censurado, flags=re.IGNORECASE)
        total_censuradas += len(encontrados)
        
        # Definimos una función de reemplazo para mantener la longitud original
        # y manejar el caso de las mayúsculas/minúsculas dinámicamente
        def reemplazo(match):
            return "*" * len(match.group(0))

        # Realizamos la sustitución en el texto
        texto_censurado = re.sub(patron, reemplazo, texto_censurado, flags=re.IGNORECASE)

    # 3. Mostrar resultados
    print("\n" + "="*30)
    print("RESULTADOS")
    print("="*30)
    print(f"\nTexto Original:\n{texto_original}")
    print(f"\nTexto Censurado:\n{texto_censurado}")
    print(f"\nTotal de palabras censuradas: {total_censuradas}")
    print("="*30)

if __name__ == "__main__":
    censurar_texto()