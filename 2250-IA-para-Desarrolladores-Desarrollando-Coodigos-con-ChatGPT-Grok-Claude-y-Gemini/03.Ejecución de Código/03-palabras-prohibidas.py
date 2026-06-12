import re

def censurar_contenido(texto):
    """
    Busca palabras prohibidas en un texto y las reemplaza por asteriscos.
    
    Argumentos:
        texto (str): El texto original a procesar.
        
    Retorna:
        str: El texto con las palabras prohibidas censuradas.
    """
    
    # Lista de palabras a filtrar
    palabras_prohibidas = ["carne", "pollo", "huevo", "leche"]
    
    # Creamos una copia del texto para no modificar el original directamente durante la iteración
    texto_censurado = texto
    
    # Procesamos el texto para identificar y reemplazar cada palabra prohibida
    for palabra in palabras_prohibidas:
        # Usamos expresiones regulares con \b (word boundary) para encontrar la palabra exacta
        # re.IGNORECASE permite detectar "Carne", "CARNE" o "carne"
        patron = re.compile(rf'\b{palabra}\b', re.IGNORECASE)
        
        # Función anidada para determinar cuántos asteriscos poner (según la longitud de la palabra encontrada)
        def reemplazar(match):
            return "*" * len(match.group())
        
        # Aplicamos el reemplazo
        texto_censurado = patron.sub(reemplazar, texto_censurado)
        
    return texto_censurado

# --- Ejemplo de uso ---
if __name__ == "__main__":
    texto_original = "Mejor hubieran servido pollo"
    
    resultado = censurar_contenido(texto_original)
    
    print("Texto Original:")
    print(texto_original)
    print("\nTexto Censurado:")
    print(resultado)