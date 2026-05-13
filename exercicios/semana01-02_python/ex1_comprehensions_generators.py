numeros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# ── Versão 1: List Comprehension ──────────────────────────────────────────────
# Cria uma lista completa na memória com todos os resultados, depois soma.
# Útil quando você precisa reutilizar a lista depois.
def soma_quadrados_pares_lista(sequencia: list) -> int:
    quadrados = [n ** 2 for n in sequencia if n % 2 == 0]
    return sum(quadrados)

print("Versão 1 - List comprehension:", soma_quadrados_pares_lista(numeros))  # 220


# ── Versão 2: Generator Expression ────────────────────────────────────────────
# Calcula um valor por vez sem criar lista intermediária.
# Mais eficiente em memória — ideal para grandes volumes de dados.
def soma_quadrados_pares_generator(sequencia: list) -> int:
    return sum(n ** 2 for n in sequencia if n % 2 == 0)

print("Versão 2 - Generator expression:", soma_quadrados_pares_generator(numeros))  # 220


# ── Versão 3: Generator Function (com yield) ──────────────────────────────────
# Forma mais explícita de generator: pausa a execução a cada yield,
# entregando um valor por vez para quem consome (ex: sum()).
def quadrados_pares(sequencia: list):
    for n in sequencia:
        if n % 2 == 0:
            yield n ** 2  # pausa aqui, entrega o valor, retoma na próxima chamada

print("Versão 3 - Generator function:", sum(quadrados_pares(numeros)))  # 220


# ── Por que generator usa menos memória? ──────────────────────────────────────
# List comprehension com 1 milhão de números:
#   → cria [4, 16, 36, ...] inteiro na RAM antes de somar
#
# Generator com 1 milhão de números:
#   → calcula 4, passa para sum(), descarta
#   → calcula 16, passa para sum(), descarta  (apenas 1 valor na RAM por vez)
#
# Em pipelines de dados com dezenas de milhões de linhas,
# isso é a diferença entre o processo rodar ou travar o servidor.