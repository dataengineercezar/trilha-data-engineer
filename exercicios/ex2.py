# Dado este dicionário de vendas por produto:
vendas = [
    {"produto": "A", "quantidade": 10, "preco": 25.0},
    {"produto": "B", "quantidade": 0,  "preco": 15.0},
    {"produto": "C", "quantidade": 5,  "preco": 100.0},
    {"produto": "D", "quantidade": 3,  "preco": 8.50},
    {"produto": "E", "quantidade": 0,  "preco": 200.0},
]

# TAREFA (sem usar loops for explícitos, só comprehensions/map/filter/sum):

# 1. Crie uma lista com o faturamento (quantidade * preco) de cada produto

def calcular_faturamento(dados):
    return [{**item, "faturamento": item["quantidade"] * item["preco"]} for item in dados]

# 2. Filtre apenas os produtos com faturamento > 0

def filtrar_faturamento_positivo(dados):
    # return list(filter(lambda item: item["faturamento"] > 0, dados))
    return [item for item in dados if item["faturamento"] > 0]
# 3. Calcule o faturamento total

def calcular_faturamento_total(dados):
    return sum(map(lambda item: item["faturamento"], dados))

# 4. Retorne o produto com maior faturamento (sem usar sort, use max())

def produto_maior_faturamento(dados):
    return max(dados, key=lambda item: item["faturamento"])

# --- Execução do Pipeline ---
vendas_com_faturamento = calcular_faturamento(vendas)
vendas_filtradas = filtrar_faturamento_positivo(vendas_com_faturamento)
faturamento_total = calcular_faturamento_total(vendas_filtradas)
melhor_produto = produto_maior_faturamento(vendas_filtradas)

# Resultados
print("1. Faturamento por produto:", vendas_com_faturamento)
print("2. Vendas válidas (>0):", vendas_filtradas)
print("3. Faturamento total:", faturamento_total)
print("4. Melhor produto:", melhor_produto)