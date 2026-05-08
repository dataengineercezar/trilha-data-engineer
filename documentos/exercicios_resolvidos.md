# Guia de Referência Técnica — Trilha Data Engineer
> Exercícios resolvidos + conceitos aprofundados + padrões de produção
> Atualizado progressivamente ao longo da trilha

---

## ÍNDICE

- [PYTHON](#python)
  - [Comprehensions](#comprehensions)
  - [Generators](#generators)
  - [Funções Puras e Imutabilidade](#funções-puras-e-imutabilidade)
  - [Tipos Funcionais: map, filter, reduce](#tipos-funcionais)
  - [Type Hints](#type-hints)
  - [Exercícios Resolvidos — Python](#exercícios-resolvidos--python)
- [SQL](#sql)
  - [Guia de JOINs](#guia-de-joins)
  - [Subqueries](#subqueries)
  - [CTEs (WITH)](#ctes-with)
  - [Window Functions](#window-functions)
  - [Performance e Boas Práticas](#performance-e-boas-práticas)
  - [Exercícios Resolvidos — SQL](#exercícios-resolvidos--sql)
- [PANDAS](#pandas)
  - [Estrutura fundamental: Series e DataFrame](#estrutura-fundamental-series-e-dataframe)
  - [Imutabilidade: assign() vs mutação direta](#imutabilidade-assign-vs-mutação-direta)
  - [Seleção e filtragem: loc, iloc, query, boolean mask](#seleção-e-filtragem-loc-iloc-query-boolean-mask)
  - [groupby e agg](#groupby-e-agg)
  - [Method Chaining](#method-chaining)
  - [Merge e Join entre DataFrames](#merge-e-join-entre-dataframes)
  - [Tipos de dados e otimização de memória](#tipos-de-dados-e-otimização-de-memória)
  - [Exercícios Resolvidos — Pandas](#exercícios-resolvidos--pandas)
- [POLARS](#polars)
  - [Filosofia e diferenças em relação ao Pandas](#filosofia-e-diferenças-em-relação-ao-pandas)
  - [Expressões: pl.col() e o modelo lazy](#expressões-plcol-e-o-modelo-lazy)
  - [with_columns() — adicionar e transformar colunas](#with_columns--adicionar-e-transformar-colunas)
  - [filter() — filtragem com expressões](#filter--filtragem-com-expressões)
  - [group_by().agg() — agregações](#group_byagg--agregações)
  - [over() — window functions](#over--window-functions)
  - [sort() + group_by() — substituto do idxmax](#sort--group_by--substituto-do-idxmax)
  - [Lazy API: scan e collect](#lazy-api-scan-e-collect)
  - [Exercícios Resolvidos — Polars](#exercícios-resolvidos--polars)
- [GIT PROFISSIONAL](#git-profissional)
  - [Configuração inicial](#configuração-inicial)
  - [Criando repositório local](#criando-repositório-local)
  - [.gitignore para Python/Data Engineering](#gitignore-para-pythondata-engineering)
  - [Conventional Commits](#conventional-commits)
  - [Branches: estratégias e comandos](#branches-estratégias-e-comandos)
  - [Rebase vs Merge](#rebase-vs-merge)
  - [git stash](#git-stash)
  - [Tags e Semantic Versioning](#tags-e-semantic-versioning)
  - [Criando repositório remoto no GitHub](#criando-repositório-remoto-no-github)
  - [Exercícios Resolvidos — Git](#exercícios-resolvidos--git)

---

# PYTHON

---

## Comprehensions

Comprehensions são sintaxe compacta para criar coleções. São mais rápidas que loops manuais porque executam em bytecode otimizado do CPython.

### Sintaxe geral
```python
# List comprehension
[expressão for item in iterável if condição]

# Dict comprehension
{chave: valor for item in iterável if condição}

# Set comprehension
{expressão for item in iterável if condição}

# Generator expression (lazy — não cria coleção)
(expressão for item in iterável if condição)
```

### Exemplos progressivos
```python
# ── Nível 1: transformação simples ───────────────────────────
quadrados = [x**2 for x in range(10)]
# [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]

# ── Nível 2: com filtro ───────────────────────────────────────
pares = [x for x in range(10) if x % 2 == 0]
# [0, 2, 4, 6, 8]

# ── Nível 3: transformação + filtro ──────────────────────────
quadrados_pares = [x**2 for x in range(10) if x % 2 == 0]
# [0, 4, 16, 36, 64]

# ── Nível 4: dict comprehension ──────────────────────────────
precos = {"A": 10.0, "B": 0.0, "C": 25.5}
precos_validos = {k: v for k, v in precos.items() if v > 0}
# {"A": 10.0, "C": 25.5}

# ── Nível 5: aninhado (use com moderação — prejudica legibilidade) ──
matriz = [[1,2,3],[4,5,6],[7,8,9]]
planificada = [val for linha in matriz for val in linha]
# [1, 2, 3, 4, 5, 6, 7, 8, 9]

# ── Nível 6: com walrus operator (:=) — Python 3.8+ ──────────
# Calcula e reutiliza resultado dentro da mesma expressão
resultados = [y for x in range(10) if (y := x**2) > 10]
# [16, 25, 36, 49, 64, 81]
```

### Comprehension vs loop manual — performance
```python
import timeit

# Loop manual
def loop_manual(n):
    resultado = []
    for x in range(n):
        if x % 2 == 0:
            resultado.append(x**2)
    return resultado

# List comprehension
def list_comp(n):
    return [x**2 for x in range(n) if x % 2 == 0]

# Comprehension é ~30-50% mais rápida para listas grandes
# porque evita chamadas repetidas de .append() e lookup de atributo
```

---

## Generators

Generators são iteradores que **produzem valores sob demanda** (lazy evaluation). Não armazenam todos os valores na memória.

### Diferença fundamental
```
Lista:     [1, 4, 9, 16, 25]  ← todos na RAM ao mesmo tempo
Generator: 1 → 4 → 9 → 16 → 25  ← um por vez, sob demanda
```

### Generator Expression vs Generator Function
```python
# Generator expression — sintaxe inline
gen_expr = (x**2 for x in range(1_000_000))
# RAM usada: ~200 bytes (independente do tamanho!)

# Lista equivalente
lista = [x**2 for x in range(1_000_000)]
# RAM usada: ~8 MB

# ─────────────────────────────────────────────────────────────
# Generator Function — com yield
def quadrados(n: int):
    for x in range(n):
        yield x**2          # pausa aqui, retorna valor, retoma na próxima chamada

gen_func = quadrados(1_000_000)
next(gen_func)  # 0
next(gen_func)  # 1
next(gen_func)  # 4
# ... consome apenas o necessário
```

### Como o yield funciona internamente
```python
def contador(inicio: int, fim: int):
    print(f"[iniciando de {inicio}]")
    atual = inicio
    while atual <= fim:
        yield atual          # PAUSA: salva estado, entrega valor
        atual += 1           # RETOMA: continua daqui na próxima chamada
    print("[fim do contador]")

gen = contador(1, 3)
print(next(gen))   # [iniciando de 1]  →  1
print(next(gen))   # 2
print(next(gen))   # 3
print(next(gen))   # [fim do contador] → StopIteration
```

### Padrão Pipeline com generators (usado em ETL)
```python
# Generators encadeados processam dados sem criar listas intermediárias
# Análogo ao conceito de streaming em Spark/Kafka

def ler_linhas(arquivo: str):
    """Lê linha por linha — nunca carrega o arquivo inteiro"""
    with open(arquivo) as f:
        yield from f            # yield from delega para outro iterável

def filtrar_vazios(linhas):
    return (linha for linha in linhas if linha.strip())

def transformar(linhas):
    return (linha.strip().upper() for linha in linhas)

# Pipeline: cada linha percorre todo o caminho antes da próxima começar
pipeline = transformar(filtrar_vazios(ler_linhas("dados.txt")))
for linha in pipeline:
    processar(linha)
# Memória usada: O(1) — apenas 1 linha por vez, independente do tamanho do arquivo
```

### Quando usar cada um
```
Use LIST quando:
  ✓ Precisa acessar por índice (lista[5])
  ✓ Precisa do len()
  ✓ Vai iterar múltiplas vezes
  ✓ Volume de dados cabe confortavelmente na RAM

Use GENERATOR quando:
  ✓ Processamento único (iterar uma vez)
  ✓ Volume grande ou desconhecido
  ✓ Pipeline de transformações encadeadas
  ✓ Leitura de arquivos grandes
  ✓ Streams de dados (Kafka, sensores, logs)
```

---

## Funções Puras e Imutabilidade

### O que é uma função pura
```python
# ❌ Função IMPURA — tem side effects (efeitos colaterais)
total = 0
registros = []

def processar(valor):
    global total
    total += valor           # modifica estado externo
    registros.append(valor)  # modifica lista externa
    return valor * 2

# Problemas:
# - Resultado depende do estado global (não previsível)
# - Impossível testar em isolamento
# - Paralelizar quebra (condição de corrida)
# - Em Spark, funções impuras causam resultados não-determinísticos

# ──────────────────────────────────────────────────────────────
# ✅ Função PURA — mesma entrada → sempre mesma saída, sem efeitos
def processar(valor: float, fator: float = 2.0) -> float:
    return valor * fator   # não toca em nada externo

# Benefícios:
# - Testável: assert processar(5) == 10
# - Paralelizável: Spark depende disso para distribuir processamento
# - Compreensível: lê-se como matemática
```

### Imutabilidade em dicionários
```python
registro = {"nome": "João", "idade": 30, "ativo": True}

# ❌ Mutação do original — perigoso em pipelines
def adicionar_categoria(r):
    r["categoria"] = "A"   # modifica o dict original!
    return r

# ✅ Cria novo dict com spread operator
def adicionar_categoria(r: dict) -> dict:
    return {**r, "categoria": "A"}   # r permanece intacto

# ✅ Múltiplas transformações sem mutar
def enriquecer(r: dict) -> dict:
    return {
        **r,
        "categoria": "A" if r["idade"] >= 18 else "B",
        "processado_em": "2026-05-07",
    }

# Padrão análogo ao withColumn() do Spark:
# df.withColumn("nova_col", F.lit("valor"))  # não muta o DataFrame original
```

### Por que isso importa em Data Engineering
```
Em Spark, cada transformação cria um NOVO DataFrame (imutável por design).
Funções passadas para .map(), .filter(), .withColumn() DEVEM ser puras.
Funções impuras em Spark causam:
  - Resultados diferentes a cada execução
  - Bugs que só aparecem em produção (com dados reais, distribuídos)
  - Problemas de checkpointing e recovery
```

---

## Tipos Funcionais

### map — transforma cada elemento
```python
numeros = [1, 2, 3, 4, 5]

# map retorna um iterator (lazy) — não cria lista imediatamente
dobrados = map(lambda x: x * 2, numeros)

# Consumir com list() ou sum() ou for
list(dobrados)    # [2, 4, 6, 8, 10]

# Na prática, prefira list comprehension — mais legível
dobrados = [x * 2 for x in numeros]

# Quando map se justifica: funções já existentes (sem lambda)
nomes = ["joão", "maria", "pedro"]
maiusculos = list(map(str.upper, nomes))   # sem lambda, limpo
```

### filter — seleciona elementos
```python
dados = [1, 0, None, "texto", [], 42, False]

# Remover falsy values
validos = list(filter(None, dados))   # [1, "texto", 42]

# Com função customizada
pedidos = [{"valor": 100}, {"valor": 0}, {"valor": 250}]
ativos = list(filter(lambda p: p["valor"] > 0, pedidos))
# Prefira: [p for p in pedidos if p["valor"] > 0]
```

### reduce — acumula em um único valor
```python
from functools import reduce

numeros = [1, 2, 3, 4, 5]

# Soma acumulada (use sum() para isso na prática)
total = reduce(lambda acc, x: acc + x, numeros)  # 15

# Caso real: merge de múltiplos dicts
dicts = [{"a": 1}, {"b": 2}, {"c": 3}]
merged = reduce(lambda acc, d: {**acc, **d}, dicts)
# {"a": 1, "b": 2, "c": 3}
```

### Composição funcional
```python
from functools import reduce
from typing import Callable

# Compor funções: f(g(h(x)))
def compor(*funcs: Callable) -> Callable:
    return reduce(lambda f, g: lambda x: g(f(x)), funcs)

# Pipeline de transformações de dados
limpar     = lambda s: s.strip()
normalizar = lambda s: s.lower()
remover_acento = lambda s: s.replace("ã", "a").replace("ç", "c")

normalizar_nome = compor(limpar, normalizar, remover_acento)
normalizar_nome("  João  ")   # "joao"
```

---

## Type Hints

Type hints não mudam o comportamento do código em runtime, mas são essenciais em código de produção: documentam contratos, habilitam linters e IDEs.

```python
from typing import Optional, Union
from collections.abc import Iterator, Generator, Callable

# Tipos básicos
def somar(a: int, b: int) -> int:
    return a + b

# Listas e dicionários
def processar(dados: list[dict]) -> list[dict]:
    return [{**d, "processado": True} for d in dados]

# Optional — pode ser None
def buscar_usuario(id: int) -> Optional[dict]:
    ...   # retorna dict ou None

# Union — múltiplos tipos aceitos
def converter(valor: Union[str, int, float]) -> float:
    return float(valor)

# Generator
def ler_arquivo(path: str) -> Generator[str, None, None]:
    with open(path) as f:
        yield from f

# Callable
def aplicar(func: Callable[[int], int], valor: int) -> int:
    return func(valor)

# TypedDict — para dicionários com estrutura conhecida (padrão em DE)
from typing import TypedDict

class Venda(TypedDict):
    produto: str
    quantidade: int
    preco: float

def calcular_faturamento(venda: Venda) -> float:
    return venda["quantidade"] * venda["preco"]
```

---

## Exercícios Resolvidos — Python

### Ex1 — List Comprehension, Generators e Funções Puras

**Enunciado:** Dado um código que soma os quadrados dos números pares de 1 a 10, reescreva usando list comprehension, generator expression e generator function. Explique qual usa menos memória.

```python
numeros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# Versão 1 — List Comprehension
def soma_quadrados_pares_lista(sequencia: list[int]) -> int:
    quadrados = [n ** 2 for n in sequencia if n % 2 == 0]
    return sum(quadrados)

# Versão 2 — Generator Expression
def soma_quadrados_pares_generator(sequencia: list[int]) -> int:
    return sum(n ** 2 for n in sequencia if n % 2 == 0)

# Versão 3 — Generator Function
def quadrados_pares(sequencia: list[int]) -> Generator[int, None, None]:
    for n in sequencia:
        if n % 2 == 0:
            yield n ** 2

print(soma_quadrados_pares_lista(numeros))      # 220
print(soma_quadrados_pares_generator(numeros))  # 220
print(sum(quadrados_pares(numeros)))            # 220
```

**Resposta — memória:**
```
List comprehension:  cria [4, 16, 36, 64, 100] completo na RAM → soma
Generator expression: 4 → sum parcial → descarta → 16 → sum parcial → descarta
                      Apenas 1 inteiro na RAM por vez

Para 1 milhão de números pares:
  Lista:     ~8 MB de RAM
  Generator: ~200 bytes (tamanho fixo, independente do volume)
```

**Anti-pattern original e por que é problemático:**
```python
# ❌ O que NÃO fazer
pares = []           # variável global mutável
def definir_pares(numeros):
    for n in numeros:
        if n % 2 == 0:
            pares.append(n * n)   # side effect: modifica estado externo

# Problemas em Data Engineering:
# 1. Em Spark, cada executor tem sua cópia de memória — pares ficaria vazio em workers remotos
# 2. Impossível testar: resultado depende do estado de pares antes da chamada
# 3. Chamadas concorrentes corrompem a lista
```

---

### Ex2 — Funções Puras, Comprehensions, map/filter/max

**Enunciado:** Dado uma lista de dicts de vendas, sem loops for explícitos: calcule faturamento, filtre positivos, some o total, retorne o maior.

```python
vendas = [
    {"produto": "A", "quantidade": 10, "preco": 25.0},
    {"produto": "B", "quantidade": 0,  "preco": 15.0},
    {"produto": "C", "quantidade": 5,  "preco": 100.0},
    {"produto": "D", "quantidade": 3,  "preco": 8.50},
    {"produto": "E", "quantidade": 0,  "preco": 200.0},
]

def calcular_faturamento(dados: list[dict]) -> list[dict]:
    # {**item, key: val} — cria NOVO dict, não muta o original
    return [{**item, "faturamento": item["quantidade"] * item["preco"]} for item in dados]

def filtrar_faturamento_positivo(dados: list[dict]) -> list[dict]:
    # List comprehension com condição — mais Pythônico que filter+lambda
    return [item for item in dados if item["faturamento"] > 0]

def calcular_faturamento_total(dados: list[dict]) -> float:
    # map() retorna iterator lazy → sum() consome 1 valor por vez
    return sum(map(lambda item: item["faturamento"], dados))
    # Alternativa idiomática: sum(item["faturamento"] for item in dados)

def produto_maior_faturamento(dados: list[dict]) -> dict:
    # max() com key= é O(n) — nunca ordene só para pegar o maior (O(n log n))
    return max(dados, key=lambda item: item["faturamento"])

# Pipeline de execução — cada função pura, resultado imutável entre etapas
vendas_com_fat = calcular_faturamento(vendas)
vendas_validas = filtrar_faturamento_positivo(vendas_com_fat)
total          = calcular_faturamento_total(vendas_validas)
melhor         = produto_maior_faturamento(vendas_validas)

# Resultados:
# total  = 775.50
# melhor = {"produto": "C", "quantidade": 5, "preco": 100.0, "faturamento": 500.0}
```

**Comparação de complexidade:**
```
max() com key=  → O(n)       — percorre 1 vez
sorted()[0]     → O(n log n) — ordena tudo para pegar só o primeiro
→ Para listas grandes (milhões de produtos), a diferença é brutal
```

---

# SQL

---

## Guia de JOINs

### Mapa visual de todos os JOINs
```
Tabela A: [1, 2, 3]     Tabela B: [2, 3, 4]

INNER JOIN     → [2, 3]              (interseção)
LEFT JOIN      → [1, 2, 3]           (todos da esquerda)
RIGHT JOIN     → [2, 3, 4]           (todos da direita)
FULL OUTER     → [1, 2, 3, 4]        (todos de ambos)
CROSS JOIN     → [1×2, 1×3, 1×4,     (produto cartesiano)
                  2×2, 2×3 ...]
```

### INNER JOIN — apenas correspondências
```sql
-- Retorna apenas linhas que existem em AMBAS as tabelas
SELECT c.nome, p.data_pedido, p.status
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente;

-- Clientes sem pedidos: NÃO aparecem
-- Pedidos sem cliente: impossível (FK NOT NULL), mas se possível, NÃO apareceriam
```

### LEFT JOIN — todos da esquerda, match ou NULL
```sql
-- Todos os clientes, mesmo sem pedidos
SELECT c.nome, COUNT(p.id_pedido) AS total_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nome;

-- Cliente sem pedido → p.id_pedido = NULL → COUNT(p.id_pedido) = 0
-- COUNT(*) contaria 1 mesmo com NULL — sempre use COUNT(coluna_da_direita)
```

### A regra crítica: ON vs WHERE com LEFT JOIN
```sql
-- CENÁRIO: vendedores e quantas entregas cada um fez

-- ❌ ERRADO — filtro de negócio no WHERE após LEFT JOIN
SELECT v.nome, COUNT(p.id_pedido) AS entregas
FROM vendedores v
LEFT JOIN pedidos p ON v.id_vendedor = p.id_vendedor
WHERE p.status = 'entregue'   -- elimina os NULLs → vendedores sem entrega somem
GROUP BY v.nome;
-- Elena Martins desaparece!

-- ✅ CORRETO — filtro no ON preserva as linhas NULL da esquerda
SELECT v.nome, COUNT(p.id_pedido) AS entregas
FROM vendedores v
LEFT JOIN pedidos p
    ON v.id_vendedor = p.id_vendedor
    AND p.status = 'entregue'   -- aplicado DURANTE o join, antes de gerar NULLs
GROUP BY v.id_vendedor, v.nome;
-- Elena Martins aparece com 0

-- REGRA:
-- ON  → condição de join + filtros da tabela DIREITA quando quer preservar esquerda
-- WHERE → filtros da tabela ESQUERDA ou condições pós-join
```

### FULL OUTER JOIN — todos de ambos os lados
```sql
-- Útil para reconciliação de dados entre sistemas
SELECT
    COALESCE(a.id, b.id)    AS id,
    a.valor                  AS valor_sistema_a,
    b.valor                  AS valor_sistema_b,
    CASE
        WHEN a.id IS NULL THEN 'Só no B'
        WHEN b.id IS NULL THEN 'Só no A'
        ELSE 'Em ambos'
    END AS status_reconciliacao
FROM sistema_a a
FULL OUTER JOIN sistema_b b ON a.id = b.id;
```

### CROSS JOIN — produto cartesiano
```sql
-- Caso 1: combinações de dimensões para matriz completa
SELECT d.data, p.produto
FROM dimensao_datas d
CROSS JOIN dimensao_produtos p;
-- Gera todas as combinações possíveis (útil para detectar gaps)

-- Caso 2: CTE com 1 linha (escalar compartilhado)
WITH media AS (SELECT AVG(valor) AS media_geral FROM vendas)
SELECT v.*, v.valor / mg.media_geral AS indice_vs_media
FROM vendas v
CROSS JOIN media mg;  -- 1 linha × N linhas = N linhas com o escalar disponível
```

### SELF JOIN — tabela com ela mesma
```sql
-- Hierarquia: funcionário e seu gerente (mesma tabela)
SELECT
    f.nome          AS funcionario,
    g.nome          AS gerente
FROM funcionarios f
LEFT JOIN funcionarios g ON f.id_gerente = g.id_funcionario;

-- Comparar pedidos consecutivos do mesmo cliente
SELECT
    a.id_pedido,
    a.data_pedido       AS data_atual,
    b.data_pedido       AS data_anterior,
    a.data_pedido - b.data_pedido AS dias_entre_pedidos
FROM pedidos a
LEFT JOIN pedidos b
    ON a.id_cliente = b.id_cliente
    AND b.data_pedido = (
        SELECT MAX(data_pedido)
        FROM pedidos
        WHERE id_cliente = a.id_cliente
          AND data_pedido < a.data_pedido
    );
```

---

## Subqueries

### Tipos de subqueries por posição
```sql
-- 1. No SELECT (scalar subquery) — retorna 1 valor
SELECT
    nome,
    valor,
    (SELECT AVG(valor) FROM vendas) AS media_geral,   -- ← scalar
    valor - (SELECT AVG(valor) FROM vendas) AS desvio_da_media
FROM vendas;

-- 2. No FROM (derived table) — retorna uma tabela
SELECT sub.vendedor, sub.total
FROM (
    SELECT id_vendedor, SUM(valor) AS total
    FROM pedidos
    GROUP BY id_vendedor
) sub   -- ← obrigatório ter alias
WHERE sub.total > 5000;

-- 3. No WHERE com IN — filtragem por lista
SELECT nome FROM clientes
WHERE id_cliente IN (
    SELECT DISTINCT id_cliente FROM pedidos WHERE status = 'entregue'
);

-- 4. No WHERE com EXISTS — mais eficiente que IN para listas grandes
SELECT nome FROM clientes c
WHERE EXISTS (
    SELECT 1 FROM pedidos p   -- SELECT 1 é convencional (não precisa de coluna real)
    WHERE p.id_cliente = c.id_cliente
      AND p.status = 'entregue'
);

-- IN vs EXISTS:
-- IN: executa subquery, cria lista, compara cada linha → O(n×m)
-- EXISTS: para na primeira correspondência → mais eficiente para subqueries grandes

-- 5. Correlacionada — referencia a query externa
SELECT c.nome,
    (SELECT COUNT(*) FROM pedidos p WHERE p.id_cliente = c.id_cliente) AS total_pedidos
FROM clientes c;
-- Cuidado: executa 1 vez por linha da query externa — pode ser lento!
-- Para grandes volumes, prefira JOIN + GROUP BY
```

### Subquery vs JOIN — quando usar cada um
```sql
-- SUBQUERY é mais clara quando:
-- - A relação é 1:1 ou você precisa de um escalar
-- - Filtragem simples (IN/EXISTS)

-- JOIN é mais eficiente quando:
-- - Você precisa de colunas de ambas as tabelas
-- - Grandes volumes (o otimizador lida melhor)

-- ❌ Subquery correlacionada em SELECT para cada linha (N+1 problem)
SELECT c.nome, (SELECT COUNT(*) FROM pedidos WHERE id_cliente = c.id_cliente)
FROM clientes c;  -- executa 1 subquery por cliente

-- ✅ Equivalente com JOIN — 1 passagem só
SELECT c.nome, COUNT(p.id_pedido) AS total
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nome;
```

---

## CTEs (WITH)

CTEs tornam queries complexas legíveis ao nomear etapas intermediárias.

### Sintaxe e regras
```sql
WITH
    nome_cte_1 AS (
        SELECT ...   -- primeira etapa
    ),
    nome_cte_2 AS (
        SELECT ... FROM nome_cte_1   -- pode referenciar CTEs anteriores
    )
-- Query principal — obrigatória após o WITH
SELECT * FROM nome_cte_2;

-- Regras:
-- 1. Vírgula entre CTEs, NÃO após a última
-- 2. A query principal vem depois de todas as CTEs
-- 3. CTEs só existem durante a execução da query (não persistem)
-- 4. No PostgreSQL, CTEs são "optimization fences" — PostgreSQL as materializa
--    separadamente, o que pode ser mais lento que subqueries em alguns casos
```

### CTE vs Subquery vs View — quando usar
```
CTE     → Query ad-hoc complexa que precisa de legibilidade. Reutilização dentro da mesma query.
Subquery → Transformação simples, usada uma única vez, em contexto óbvio.
View     → Transformação reutilizada em múltiplas queries. Semanticamente é uma "tabela virtual".
```

### Padrão: CTE para decompor problemas
```sql
-- Problema: clientes cujo gasto está acima da média, com seu ranking

WITH
    -- Etapa 1: calcular gasto total por cliente
    gasto_por_cliente AS (
        SELECT
            id_cliente,
            SUM(valor_liquido) AS total_gasto
        FROM vw_faturamento_pedidos
        WHERE status = 'entregue'
        GROUP BY id_cliente
    ),
    -- Etapa 2: calcular a média geral (1 linha)
    media_geral AS (
        SELECT AVG(total_gasto) AS media
        FROM gasto_por_cliente
    ),
    -- Etapa 3: clientes acima da média com ranking
    clientes_premium AS (
        SELECT
            g.id_cliente,
            g.total_gasto,
            RANK() OVER(ORDER BY g.total_gasto DESC) AS ranking
        FROM gasto_por_cliente g
        CROSS JOIN media_geral m
        WHERE g.total_gasto > m.media
    )
-- Query principal: juntar com nomes
SELECT
    c.nome,
    c.estado,
    cp.total_gasto,
    cp.ranking
FROM clientes c
INNER JOIN clientes_premium cp ON c.id_cliente = cp.id_cliente
ORDER BY cp.ranking;
```

### CTE Recursiva — hierarquias e grafos
```sql
-- Expandir hierarquia de categorias (pai → filho → neto...)
WITH RECURSIVE hierarquia AS (
    -- Âncora: ponto de partida (raiz)
    SELECT id, nome, id_pai, 1 AS nivel
    FROM categorias
    WHERE id_pai IS NULL

    UNION ALL

    -- Passo recursivo: filhos de cada nó já encontrado
    SELECT c.id, c.nome, c.id_pai, h.nivel + 1
    FROM categorias c
    INNER JOIN hierarquia h ON c.id_pai = h.id
)
SELECT nivel, REPEAT('  ', nivel - 1) || nome AS arvore
FROM hierarquia
ORDER BY nivel, nome;

-- Resultado:
-- Eletrônicos
--   Computadores
--     Notebooks
--     Desktops
--   Celulares
```

---

## Window Functions

Window Functions calculam valores **por grupo sem colapsar linhas** — o SELECT mantém todas as linhas originais.

### Anatomia completa
```sql
FUNÇÃO(coluna) OVER (
    PARTITION BY col_grupo    -- "reinicia" a janela para cada grupo (como GROUP BY mas sem colapsar)
    ORDER BY col_ordem        -- ordena dentro de cada partição
    ROWS BETWEEN              -- define o frame (janela móvel)
        UNBOUNDED PRECEDING   -- desde o início da partição
        AND CURRENT ROW       -- até a linha atual
)

-- Frames disponíveis:
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW   -- acumulado do início até a linha atual
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW           -- últimas 3 linhas (sliding window)
ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING   -- da linha atual até o fim
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING  -- toda a partição (default sem ORDER BY)
```

### Funções de Ranking
```sql
SELECT
    nome,
    departamento,
    salario,

    -- ROW_NUMBER: numeração única, sem empates (1,2,3,4,5)
    ROW_NUMBER() OVER(PARTITION BY departamento ORDER BY salario DESC) AS row_num,

    -- RANK: empates recebem mesmo número, pula o próximo (1,2,2,4,5)
    RANK() OVER(PARTITION BY departamento ORDER BY salario DESC) AS rank,

    -- DENSE_RANK: empates recebem mesmo número, NÃO pula (1,2,2,3,4)
    DENSE_RANK() OVER(PARTITION BY departamento ORDER BY salario DESC) AS dense_rank,

    -- NTILE(n): divide em n grupos aproximadamente iguais
    NTILE(4) OVER(PARTITION BY departamento ORDER BY salario DESC) AS quartil

FROM funcionarios;

-- Quando usar cada um:
-- ROW_NUMBER → deduplicação, pegar o N-ésimo registro por grupo
-- RANK       → rankings oficiais (1º, 2º empatados, 4º)
-- DENSE_RANK → rankings sem gaps (1º, 2º empatados, 3º)
-- NTILE      → segmentação (top 25%, bottom 25%)
```

### Padrão clássico: pegar o registro mais recente por grupo
```sql
-- "Para cada cliente, traga apenas o pedido mais recente"
WITH pedidos_rankeados AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY id_cliente
            ORDER BY data_pedido DESC
        ) AS rn
    FROM pedidos
    WHERE status = 'entregue'
)
SELECT * FROM pedidos_rankeados WHERE rn = 1;

-- Este padrão aparece em TODA entrevista de DE. Decore-o.
```

### Funções de deslocamento (LAG/LEAD)
```sql
SELECT
    id_vendedor,
    data_pedido,
    valor_liquido,

    -- LAG: valor da linha ANTERIOR na janela
    LAG(valor_liquido, 1, 0) OVER(         -- (coluna, offset, default_se_null)
        PARTITION BY id_vendedor
        ORDER BY data_pedido
    ) AS valor_anterior,

    -- LEAD: valor da linha SEGUINTE na janela
    LEAD(valor_liquido, 1, 0) OVER(
        PARTITION BY id_vendedor
        ORDER BY data_pedido
    ) AS proximo_valor,

    -- Variação percentual em relação ao anterior
    ROUND(
        (valor_liquido - LAG(valor_liquido) OVER(
            PARTITION BY id_vendedor ORDER BY data_pedido
        )) / NULLIF(LAG(valor_liquido) OVER(
            PARTITION BY id_vendedor ORDER BY data_pedido
        ), 0) * 100,
    2) AS variacao_pct

FROM vw_faturamento_pedidos
WHERE status = 'entregue';

-- NULLIF(expr, 0): evita divisão por zero → retorna NULL em vez de erro
```

### Funções de agregação como window
```sql
SELECT
    c.nome,
    vw.data_pedido,
    vw.valor_liquido,

    -- Soma acumulada no tempo (running total)
    SUM(vw.valor_liquido) OVER(
        PARTITION BY vw.id_cliente
        ORDER BY vw.data_pedido
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS gasto_acumulado,

    -- Total da partição inteira (sem ORDER BY no OVER = sem frame)
    SUM(vw.valor_liquido) OVER(PARTITION BY vw.id_cliente) AS total_cliente,

    -- Percentual do pedido no total do cliente
    ROUND(vw.valor_liquido /
        SUM(vw.valor_liquido) OVER(PARTITION BY vw.id_cliente) * 100, 2
    ) AS pct_total,

    -- Média móvel das últimas 3 entregas
    ROUND(AVG(vw.valor_liquido) OVER(
        PARTITION BY vw.id_cliente
        ORDER BY vw.data_pedido
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS media_movel_3

FROM vw_faturamento_pedidos vw
INNER JOIN clientes c ON vw.id_cliente = c.id_cliente
WHERE vw.status = 'entregue';
```

### FIRST_VALUE / LAST_VALUE / NTH_VALUE
```sql
SELECT
    id_cliente,
    data_pedido,
    valor_liquido,

    -- Primeiro pedido do cliente (historicamente)
    FIRST_VALUE(valor_liquido) OVER(
        PARTITION BY id_cliente
        ORDER BY data_pedido
    ) AS primeiro_pedido,

    -- Maior pedido já feito pelo cliente
    MAX(valor_liquido) OVER(PARTITION BY id_cliente) AS maior_pedido,

    -- Segundo maior pedido do cliente
    NTH_VALUE(valor_liquido, 2) OVER(
        PARTITION BY id_cliente
        ORDER BY valor_liquido DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS segundo_maior

FROM vw_faturamento_pedidos
WHERE status = 'entregue';
```

---

## Performance e Boas Práticas

### Ordem de execução do SQL (diferente da ordem de escrita!)
```
1. FROM + JOINs       → monta o conjunto de dados
2. WHERE              → filtra linhas (antes de agrupar)
3. GROUP BY           → agrupa
4. HAVING             → filtra grupos
5. SELECT             → projeta colunas (window functions aqui)
6. DISTINCT           → remove duplicatas
7. ORDER BY           → ordena
8. LIMIT / OFFSET     → pagina

Por isso:
- Não pode usar alias do SELECT no WHERE (ainda não foi calculado)
- Pode usar alias do SELECT no ORDER BY (já foi calculado)
- HAVING filtra DEPOIS de GROUP BY (WHERE não acessa agregações)
```

### WHERE vs HAVING
```sql
-- WHERE filtra linhas ANTES do GROUP BY (mais eficiente — reduz volume antes de agrupar)
SELECT id_vendedor, SUM(valor_liquido) AS total
FROM vw_faturamento_pedidos
WHERE status = 'entregue'          -- ← filtra antes de agrupar
GROUP BY id_vendedor
HAVING SUM(valor_liquido) > 5000;  -- ← filtra grupos depois de agrupar

-- ❌ ERRADO — não pode usar WHERE em agregações
WHERE SUM(valor_liquido) > 5000    -- erro: aggregates not allowed in WHERE
```

### Dicas de performance para Data Engineering
```sql
-- 1. Filtre cedo — quanto antes, menos dados percorrem o pipeline
-- ❌ Junta tudo, depois filtra
SELECT * FROM tabela_grande a JOIN tabela_grande b ON ...
WHERE a.data >= '2024-01-01';

-- ✅ Filtra antes de juntar
WITH dados_recentes AS (
    SELECT * FROM tabela_grande WHERE data >= '2024-01-01'
)
SELECT * FROM dados_recentes a JOIN tabela_grande b ON ...;

-- 2. Use EXISTS em vez de IN para subqueries grandes
-- EXISTS para na primeira correspondência → mais rápido

-- 3. Evite funções em colunas indexadas no WHERE
-- ❌ Inviabiliza uso do índice
WHERE EXTRACT(YEAR FROM data_pedido) = 2024
-- ✅ Permite uso do índice
WHERE data_pedido BETWEEN '2024-01-01' AND '2024-12-31'

-- 4. COUNT(*) vs COUNT(coluna)
-- COUNT(*): conta todas as linhas incluindo NULLs
-- COUNT(coluna): conta apenas valores não-NULL
-- Para verificar existência, prefira EXISTS — para na primeira linha

-- 5. EXPLAIN ANALYZE — ver o plano de execução real
EXPLAIN ANALYZE
SELECT c.nome, COUNT(p.id_pedido)
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nome;
-- Mostra: Seq Scan vs Index Scan, custo estimado vs real, linhas reais
```

### Estrutura padrão de uma query analítica completa
```sql
-- Template comentado para queries de produção
SELECT
    -- dimensões (o que estamos analisando)
    c.nome          AS cliente,
    c.estado,
    -- métricas (o que estamos medindo)
    COUNT(p.id_pedido)                               AS total_pedidos,
    ROUND(SUM(f.valor_liquido), 2)                   AS receita_total,
    ROUND(AVG(f.valor_liquido), 2)                   AS ticket_medio,
    -- window function (contexto relativo)
    RANK() OVER(ORDER BY SUM(f.valor_liquido) DESC)  AS ranking_receita

FROM clientes c

-- tabela principal vem no FROM, demais no JOIN
LEFT JOIN pedidos p
    ON c.id_cliente = p.id_cliente
    AND p.status = 'entregue'           -- filtro da tabela direita no ON (LEFT JOIN)
LEFT JOIN vw_faturamento_pedidos f
    ON p.id_pedido = f.id_pedido

-- filtros da tabela esquerda ou condições pós-join
WHERE c.criado_em >= '2023-01-01'

GROUP BY
    c.id_cliente,   -- sempre inclua a PK se incluir outras colunas da mesma tabela
    c.nome,
    c.estado

HAVING COUNT(p.id_pedido) > 0           -- filtro de grupo (pós-agregação)

ORDER BY receita_total DESC NULLS LAST  -- NULLS LAST: NULLs no final (não no topo)

LIMIT 20;
```

---

## Exercícios Resolvidos — SQL

### Ex SQL-1 — JOINs com contexto de negócio

**Pergunta 1:** Pedidos entregues, do mais recente ao mais antigo.
```sql
SELECT
    c.nome          AS cliente,
    p.data_pedido,
    p.status
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.status = 'entregue'
ORDER BY p.data_pedido DESC;
```
```
cliente          | data_pedido | status
-----------------+-------------+---------
Lucia Alves      | 2024-09-01  | entregue
Beatriz Santos   | 2024-08-08  | entregue
Roberto Nunes    | 2024-07-20  | entregue
João Silva       | 2024-07-04  | entregue
...              (16 linhas)
```

---

**Pergunta 2:** Todos os vendedores com total de entregas (zeros incluídos).
```sql
SELECT
    v.nome                  AS vendedor,
    COUNT(p.id_pedido)      AS total_entregas
FROM vendedores v
LEFT JOIN pedidos p
    ON v.id_vendedor = p.id_vendedor
    AND p.status = 'entregue'   -- no ON, não no WHERE
GROUP BY v.id_vendedor, v.nome
ORDER BY total_entregas DESC;
```
```
vendedor         | total_entregas
-----------------+---------------
Bruno Melo       | 7
Carla Souza      | 3
Ana Lima         | 3
Diego Ferreira   | 2
Elena Martins    | 0             ← preservada pelo LEFT JOIN + filtro no ON
```

---

**Pergunta 3:** Top 5 produtos por quantidade em pedidos entregues.
```sql
SELECT
    pr.nome                                      AS produto,
    pr.categoria,
    SUM(ip.quantidade)                           AS quantidade_total,
    ROUND(SUM(ip.quantidade * ip.preco_unit), 2) AS receita_total
FROM produtos pr
INNER JOIN itens_pedido ip ON pr.id_produto = ip.id_produto
INNER JOIN pedidos p       ON ip.id_pedido = p.id_pedido
WHERE p.status = 'entregue'
GROUP BY pr.id_produto, pr.nome, pr.categoria
ORDER BY quantidade_total DESC
LIMIT 5;
```
```
produto          | categoria   | qtd | receita
-----------------+-------------+-----+---------
Mouse Sem Fio    | Periféricos |  7  |  629.30
Desk Pad XL      | Acessórios  |  5  |  425.00
SSD 1TB NVMe     | Componentes |  5  | 1900.00
Notebook Pro 15  | Eletrônicos |  5  | 22500.00
Headset Gamer    | Periféricos |  4  | 1800.00
```
⚠️ Ponto de atenção: `LIMIT 5` foi omitido na primeira tentativa — retornou 12 produtos.

---

### Ex SQL-2 — Subqueries e CTEs

**Pergunta 1:** Clientes com mais de 1 pedido.
```sql
SELECT
    c.nome, c.estado,
    COUNT(p.id_pedido) AS total_pedidos
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE c.id_cliente IN (
    SELECT id_cliente          -- ✅ sem alias externo
    FROM pedidos
    GROUP BY id_cliente
    HAVING COUNT(id_pedido) > 1
)
GROUP BY c.nome, c.estado
ORDER BY total_pedidos DESC;
```
```
cliente          | estado | total_pedidos
-----------------+--------+--------------
João Silva       | SP     | 3
Roberto Nunes    | BA     | 2
Beatriz Santos   | RS     | 2
Maria Oliveira   | RJ     | 2
Lucia Alves      | PR     | 2
Patrícia Gomes   | DF     | 2
Pedro Costa      | MG     | 2
```
⚠️ Bug detectado e corrigido: alias externo `c` vazando para dentro da subquery causava agrupamento incorreto.

---

**Pergunta 2:** Ticket médio por vendedor.
```sql
SELECT
    v.nome                     AS vendedor,
    sub.total_pedidos_entregues,
    ROUND(sub.ticket_medio, 2) AS ticket_medio
FROM vendedores v
INNER JOIN (
    SELECT id_vendedor,
           COUNT(id_pedido)   AS total_pedidos_entregues,
           AVG(valor_liquido) AS ticket_medio
    FROM vw_faturamento_pedidos
    WHERE status = 'entregue'
    GROUP BY id_vendedor
) sub ON v.id_vendedor = sub.id_vendedor
ORDER BY ticket_medio DESC;
```
```
vendedor         | total_entregues | ticket_medio
-----------------+-----------------+--------------
Bruno Melo       | 7               | 3169.98
Diego Ferreira   | 2               | 2681.50
Ana Lima         | 3               | 1217.03
Carla Souza      | 3               |  726.85
```

---

**Pergunta 3:** Clientes com gasto acima da média (2 CTEs + CROSS JOIN).
```sql
WITH TotalPorCliente AS (
    SELECT id_cliente, SUM(valor_liquido) AS total_gasto
    FROM vw_faturamento_pedidos
    GROUP BY id_cliente
),
MediaGeral AS (
    SELECT AVG(total_gasto) AS media_gasto
    FROM TotalPorCliente
)
SELECT
    c.nome, c.estado,
    ROUND(tpc.total_gasto, 2) AS total_gasto
FROM clientes c
INNER JOIN TotalPorCliente tpc ON c.id_cliente = tpc.id_cliente
CROSS JOIN MediaGeral mg
WHERE tpc.total_gasto > mg.media_gasto
ORDER BY tpc.total_gasto DESC;
```
```
nome             | estado | total_gasto
-----------------+--------+------------
Beatriz Santos   | RS     | 11290.00
Pedro Costa      | MG     |  6534.00
Maria Oliveira   | RJ     |  6300.00
João Silva       | SP     |  6074.85
Patrícia Gomes   | DF     |  4825.00
```

---

### Ex SQL-3 — Window Functions

**Pergunta 1:** Ranking de pedidos por valor dentro de cada cliente.
```sql
SELECT
    c.nome AS cliente,
    vw.data_pedido,
    vw.valor_liquido,
    ROW_NUMBER() OVER(
        PARTITION BY c.id_cliente
        ORDER BY vw.valor_liquido DESC
    ) AS ranking_pedido
FROM vw_faturamento_pedidos vw
INNER JOIN clientes c ON vw.id_cliente = c.id_cliente
WHERE vw.status = 'entregue';
```
```
cliente          | data_pedido | valor_liquido | ranking
-----------------+-------------+---------------+---------
João Silva       | 2024-01-10  |   4679.80     | 1
João Silva       | 2024-07-04  |    940.00     | 2
João Silva       | 2024-03-05  |    455.05     | 3
Maria Oliveira   | 2024-06-01  |   4500.00     | 1
Maria Oliveira   | 2024-01-22  |   1800.00     | 2
...
```

---

**Pergunta 2:** LAG — variação de pedido a pedido para Bruno Melo.
```sql
SELECT
    vw.data_pedido,
    vw.valor_liquido,
    LAG(vw.valor_liquido) OVER(
        PARTITION BY vw.id_vendedor    -- ✅ PARTITION BY mesmo com WHERE
        ORDER BY vw.data_pedido
    ) AS valor_anterior,
    vw.valor_liquido - LAG(vw.valor_liquido) OVER(
        PARTITION BY vw.id_vendedor
        ORDER BY vw.data_pedido
    ) AS diferenca
FROM vw_faturamento_pedidos vw
INNER JOIN vendedores v ON vw.id_vendedor = v.id_vendedor
WHERE vw.status = 'entregue' AND v.nome = 'Bruno Melo'
ORDER BY vw.data_pedido;
```
```
data_pedido | valor_liquido | valor_anterior | diferenca
------------+---------------+----------------+-----------
2024-01-10  |   4679.80     | NULL           | NULL
2024-03-05  |    455.05     | 4679.80        | -4224.75
2024-04-15  |  10800.00     |  455.05        | 10344.95
2024-05-03  |    325.00     | 10800.00       | -10475.00
2024-06-01  |   4500.00     |  325.00        |  4175.00
2024-07-04  |    940.00     | 4500.00        | -3560.00
2024-08-08  |    490.00     |  940.00        |  -450.00
```

---

**Pergunta 3:** Valor, total do cliente e percentual — em uma query, sem subquery/CTE.
```sql
SELECT
    c.nome AS cliente,
    vw.valor_liquido,
    SUM(vw.valor_liquido) OVER(PARTITION BY c.id_cliente) AS total_gasto_cliente,
    ROUND(
        (vw.valor_liquido / SUM(vw.valor_liquido) OVER(PARTITION BY c.id_cliente)) * 100,
    2) AS percentual_do_total
FROM vw_faturamento_pedidos vw
INNER JOIN clientes c ON vw.id_cliente = c.id_cliente
WHERE vw.status = 'entregue';
```
```
cliente          | valor_liquido | total_gasto | percentual
-----------------+---------------+-------------+-----------
João Silva       |   4679.80     |   6074.85   |  77.04
João Silva       |    940.00     |   6074.85   |  15.47
João Silva       |    455.05     |   6074.85   |   7.49
Beatriz Santos   |  10800.00     |  11290.00   |  95.66
Beatriz Santos   |    490.00     |  11290.00   |   4.34
Pedro Costa      |   4734.00     |   4734.00   | 100.00
...
```

---

# PANDAS

---

## Estrutura fundamental: Series e DataFrame

### Series — array unidimensional com índice
```python
import pandas as pd

s = pd.Series([10, 20, 30], index=["a", "b", "c"])
# a    10
# b    20
# c    30
# dtype: int64

s["b"]    # 20  — acesso por label
s[1]      # 20  — acesso por posição inteira (deprecado em pandas 2.x, use s.iloc[1])

# Series é o bloco fundamental: cada coluna de um DataFrame é uma Series
```

### DataFrame — tabela bidimensional com índice de linhas e índice de colunas
```python
df = pd.DataFrame({
    "nome":  ["Ana", "Bruno", "Carla"],
    "valor": [100.0, 250.0, 80.0],
    "ativo": [True, True, False],
})

df.dtypes
# nome      object   ← str é armazenado como object em pandas
# valor    float64
# ativo       bool

df.shape    # (3, 2) → (linhas, colunas)
df.info()   # visão geral: shape, dtypes, memória usada
df.describe()  # estatísticas: count, mean, std, min, 25%, 50%, 75%, max
```

### Index — o eixo de linhas
```python
# O índice padrão é RangeIndex(0, 1, 2, ...)
# Pode ser qualquer valor único — data, ID, string

df_idx = df.set_index("nome")       # define coluna como índice
df_idx.reset_index()                # volta ao RangeIndex, coluna retorna ao DataFrame

# Por que o índice importa:
# - .loc[] usa o índice de linhas para seleção por label
# - merge/join alinha por índice ou chave
# - Após groupby, o campo agrupado vira o índice (use as_index=False para evitar)
```

---

## Imutabilidade: assign() vs mutação direta

### O problema da mutação direta
```python
df = pd.DataFrame({"a": [1, 2, 3], "b": [4, 5, 6]})

# ❌ Mutação direta — modifica df in-place
df["c"] = df["a"] + df["b"]
# df original foi alterado — qualquer referência ao df antigo agora tem a coluna "c"

# ❌ Pior: mutação via slice (SettingWithCopyWarning)
subset = df[df["a"] > 1]
subset["c"] = 99   # pode ou não modificar df original — comportamento indefinido
# pandas emite: SettingWithCopyWarning: A value is trying to be set on a copy of a slice
```

### A solução: `.assign()` retorna um novo DataFrame
```python
# ✅ Imutável — df original intocado
df_novo = df.assign(c=lambda x: x["a"] + x["b"])

# ✅ Múltiplas colunas em uma chamada
df_enriquecido = df.assign(
    c=lambda x: x["a"] + x["b"],
    d=lambda x: x["c"] * 2,   # pode referenciar coluna criada na mesma chamada!
    e=lambda x: x["d"] > 10,
)

# A ordem das colunas importa dentro do mesmo .assign()
# Python 3.7+ garante ordem de inserção em dicts → colunas são avaliadas em sequência
```

### Por que usar lambda dentro do assign
```python
valores = pd.Series([10, 20, 30])
df = pd.DataFrame({"a": [1, 2, 3]})

# ❌ Referência ao nome externo — quebra em method chain
df2 = df.assign(nova=df["a"] * 2)
# Se df for resultado de uma expressão encadeada, essa referência já não é válida:
resultado = (
    pd.read_csv("dados.csv")
    .dropna()
    .assign(nova=df["a"] * 2)   # ← df aqui é o DataFrame original, não o pós-dropna!
)

# ✅ Lambda recebe o DataFrame no estado atual da cadeia
resultado = (
    pd.read_csv("dados.csv")
    .dropna()
    .assign(nova=lambda x: x["a"] * 2)   # x é o df pós-dropna
)
```

---

## Seleção e filtragem: loc, iloc, query, boolean mask

### Mapa de seleção
```
df["col"]              → Series (uma coluna)
df[["col1", "col2"]]   → DataFrame (múltiplas colunas)
df.loc[label]          → linha por label do índice
df.iloc[posição]       → linha por posição inteira (0-based)
df.loc[linhas, colunas]  → seleção 2D por label
df.iloc[linhas, colunas] → seleção 2D por posição
```

### `.loc[]` — seleção por label (inclui o fim do slice)
```python
df = pd.DataFrame(
    {"a": [10, 20, 30], "b": [40, 50, 60]},
    index=["x", "y", "z"]
)

df.loc["y"]           # Series da linha "y"
df.loc["x":"y"]       # linhas "x" e "y" (inclusive — diferente de Python slice!)
df.loc["x":"y", "a"]  # coluna "a" das linhas "x" e "y"

# Seleção booleana — mais comum
mask = df["a"] > 15
df.loc[mask]          # filtra linhas onde a > 15
df.loc[mask, "b"]     # coluna "b" das linhas filtradas
```

### `.iloc[]` — seleção por posição inteira (exclui o fim do slice, como Python)
```python
df.iloc[0]        # primeira linha
df.iloc[-1]       # última linha
df.iloc[0:2]      # linhas 0 e 1 (sem a 2)
df.iloc[0:2, 1:]  # linhas 0-1, colunas a partir da 1
```

### Boolean mask vs `.query()`
```python
# Boolean mask — mais explícito, pode ser combinado com variáveis Python
limite = 500
mask = (df["status"] == "entregue") & (df["faturamento"] > limite)
df[mask]

# .query() — mais legível para condições complexas
df.query("status == 'entregue' and faturamento > 500")

# .query() com variáveis Python (prefixo @)
limite = 500
df.query("status == 'entregue' and faturamento > @limite")

# Cuidado com .query() e nomes de colunas com espaços ou caracteres especiais
# — use backticks: df.query("`nome coluna` > 10")

# Performance: .query() usa numexpr internamente quando disponível → mais rápido
# para DataFrames grandes (> 100k linhas). Para DataFrames pequenos, diferença é mínima.
```

---

## groupby e agg

### Como o groupby funciona internamente
```
df.groupby("col")  →  SplitGroupByObject  →  .agg() / .transform() / .apply()
                       (lazy — nada calculado ainda)
                            ↓
                       Split: divide o df em grupos
                       Apply: aplica a função em cada grupo
                       Combine: combina os resultados
```

### `.agg()` com named aggregations (padrão de produção)
```python
# Sintaxe: nome_coluna=(coluna_fonte, função)
resultado = df.groupby("vendedor").agg(
    total_pedidos    =("pedido",      "count"),
    faturamento_total=("faturamento", "sum"),
    ticket_medio     =("faturamento", "mean"),
    faturamento_max  =("faturamento", "max"),
    faturamento_min  =("faturamento", "min"),
)

# Após .agg(), o campo de groupby vira o índice
# Para manter como coluna:
df.groupby("vendedor", as_index=False).agg(...)
# Ou: resultado.reset_index()
```

### Funções de agregação disponíveis
```python
# Strings-atalho para funções built-in (mais rápidas — executam em C)
"count"    # conta não-NULLs (use "size" para contar com NULLs)
"sum"
"mean"
"median"
"std"      # desvio padrão amostral (ddof=1)
"var"
"min"
"max"
"first"    # primeiro valor do grupo
"last"     # último valor do grupo
"nunique"  # contagem de valores únicos

# Função customizada (mais lenta — executa em Python)
df.groupby("categoria").agg(
    amplitude=("faturamento", lambda x: x.max() - x.min())
)
```

### `.transform()` — agrega mas mantém o shape original (essencial para percentuais)
```python
# Diferença fundamental:
# .agg()       → retorna 1 linha por grupo (colapsa)
# .transform() → retorna 1 valor por linha (mesmo shape do df original)

df = df.assign(
    total_categoria=lambda x: x.groupby("categoria")["faturamento"].transform("sum"),
    pct_categoria  =lambda x: x["faturamento"] / x["total_categoria"] * 100,
)

# Analogia SQL:
# SUM(faturamento) OVER (PARTITION BY categoria)  →  .transform("sum")
# .transform() é a window function do pandas
```

### `.apply()` — máxima flexibilidade, menor performance
```python
# Quando .agg() e .transform() não são suficientes (retorno irregular, lógica complexa)
def resumo_grupo(grupo: pd.DataFrame) -> pd.Series:
    return pd.Series({
        "n":       len(grupo),
        "total":   grupo["faturamento"].sum(),
        "top_prod": grupo.loc[grupo["faturamento"].idxmax(), "produto"],
    })

df.groupby("vendedor").apply(resumo_grupo)

# Cuidado: .apply() executa em Python puro — evite em dados grandes
# Para lógica simples, prefira sempre .agg() ou .transform()
```

---

## Method Chaining

Method chaining é o padrão de encadear operações pandas em uma única expressão. Análogo a pipelines no shell (`|`) ou ao pipe do dplyr no R.

### Por que usar
```python
# ❌ Variáveis temporárias — poluem o namespace, dificulta debug de qual etapa errou
df1 = df.dropna()
df2 = df1[df1["valor"] > 0]
df3 = df2.assign(categoria=lambda x: pd.cut(x["valor"], bins=3, labels=["B", "M", "A"]))
df4 = df3.groupby("categoria").agg(total=("valor", "sum"))
df5 = df4.sort_values("total", ascending=False)

# ✅ Method chain — cada transformação é uma etapa explícita
resultado = (
    df
    .dropna()
    .query("valor > 0")
    .assign(categoria=lambda x: pd.cut(x["valor"], bins=3, labels=["B", "M", "A"]))
    .groupby("categoria", as_index=False)
    .agg(total=("valor", "sum"))
    .sort_values("total", ascending=False)
)
```

### `.pipe()` — insere funções customizadas no chain
```python
def adicionar_rank(df: pd.DataFrame, coluna: str) -> pd.DataFrame:
    return df.assign(rank=lambda x: x[coluna].rank(ascending=False).astype(int))

def filtrar_top_n(df: pd.DataFrame, n: int, coluna: str) -> pd.DataFrame:
    return df.nsmallest(n, coluna)  # rank 1 = menor valor = maior original

resultado = (
    df
    .query("status == 'entregue'")
    .groupby("vendedor", as_index=False)
    .agg(total=("faturamento", "sum"))
    .pipe(adicionar_rank, coluna="total")  # insere função customizada no chain
    .pipe(filtrar_top_n, n=3, coluna="rank")
)
```

### Debugging de chains com `.pipe()`
```python
def debug(df: pd.DataFrame, msg: str = "") -> pd.DataFrame:
    """Imprime info do df sem interromper o chain — útil para diagnóstico"""
    print(f"[{msg}] shape={df.shape}  colunas={list(df.columns)}")
    return df

resultado = (
    df
    .dropna()
    .pipe(debug, "pós-dropna")
    .query("valor > 0")
    .pipe(debug, "pós-filtro")
    .assign(nova=lambda x: x["valor"] * 2)
)
```

---

## Merge e Join entre DataFrames

### `.merge()` — análogo ao SQL JOIN
```python
# Sintaxe completa
pd.merge(
    left=df_esq,
    right=df_dir,
    on="id",           # coluna comum (ou left_on / right_on para nomes diferentes)
    how="inner",       # "inner" | "left" | "right" | "outer" (= full outer)
    suffixes=("_esq", "_dir"),  # sufixos quando colunas colidem
    indicator=True,    # adiciona coluna "_merge" mostrando origem de cada linha
)

# Equivalência SQL:
# how="inner"  → INNER JOIN
# how="left"   → LEFT JOIN
# how="outer"  → FULL OUTER JOIN
# how="cross"  → CROSS JOIN (sem "on")
```

### Detecção de problemas comuns em merges
```python
# 1. Duplicatas na chave de join → linhas multiplicadas (produto cartesiano parcial)
clientes.merge(pedidos, on="id_cliente")
# Se um cliente tem 3 pedidos → aparece 3 vezes. Esperado para INNER JOIN.
# Se não era esperado → verifique unicidade antes do merge:
assert clientes["id_cliente"].is_unique, "Duplicatas em clientes!"

# 2. Verificar cobertura com indicator=True
resultado = df_a.merge(df_b, on="id", how="outer", indicator=True)
resultado["_merge"].value_counts()
# both          → presente nos dois (INNER match)
# left_only     → só no df_a
# right_only    → só no df_b

# 3. Merge com nomes diferentes de colunas
pedidos.merge(clientes, left_on="id_cliente", right_on="id", how="left")
```

### `.concat()` — empilhar DataFrames
```python
# Empilhar verticalmente (adicionar linhas) — equivale a UNION ALL no SQL
df_total = pd.concat([df_jan, df_fev, df_mar], ignore_index=True)
# ignore_index=True → recria o índice sequencial (evita índices duplicados)

# Concatenar horizontalmente (adicionar colunas) — cuidado: alinha por índice
df_wide = pd.concat([df_info, df_metricas], axis=1)
```

---

## Tipos de dados e otimização de memória

Em Data Engineering, DataFrames grandes podem usar gigabytes de RAM desnecessariamente por causa de tipos errados.

### Mapa de tipos pandas → memória
```
object  (str)   → ~57 bytes por valor + comprimento da string — O MAIS CARO
int64           → 8 bytes por valor
float64         → 8 bytes por valor
int32 / int16   → 4 / 2 bytes por valor
float32         → 4 bytes por valor
bool            → 1 byte por valor
category        → ~1-4 bytes por valor (para colunas de baixa cardinalidade)
```

### Conversão de tipos para economizar memória
```python
df = pd.read_csv("dados.csv")
df.memory_usage(deep=True).sum() / 1024**2  # uso em MB antes

# Converter colunas de status/categoria para category (baixa cardinalidade)
df["status"] = df["status"].astype("category")
df["uf"]     = df["uf"].astype("category")

# Reduzir inteiros
df["quantidade"] = pd.to_numeric(df["quantidade"], downcast="integer")  # int64 → menor int possível
df["preco"]      = pd.to_numeric(df["preco"], downcast="float")          # float64 → float32

df.memory_usage(deep=True).sum() / 1024**2  # uso em MB depois
# Redução típica: 40-70% dependendo dos dados

# Verificar cardinalidade antes de converter para category
df["status"].nunique()  # se < 50 valores únicos → ótimo candidato a category
```

### `pd.read_csv()` com tipos definidos desde a leitura
```python
# Definir dtypes na leitura evita a alocação inicial desnecessária
df = pd.read_csv("vendas.csv", dtype={
    "id_pedido":   "int32",
    "status":      "category",
    "id_cliente":  "int32",
    "valor":       "float32",
})

# parse_dates: lê datas como datetime64 em vez de object
df = pd.read_csv("vendas.csv", parse_dates=["data_pedido", "data_entrega"])
```

### Quando migrar de pandas para Polars/DuckDB
```
pandas    → até ~500MB de dados → análise exploratória, prototipagem, ML features
Polars    → 500MB–10GB → transformações em memória, performance crítica
DuckDB    → qualquer tamanho → SQL analítico sobre arquivos Parquet/CSV diretamente
Spark     → dados que não cabem em 1 máquina → processamento distribuído
```

---

## Exercícios Resolvidos — Pandas

### Ex3 — Fundamentos: assign, query, groupby, idxmax

**Dataset:** 10 pedidos de e-commerce com vendedor, produto, categoria, qtd, preco, status.

---

**Q1 — Adicionar coluna `faturamento` com `.assign()`**
```python
vendas_faturadas = vendas.assign(faturamento=lambda df: df["qtd"] * df["preco"])
```
```
   pedido  cliente  vendedor    produto  categoria  qtd    preco    status  faturamento
0       1     João     Bruno   Notebook  Eletrônicos    1  4500.0  entregue       4500.0
1       2    Maria     Carla      Mouse  Periféricos    3    89.9  entregue        269.7
2       3     João     Bruno    SSD 1TB  Componentes    2   380.0  entregue        760.0
...
```

**Padrão correto com `lambda`:** O `lambda df:` recebe o DataFrame no estado atual da cadeia, não uma referência ao nome da variável externa. É a forma robusta para method chaining.

**Diferença entre as abordagens:**
```python
# ❌ Referência externa — quebra em chains
vendas.assign(faturamento=vendas["qtd"] * vendas["preco"])

# ✅ Lambda — sempre correto, independente do contexto
vendas.assign(faturamento=lambda df: df["qtd"] * df["preco"])
```

---

**Q2 — Filtrar com `.query()`**
```python
vendas_relevantes = vendas_faturadas.query("status == 'entregue' and faturamento > 500")
```
```
   pedido  cliente  vendedor     produto  categoria  qtd    preco    status  faturamento
0       1     João     Bruno    Notebook  Eletrônicos    1  4500.0  entregue       4500.0
2       3     João     Bruno     SSD 1TB  Componentes    2   380.0  entregue        760.0
4       5    Pedro     Bruno  Monitor 4K  Eletrônicos    1  2800.0  entregue       2800.0
8       9  Beatriz     Diego     SSD 1TB  Componentes    3   380.0  entregue       1140.0
9      10    Lucas     Ana L  Monitor 4K  Eletrônicos    2  2800.0  entregue       5600.0
```
**5 pedidos** — Mouse (269.70), Teclado (300.00) e Headset cancelado foram removidos.

---

**Q3 — `groupby().agg()` com named aggregations**
```python
resumo_vendedor = (
    vendas_relevantes
    .groupby("vendedor")
    .agg(
        total_pedidos    =("pedido",      "count"),
        faturamento_total=("faturamento", "sum"),
        ticket_medio     =("faturamento", "mean"),
    )
    .sort_values("faturamento_total", ascending=False)
)
```
```
          total_pedidos  faturamento_total  ticket_medio
vendedor
Bruno                 3            8060.0   2686.666667
Ana L                 1            5600.0   5600.000000
Diego                 1            1140.0   1140.000000
```

**Ponto de atenção:** após `.groupby().agg()`, o campo agrupado (`vendedor`) vira o **índice** do DataFrame. Para mantê-lo como coluna: `.groupby("vendedor", as_index=False).agg(...)`.

---

**Q4 — Percentual por categoria**
```python
resumo_categoria = (
    vendas_relevantes
    .groupby("categoria")
    .agg(faturamento_total=("faturamento", "sum"))
    .assign(
        percentual=lambda df: df["faturamento_total"] / df["faturamento_total"].sum() * 100
    )
)
```
```
              faturamento_total  percentual
categoria
Componentes              1140.0   7.730061
Eletrônicos             12900.0  87.464670
```

**Por que `lambda` é essencial aqui:** O `.assign()` está encadeado após o `.agg()`. O `lambda df:` recebe o DataFrame resultante do `.agg()` — que é diferente de `vendas_relevantes`. Sem lambda, a referência externa apontaria para o DataFrame errado.

**Alternativa com `.transform()` — mantém shape original (útil quando quer o % em cada linha):**
```python
vendas_relevantes = vendas_relevantes.assign(
    total_categoria =lambda x: x.groupby("categoria")["faturamento"].transform("sum"),
    pct_categoria   =lambda x: x["faturamento"] / x["total_categoria"] * 100,
)
# Cada linha passa a ter sua participação % dentro da própria categoria
```

---

**Q5 — Produto de maior faturamento por cliente com `idxmax()`**
```python
idx_top = vendas_faturadas.groupby("cliente")["faturamento"].idxmax()
top_por_cliente = vendas_faturadas.loc[idx_top, ["cliente", "produto", "faturamento"]]
```
```
   cliente     produto  faturamento
0     João    Notebook       4500.0
1    Maria  Monitor 4K       5600.0  ← Lucas (pedido 10) — mesmo produto, mesmo idx
4    Pedro  Monitor 4K       2800.0
8  Beatriz     SSD 1TB       1140.0
9    Lucas  Monitor 4K       5600.0
```

**Como funciona:**
1. `.groupby("cliente")["faturamento"]` → GroupBy de uma Series
2. `.idxmax()` → para cada grupo, retorna o **índice da linha** com maior valor (não o valor)
3. `.loc[idx_top]` → usa esses índices para selecionar as linhas no DataFrame original

**Decisão de escopo:** `vendas_faturadas` foi usado (inclui cancelados/pendentes). Em produção, documente essa escolha explicitamente — pode ser intencional (histórico completo) ou um bug silencioso.

---

# POLARS

---

## Filosofia e diferenças em relação ao Pandas

Polars foi construído do zero em Rust com objetivos diferentes do Pandas:

```
PANDAS                          POLARS
──────────────────────────────────────────────────────────────
Índice de linhas (Index)    →   Sem índice — tudo por valor
Eager por padrão            →   Lazy por padrão (API recomendada)
Execução single-thread      →   Multi-thread nativo (SIMD + Apache Arrow)
Mutação in-place possível   →   Totalmente imutável por design
Python objects (str=object) →   Tipos nativos Arrow (Utf8, Int32...)
.apply() para lógica custom →   Expressões vetorizadas (evitar UDFs)
```

### Quando usar cada um
```
Pandas  → Exploração interativa, ML features, datasets < 500MB, ecossistema scikit-learn
Polars  → Pipelines de transformação, performance crítica, 500MB–10GB em memória
DuckDB  → SQL analítico sobre arquivos Parquet/CSV, qualquer tamanho
Spark   → Dados que não cabem em 1 máquina, processamento distribuído
```

### Por que Polars é mais rápido que Pandas
```
1. Apache Arrow columnar memory layout — operações em colunas usam SIMD
2. Rust sem GIL — paralelismo real em múltiplos cores
3. Lazy query optimizer — reordena e elimina operações desnecessárias antes de executar
4. Sem Python overhead em hot paths — expressões compiladas para código nativo
```

---

## Expressões: pl.col() e o modelo lazy

Em Polars, **tudo** passa por expressões — objetos que descrevem transformações sem executá-las imediatamente.

```python
import polars as pl

# pl.col() cria uma expressão de coluna — ainda não executa nada
expr = pl.col("faturamento") * 2          # Expression — apenas descrição
df.with_columns(expr.alias("dobro"))      # Execução acontece aqui

# Expressões podem ser compostas
(pl.col("qtd") * pl.col("preco")).alias("faturamento")

# Selecionar múltiplas colunas
pl.col("a", "b", "c")       # múltiplas por nome
pl.col("^fat.*$")            # por regex
pl.col(pl.Float64)           # por tipo
pl.all()                     # todas as colunas
pl.exclude("id", "data")     # todas exceto
```

### Operadores disponíveis em expressões
```python
# Aritméticos
pl.col("a") + pl.col("b")
pl.col("a") * 2
pl.col("preco") ** 2

# Comparação (retornam Boolean)
pl.col("status") == "entregue"
pl.col("valor") > 500
pl.col("valor").is_between(100, 500)
pl.col("nome").is_in(["Ana", "Bruno"])
pl.col("email").is_null()
pl.col("email").is_not_null()

# String
pl.col("nome").str.to_lowercase()
pl.col("nome").str.starts_with("A")
pl.col("data").str.to_date("%Y-%m-%d")

# Condicional — equivalente ao np.where / CASE WHEN
pl.when(pl.col("valor") > 1000)
  .then(pl.lit("alto"))
  .otherwise(pl.lit("baixo"))
  .alias("faixa")
```

---

## with_columns() — adicionar e transformar colunas

`with_columns()` é o equivalente ao `.assign()` do Pandas. Retorna sempre um **novo** DataFrame.

```python
# Adicionar uma coluna
vendas_faturadas = vendas.with_columns(
    (pl.col("qtd") * pl.col("preco")).alias("faturamento")
)

# Múltiplas colunas em uma chamada (mais eficiente — executa em paralelo)
resultado = vendas.with_columns(
    (pl.col("qtd") * pl.col("preco")).alias("faturamento"),
    pl.col("preco").round(2).alias("preco_arredondado"),
    pl.when(pl.col("status") == "entregue")
      .then(pl.lit(True))
      .otherwise(pl.lit(False))
      .alias("concluido"),
)

# Dois estilos equivalentes para nomear:
# Estilo .alias() — canônico, funciona em qualquer contexto
(pl.col("qtd") * pl.col("preco")).alias("faturamento")

# Estilo keyword argument — mais compacto mas funciona só no with_columns
vendas.with_columns(faturamento=pl.col("qtd") * pl.col("preco"))
```

### ❌ Anti-pattern: sobrescrever o DataFrame original
```python
# ❌ Perde o estado anterior — impossível debugar etapas intermediárias
vendas = vendas.with_columns(...)
vendas = vendas.filter(...)
vendas = vendas.group_by(...).agg(...)

# ✅ Cada etapa tem nome — rastreável e testável
vendas_faturadas  = vendas.with_columns(...)
vendas_relevantes = vendas_faturadas.filter(...)
resumo            = vendas_relevantes.group_by(...).agg(...)
```

---

## filter() — filtragem com expressões

```python
# Uma condição
df.filter(pl.col("status") == "entregue")

# Múltiplas condições — parênteses obrigatórios (precedência do operador &)
df.filter(
    (pl.col("status") == "entregue") &
    (pl.col("faturamento") > 500)
)

# OR
df.filter(
    (pl.col("status") == "entregue") |
    (pl.col("status") == "enviado")
)

# Equivalente mais limpo com .is_in()
df.filter(pl.col("status").is_in(["entregue", "enviado"]))

# Negação
df.filter(~(pl.col("status") == "cancelado"))
df.filter(pl.col("status") != "cancelado")   # equivalente
```

### Por que os parênteses são obrigatórios
```python
# Em Python, & tem precedência maior que ==
# Sem parênteses, isso é avaliado como:
# pl.col("status") == ("entregue" & pl.col("faturamento")) > 500  ← ERRADO

# ❌
df.filter(pl.col("status") == "entregue" & pl.col("faturamento") > 500)

# ✅
df.filter((pl.col("status") == "entregue") & (pl.col("faturamento") > 500))
```

---

## group_by().agg() — agregações

```python
# Sintaxe completa
df.group_by("vendedor").agg(
    pl.len().alias("total_pedidos"),              # contagem de linhas do grupo
    pl.col("faturamento").sum().alias("total"),
    pl.col("faturamento").mean().alias("media"),
    pl.col("faturamento").max().alias("maximo"),
    pl.col("faturamento").min().alias("minimo"),
    pl.col("faturamento").std().alias("desvio"),
    pl.col("produto").n_unique().alias("produtos_distintos"),
    pl.col("produto").first().alias("primeiro_produto"),
)

# Ordenar resultado
.sort("total", descending=True)

# group_by por múltiplas colunas
df.group_by("vendedor", "categoria").agg(...)

# Diferença entre pl.len() e pl.col().count()
pl.len()                    # conta todas as linhas (incluindo nulls)
pl.col("x").count()         # conta valores não-null em "x"
# Para colunas que nunca são null (IDs), o resultado é igual
```

### group_by em Polars vs Pandas — diferença de comportamento
```python
# Pandas: resultado é determinístico — mesma ordem de entrada
# Polars: group_by NÃO garante ordem — use .sort() explicitamente

# ❌ Confiar na ordem do group_by em Polars
df.group_by("vendedor").agg(...)   # ordem aleatória entre execuções

# ✅ Ordenar explicitamente
df.group_by("vendedor").agg(...).sort("faturamento_total", descending=True)
```

---

## over() — window functions

`over()` é a window function nativa do Polars. Calcula agregações por grupo **sem colapsar** o DataFrame.

```python
# Sintaxe: expressão.over("coluna_partição")
pl.col("faturamento").sum().over("categoria")

# Análogos:
# SQL:    SUM(faturamento) OVER (PARTITION BY categoria)
# Pandas: df.groupby("categoria")["faturamento"].transform("sum")
```

### Diferença fundamental: group_by vs over()
```
group_by().agg()   → COLAPSA: 1 linha por grupo
over()             → MANTÉM SHAPE: N linhas, valor agregado repetido por linha

Exemplo — 3 pedidos na categoria Eletrônicos: R$4500, R$2800, R$5600
  group_by → 1 linha: | Eletrônicos | 12900.0 |
  over()   → 3 linhas, cada uma com 12900.0 na coluna total_cat:
             | Notebook   | Eletrônicos | 4500.0 | 12900.0 |
             | Monitor 4K | Eletrônicos | 2800.0 | 12900.0 |
             | Monitor 4K | Eletrônicos | 5600.0 | 12900.0 |
```

### Casos de uso comuns
```python
# Percentual por grupo (manter granularidade de linha)
df.with_columns(
    total_cat  = pl.col("faturamento").sum().over("categoria"),
).with_columns(
    percentual = (pl.col("faturamento") / pl.col("total_cat") * 100)
)

# Alternativa one-liner
df.with_columns(
    percentual=(pl.col("faturamento") / pl.col("faturamento").sum().over("categoria") * 100)
)

# Ranking dentro do grupo (window function de ranking)
df.with_columns(
    rank=pl.col("faturamento").rank(method="dense", descending=True).over("vendedor")
)

# Valor do pedido anterior por cliente (equivalente ao LAG do SQL)
df.sort("data_pedido").with_columns(
    faturamento_anterior=pl.col("faturamento").shift(1).over("cliente")
)

# Média móvel das últimas 3 linhas por grupo
df.sort("data_pedido").with_columns(
    media_movel=pl.col("faturamento").rolling_mean(window_size=3).over("cliente")
)
```

---

## sort() + group_by() — substituto do idxmax

Polars não tem índice de linhas. A abordagem para "registro de maior valor por grupo":

```python
# Padrão: ordenar descrescente → group_by → .first() pega o maior
(
    df
    .sort("faturamento", descending=True)
    .group_by("cliente")
    .agg(
        pl.col("produto").first().alias("produto_maior_fat"),
        pl.col("faturamento").first().alias("maior_faturamento"),
    )
    .sort("cliente")   # reordenar para leitura consistente
)

# Comparação com Pandas:
# Pandas: usa índice → df.loc[df.groupby("cliente")["faturamento"].idxmax()]
# Polars: usa sort+first → sem índice, operação por valor
```

### Por que Polars não tem índice
```
O índice do Pandas é um resquício de design para alinhar Series de diferentes DataFrames.
Em Polars, alinhamento é sempre explícito — via join ou expressões.

Benefícios de não ter índice:
- Sem surpresas de alinhamento automático
- DataFrames sempre têm shape retangular previsível
- Paralelismo mais simples (sem coordenação de índice entre threads)
- Código mais explícito — a intenção é sempre clara
```

---

## Lazy API: scan e collect

A API Lazy é a forma recomendada para pipelines de produção em Polars.

```python
# Eager (default com pl.DataFrame) — executa imediatamente
resultado = (
    vendas
    .with_columns(...)
    .filter(...)
    .group_by(...)
    .agg(...)
)

# Lazy — acumula operações, executa apenas no .collect()
resultado = (
    pl.scan_csv("vendas.csv")        # lê metadados, não os dados
    .with_columns(...)               # descreve transformação
    .filter(...)                     # descreve filtro
    .group_by(...)
    .agg(...)
    .collect()                       # AQUI executa tudo, com otimização
)

# Outras fontes lazy
pl.scan_parquet("dados/*.parquet")
pl.scan_ndjson("eventos.jsonl")
pl.LazyFrame(df)                     # converte DataFrame eager para lazy
```

### Por que usar Lazy
```
1. Query optimizer: Polars reordena operações para minimizar dados lidos
   - Predicate pushdown: filtros são aplicados ANTES de carregar dados do disco
   - Projection pushdown: apenas colunas usadas são lidas
   
2. Streaming: para datasets maiores que a RAM, processa em chunks automaticamente
   df.lazy().filter(...).collect(streaming=True)

3. Paralelismo automático: operações independentes executam em paralelo

Exemplo — sem otimização (Eager):
  scan 10GB → with_columns (10GB) → filter (retorna 1MB) → agg
  
Com Lazy:
  scan 10GB → [predicate pushdown] → ler apenas linhas que passam no filtro (1MB) → with_columns (1MB) → agg
  Economiza: ler 9.999GB desnecessários
```

---

## Exercícios Resolvidos — Polars

### Ex4 — Fundamentos: with_columns, filter, group_by, over, sort+first

**Dataset:** mesmos 10 pedidos do Ex3 (e-commerce).

---

**Q1 — `with_columns()` para adicionar coluna**
```python
# ✅ Padrão imutável com .alias()
vendas_faturadas = vendas.with_columns(
    (pl.col("qtd") * pl.col("preco")).alias("faturamento")
)
```
```
shape: (10, 9)
┌────────┬─────────┬──────────┬────────────┬─────────────┬─────┬────────┬───────────┬─────────────┐
│ pedido ┆ cliente ┆ vendedor ┆ produto    ┆ categoria   ┆ qtd ┆ preco  ┆ status    ┆ faturamento │
╞════════╪═════════╪══════════╪════════════╪═════════════╪═════╪════════╪═══════════╪═════════════╡
│ 1      ┆ João    ┆ Bruno    ┆ Notebook   ┆ Eletrônicos ┆ 1   ┆ 4500.0 ┆ entregue  ┆ 4500.0      │
│ 2      ┆ Maria   ┆ Carla    ┆ Mouse      ┆ Periféricos ┆ 3   ┆ 89.9   ┆ entregue  ┆ 269.7       │
│ ...                                                                                              │
└────────┴─────────┴──────────┴────────────┴─────────────┴─────┴────────┴───────────┴─────────────┘
```

---

**Q2 — `.filter()` com condições múltiplas**
```python
vendas_relevantes = vendas_faturadas.filter(
    (pl.col("status") == "entregue") &
    (pl.col("faturamento") > 500)
)
```
```
shape: (5, 9)   — Mouse (269.7), Teclado (300.0), Headset cancelado removidos
```

---

**Q3 — `group_by().agg()` — bug de escopo + correção**
```python
# ❌ Bug silencioso — usa df completo em vez de vendas_relevantes
vendas.group_by("vendedor").agg(...)

# ✅ Correto
resumo_vendedor = (
    vendas_relevantes
    .group_by("vendedor")
    .agg(
        pl.len().alias("total_pedidos"),
        pl.col("faturamento").sum().alias("faturamento_total"),
        pl.col("faturamento").mean().alias("ticket_medio"),
    )
    .sort("faturamento_total", descending=True)
)
```
```
┌──────────┬───────────────┬───────────────────┬──────────────┐
│ vendedor ┆ total_pedidos ┆ faturamento_total ┆ ticket_medio │
╞══════════╪═══════════════╪═══════════════════╪══════════════╡
│ Bruno    ┆ 3             ┆ 8060.0            ┆ 2686.67      │
│ Ana L    ┆ 1             ┆ 5600.0            ┆ 5600.0       │
│ Diego    ┆ 1             ┆ 1140.0            ┆ 1140.0       │
└──────────┴───────────────┴───────────────────┴──────────────┘
```

---

**Q4 — `over()` para percentual por categoria**
```python
# Abordagem em dois with_columns — mais legível
resultado = (
    vendas_relevantes
    .with_columns(
        pl.col("faturamento").sum().over("categoria").alias("total_categoria")
    )
    .with_columns(
        (pl.col("faturamento") / pl.col("total_categoria") * 100).alias("percentual")
    )
)

# One-liner equivalente
resultado = vendas_relevantes.with_columns(
    percentual=(pl.col("faturamento") / pl.col("faturamento").sum().over("categoria") * 100)
)
```
```
┌────────────┬─────────────┬─────────────┬─────────────────┬───────────┐
│ produto    ┆ categoria   ┆ faturamento ┆ total_categoria ┆ percentual│
╞════════════╪═════════════╪═════════════╪═════════════════╪═══════════╡
│ Notebook   ┆ Eletrônicos ┆ 4500.0      ┆ 12900.0         ┆ 34.88     │
│ Monitor 4K ┆ Eletrônicos ┆ 2800.0      ┆ 12900.0         ┆ 21.71     │
│ Monitor 4K ┆ Eletrônicos ┆ 5600.0      ┆ 12900.0         ┆ 43.41     │
│ SSD 1TB    ┆ Componentes ┆ 760.0       ┆ 1900.0          ┆ 40.0      │
│ SSD 1TB    ┆ Componentes ┆ 1140.0      ┆ 1900.0          ┆ 60.0      │
└────────────┴─────────────┴─────────────┴─────────────────┴───────────┘
```

---

**Q5 — `sort()` + `group_by()` + `.first()`**
```python
top_por_cliente = (
    vendas_faturadas
    .sort("faturamento", descending=True)
    .group_by("cliente")
    .agg(
        pl.col("produto").first().alias("produto_maior_faturamento"),
        pl.col("faturamento").first().alias("maior_faturamento"),
    )
    .sort("cliente")
)
```
```
┌─────────┬────────────────────────────┬──────────────────┐
│ cliente ┆ produto_maior_faturamento  ┆ maior_faturamento│
╞═════════╪════════════════════════════╪══════════════════╡
│ Beatriz ┆ SSD 1TB                    ┆ 1140.0           │
│ João    ┆ Notebook                   ┆ 4500.0           │
│ Lucas   ┆ Monitor 4K                 ┆ 5600.0           │
│ Maria   ┆ Monitor 4K                 ┆ 5600.0           │  ← pedido 10 de Lucas, não Maria
│ Pedro   ┆ Monitor 4K                 ┆ 2800.0           │
└─────────┴─────────────────────────────┴─────────────────┘
```
⚠️ Nota: `vendas_faturadas` inclui todos os status. Decida intencionalmente se quer filtrar por `entregue` antes.

---

# GIT PROFISSIONAL

---

## Configuração inicial

Antes de criar qualquer repositório, configure identidade global uma única vez por máquina:

```powershell
git config --global user.name  "Seu Nome"
git config --global user.email "seu@email.com"

# Editor padrão para mensagens de commit (recomendado: VS Code)
git config --global core.editor "code --wait"

# Estratégia de rebase ao fazer pull (evita merge commits automáticos)
git config --global pull.rebase true

# Padronizar quebra de linha no Windows
git config --global core.autocrlf true

# Verificar configurações
git config --global --list
```

---

## Criando repositório local

```powershell
# 1. Entrar na pasta do projeto
cd d:\3_Estudos\TRILHA_DE

# 2. Inicializar o repositório
git init
# Cria a pasta .git/ — não apague, é o banco de dados do Git

# 3. Criar o .gitignore ANTES do primeiro commit
#    (arquivo detalhado na seção abaixo)

# 4. Verificar o que será incluído
git status

# 5. Adicionar arquivos ao staging area
git add .                         # todos os arquivos não ignorados
git add documentos/               # uma pasta específica
git add exercicios/ex1.py         # um arquivo específico

# 6. Remover do staging sem desfazer a edição
git restore --staged <arquivo>

# 7. Fazer o primeiro commit
git commit -m "feat: initialize trilha-data-engineer repository"

# 8. Renomear a branch principal para 'main' (padrão atual)
git branch -M main
```

### Anatomia do staging area
```
Working Directory  →  git add  →  Staging Area (Index)  →  git commit  →  .git/history
     (edições)                        (o que vai entrar                    (permanente)
                                       no próximo commit)

git status   → mostra diferenças entre as três zonas
git diff     → working directory vs staging
git diff --staged  → staging vs último commit
```

---

## .gitignore para Python/Data Engineering

Crie o arquivo `.gitignore` na raiz do projeto com este conteúdo:

```
# ─── Python ───────────────────────────────────────────────
__pycache__/
*.py[cod]
*.pyo
*.pyd
*.so
*.egg
*.egg-info/
dist/
build/

# ─── Ambientes virtuais ───────────────────────────────────
.venv/
venv/
env/
ENV/
.conda/

# ─── Jupyter ──────────────────────────────────────────────
.ipynb_checkpoints/
*.ipynb_checkpoints

# ─── Dados (nunca versionar dados brutos grandes) ─────────
*.csv
*.parquet
*.json
!**/*exemplo*.json     # exceção: arquivos de exemplo podem entrar
data/raw/
data/bronze/

# ─── Credenciais e variáveis de ambiente ──────────────────
.env
.env.*
secrets.yaml
*credentials*

# ─── IDEs e sistema operacional ───────────────────────────
.vscode/settings.json
*.suo
.DS_Store
Thumbs.db
desktop.ini

# ─── Outputs e logs ───────────────────────────────────────
logs/
*.log
outputs/
```

### Regras importantes
```
# Ignorar qualquer arquivo .log
*.log

# Ignorar pasta inteira
data/raw/

# Ignorar arquivos .csv em qualquer subpasta
**/*.csv

# Exceção: incluir um arquivo que seria ignorado pela regra acima
!data/exemplo.csv

# Verificar o que está sendo ignorado
git status --ignored
git check-ignore -v <arquivo>    # diz qual regra está ignorando o arquivo
```

---

## .gitattributes — padronizar line endings

O arquivo `.gitattributes` na raiz do repositório define como o Git trata arquivos independentemente da configuração local de cada desenvolvedor.

**Problema:** no Windows, `core.autocrlf = true` faz o Git converter LF → CRLF ao fazer checkout, gerando warnings e diffs espúrios em arquivos `.ipynb`, `.py`, etc.:
```
warning: in the working copy of 'exercicios/ex3_pandas.ipynb', LF will be replaced by CRLF
```

**Solução — criar `.gitattributes` na raiz do projeto:**
```gitattributes
# Normaliza line endings para LF no repositório
* text=auto

# Força LF para arquivos de código/notebooks
*.py text eol=lf
*.ipynb text eol=lf
*.sql text eol=lf
*.md text eol=lf
*.json text eol=lf
```

### Por que preferir .gitattributes a core.autocrlf

| | `core.autocrlf` | `.gitattributes` |
|---|---|---|
| Escopo | Configuração local do desenvolvedor | Versionado junto ao repo |
| Portabilidade | Cada pessoa precisa configurar | Aplica para todos automaticamente |
| Granularidade | Global (todos os arquivos) | Por extensão ou caminho |

### Aplicar após criar o arquivo
```powershell
git add .gitattributes
git commit -m "chore: add .gitattributes to normalize line endings"
```

---

## Conventional Commits

Padrão amplamente adotado na indústria. Permite gerar changelogs automáticos e deixa o histórico legível.

```
<tipo>(<escopo>): <descrição imperativa>

[corpo opcional]

[rodapé opcional — breaking changes, issue refs]
```

### Tipos e quando usar

| Tipo | Quando usar | Exemplo |
|------|-------------|---------|
| `feat` | Nova funcionalidade | `feat(api): add endpoint /users` |
| `fix` | Correção de bug | `fix(parser): handle null values in CSV` |
| `docs` | Só documentação | `docs: update README with setup steps` |
| `refactor` | Sem mudar comportamento | `refactor(etl): extract transform step to function` |
| `test` | Adicionar/corrigir testes | `test(pipeline): add unit tests for transformer` |
| `chore` | Manutenção (deps, config) | `chore: upgrade polars to 1.40` |
| `style` | Formatação, linting | `style: apply black formatter` |
| `perf` | Melhoria de performance | `perf(query): replace loop with vectorized operation` |
| `ci` | CI/CD | `ci: add github actions workflow` |

### Exemplos reais para este projeto
```bash
feat: initialize trilha-data-engineer repository
docs: add personalized 48-week study plan
feat(exercises): add python comprehensions and generators exercises
feat(exercises): add sql joins and window functions exercises
feat(exercises): add pandas ex3 notebook with assign and groupby
feat(exercises): add polars ex4 notebook
docs(reference): add pandas section to exercicios_resolvidos
docs(reference): add polars section to exercicios_resolvidos
chore: add .gitignore for python and data engineering
```

### Breaking changes
```bash
# Mudança incompatível com versão anterior — adicionar ! e BREAKING CHANGE no rodapé
feat(schema)!: rename column faturamento to revenue

BREAKING CHANGE: renomeação afeta todos os notebooks que referenciam a coluna
```

---

## Branches: estratégias e comandos

### Comandos essenciais

```powershell
# Criar e entrar na branch
git switch -c feat/duckdb-ex5        # moderno (Git 2.23+)
git checkout -b feat/duckdb-ex5      # legado — ainda funciona

# Listar branches
git branch                           # locais
git branch -a                        # locais + remotas

# Trocar de branch
git switch main
git checkout main                    # legado

# Deletar branch (após merge)
git branch -d feat/duckdb-ex5        # seguro — falha se não mergeada
git branch -D feat/duckdb-ex5        # força

# Ver qual branch você está
git branch --show-current
```

### Estratégias de branching

**Trunk-Based Development (recomendado para times ágeis):**
```
main ──●──────────────────●──────── (sempre deployável)
       └─ feat/x ─●─●─● ─┘
                             ↑ branches curtas (< 2 dias), rebase antes de merge
```

**Git Flow (projetos com releases definidas):**
```
main      ──────●─────────────────────●──── (produção, só tags)
develop   ──●───●───●───●───●───●──── (integração contínua)
feature/  ──────────┘   └───┘
release/                    └─────●──
hotfix/   ──────────────────────────└─●
```

**Para projetos de estudo (esta trilha):**
```
main          ─── sempre com exercícios completos e revisados
feat/ex5-*    ─── desenvolvimento de cada exercício
docs/*        ─── atualizações de documentação
```

---

## Rebase vs Merge

```
Situação inicial:
  main:     A ── B ── C
  feature:  A ── B ── D ── E

─────────────────────────────────────────────────────────────────
MERGE (--no-ff):                    REBASE:
  main:     A─B─C──────M           main: A─B─C─D'─E'
  feature:       D─E──/            (D e E são reescritos com base em C)
  Preserva histórico real           Histórico linear, mais legível
  Cria commit de merge              Sem commit de merge
  Seguro em branches remotas        ⚠️ Nunca rebase branches compartilhadas
─────────────────────────────────────────────────────────────────
```

### Quando usar cada um
```
merge --no-ff  → integrar feature branch na main (preserva rastreabilidade)
merge --ff     → branches locais pequenas sem relevância histórica
rebase         → limpar commits de uma branch ANTES de abrir PR
                 ("squash" de commits wip antes do review)
rebase -i      → rebase interativo: squash, reword, reorder, drop commits
```

### Rebase interativo — fluxo completo
```powershell
# Você tem 3 commits wip na branch
git log --oneline
# abc1234 wip: fix typo
# def5678 wip: add content
# ghi9012 feat(exercises): scaffold notebook   ← manter este

# Reescrever os últimos 3 commits
git rebase -i HEAD~3

# Editor abre com:
# pick ghi9012 feat(exercises): scaffold notebook
# pick def5678 wip: add content
# pick abc1234 wip: fix typo

# Alterar para squash (s) nos que quer combinar:
# pick ghi9012 feat(exercises): scaffold notebook
# squash def5678 wip: add content
# squash abc1234 wip: fix typo

# Salvar → editor abre para editar a mensagem final do commit combinado
# Resultado: 1 commit limpo com a mensagem que você escolheu
```

---

## git stash

Salva trabalho em progresso sem commitar — útil quando precisa trocar de branch urgentemente.

```powershell
# Salvar modificações (tracked + staged)
git stash push -m "wip: descricao do que estava fazendo"

# Salvar incluindo arquivos novos (untracked)
git stash push -u -m "wip: incluindo novos arquivos"

# Listar stashes
git stash list
# stash@{0}: On feat/duckdb: wip: descricao
# stash@{1}: On main: wip: outra coisa

# Recuperar o stash mais recente (e remover da pilha)
git stash pop

# Recuperar sem remover (para aplicar em outra branch)
git stash apply stash@{1}

# Ver o que tem no stash sem aplicar
git stash show -p stash@{0}

# Descartar
git stash drop stash@{0}
git stash clear              # limpar todos
```

---

## Tags e Semantic Versioning

### SemVer — MAJOR.MINOR.PATCH

```
v1.4.2
│ │ └─ PATCH: bugfix compatível com versão anterior
│ └─── MINOR: nova funcionalidade compatível (incrementa, PATCH vai a 0)
└───── MAJOR: mudança incompatível com versão anterior (incrementa, demais vão a 0)

v0.x.x → projeto em desenvolvimento, API pode mudar a qualquer momento
v1.0.0 → primeira versão estável/produção
```

### Para este projeto de estudos
```
v0.1.0 → checkpoint Python + SQL + Pandas + Polars
v0.2.0 → + DuckDB + Git
v0.3.0 → + Docker + primeiro pipeline ETL
v1.0.0 → projeto final completo, pronto para portfólio
```

### Comandos de tag

```powershell
# Criar tag anotada (recomendado — inclui autor, data, mensagem)
git tag -a v0.1.0 -m "chore: checkpoint python, sql, pandas, polars exercises"

# Criar tag leve (só um ponteiro, sem metadados)
git tag v0.1.0

# Listar tags
git tag
git tag -l "v0.*"             # filtrar por padrão

# Ver detalhes da tag
git show v0.1.0

# Publicar tag no remoto (tags não são enviadas automaticamente com git push)
git push origin v0.1.0        # uma tag específica
git push origin --tags         # todas as tags

# Deletar tag local
git tag -d v0.1.0

# Deletar tag remota
git push origin --delete v0.1.0
```

---

## Criando repositório remoto no GitHub

### Passo a passo completo

**1. Criar o repositório no GitHub (via interface web)**
1. Acesse [github.com](https://github.com) → botão **"New"** (canto superior esquerdo)
2. Preencha:
   - **Repository name:** `trilha-data-engineer`
   - **Description:** "Exercícios e documentação da trilha Data Engineer → Senior/ML"
   - **Visibility:** Public (para portfólio) ou Private
   - ⚠️ **NÃO marque** "Add a README file" nem "Add .gitignore" — o repositório deve estar vazio para conectar ao local
3. Clique em **"Create repository"**

**2. Conectar repositório local ao remoto**
```powershell
# Adicionar o remote (substitua SEU_USUARIO pelo seu username do GitHub)
git remote add origin https://github.com/SEU_USUARIO/trilha-data-engineer.git

# Verificar que foi adicionado
git remote -v
# origin  https://github.com/SEU_USUARIO/trilha-data-engineer.git (fetch)
# origin  https://github.com/SEU_USUARIO/trilha-data-engineer.git (push)
```

**3. Enviar o repositório local para o GitHub**
```powershell
# Primeiro push — define a branch upstream
git push -u origin main

# Após o primeiro push, simplesmente:
git push
```

### Autenticação — Personal Access Token (PAT)

GitHub removeu autenticação por senha em 2021. Use **Personal Access Token**:

1. GitHub → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. **Generate new token (classic)**
3. Marcar escopos: `repo` (acesso total a repositórios privados/públicos)
4. Copie o token — ele só aparece uma vez
5. No `git push`, quando pedir senha, cole o token (não a senha da conta)

**Salvar credenciais para não digitar toda vez:**
```powershell
git config --global credential.helper manager
# Windows Credential Manager salva automaticamente após o primeiro login
```

### Fluxo diário com remote

```powershell
# Baixar mudanças do remoto sem aplicar
git fetch origin

# Baixar e aplicar (pull = fetch + merge/rebase)
git pull

# Enviar commits locais
git push

# Ver diferença entre local e remoto
git log origin/main..main --oneline    # commits que ainda não foram para o remoto
git log main..origin/main --oneline    # commits do remoto que ainda não vieram
```

### Proteção da branch main (GitHub)

No repositório remoto → **Settings** → **Branches** → **Add branch protection rule**:
- Branch name pattern: `main`
- ✅ Require a pull request before merging
- ✅ Require approvals (em times)
- ✅ Require status checks to pass (CI/CD)

Isso garante que ninguém (nem você) possa fazer `git push` direto na `main` — obriga a usar PRs.

---

## Exercícios Resolvidos — Git

### Ex5 — Repositório local, commits, branches, stash, rebase, tags, GitHub e conflitos

**Repositório:** [github.com/dataengineercezar/trilha-data-engineer](https://github.com/dataengineercezar/trilha-data-engineer)  
**Tag de checkpoint:** `v0.1.0`

---

**Q1–Q2 — Inicialização e primeiro commit**
```powershell
git init
git branch -M main
git add .
git commit -m "feat: initialize trilha-data-engineer repository"
```
```
ec986ac feat: initialize trilha-data-engineer repository
```

---

**Q3 — Feature branch**
```powershell
git switch -c feat/duckdb-ex5
git branch --show-current    # feat/duckdb-ex5
```

---

**Q4 — git stash**
```powershell
Add-Content PLANO_PERSONALIZADO.md "`n<!-- WIP: DuckDB anotação -->"
git stash push -m "wip: anotacao sobre duckdb"
git status          # working tree clean
git stash list      # stash@{0}: On feat/duckdb-ex5: wip: anotacao sobre duckdb
git stash pop       # recupera modificações
git restore PLANO_PERSONALIZADO.md    # descarta o arquivo de teste
```
**Resultado:** o stash salva o estado do working directory sem commitar, permitindo trocar de branch e recuperar depois.

---

**Q5 — Rebase interativo (squash)**
```powershell
# 2 commits wip criados intencionalmente
git commit -m "wip: create duckdb notes file"
git commit -m "wip: add first duckdb note"

# Combinar em 1 commit limpo
git rebase -i HEAD~2
# No editor: trocar 'pick' por 'squash' na segunda linha
# Mensagem final: docs(exercises): add duckdb study notes
```
```
e67a023 docs(exercises): add duckdb study notes   ← 1 commit limpo
```
⚠️ Lição aprendida: usar `git log --oneline` antes do rebase para contar exatamente quantos commits cobrir com `HEAD~N`.

---

**Q6 — Merge --no-ff na main**
```powershell
git switch main
git merge --no-ff feat/duckdb-ex5 -m "feat(exercises): merge duckdb ex5 branch"
git log --oneline --graph
```
```
*   82663a4 feat(exercises): merge duckdb ex5 branch
|\
| * e67a023 docs(exercises): add duckdb study notes
| * b725e06 wip: add first duckdb note
| * ae5f21d wip: create duckdb notes file
|/
* d25cb99 Ajustes
* ec986ac feat: initialize trilha-data-engineer repository
```

---

**Q7 — Tag v0.1.0**
```powershell
git tag -a v0.1.0 -m "chore: first stable checkpoint - python, sql, pandas, polars, git"
git push origin v0.1.0
```
```
tag v0.1.0
Tagger: Cézar Augusto Meira Carmo <dataengineercezar@gmail.com>
Date:   Fri May 8 16:04:52 2026 -0300
chore: first stable checkpoint - python, sql, pandas, polars, git
```

---

**Q8 — Simulação de conflito de merge**

Duas branches editam a mesma linha do mesmo arquivo:
```powershell
# Branch A
git switch -c feat/duckdb-intro
# edita linha 1 → "# DuckDB — Introdução e Conceitos"
git commit -m "docs(exercises): expand duckdb title in branch A"

# Branch B (a partir da main — mesma linha, conteúdo diferente)
git switch main ; git switch -c feat/duckdb-overview
# edita linha 1 → "# DuckDB — Visão Geral e Performance"
git commit -m "docs(exercises): expand duckdb title in branch B"
```

```powershell
git switch main
git merge --no-ff feat/duckdb-intro    # ✅ sem conflito
git merge --no-ff feat/duckdb-overview # ❌ CONFLICT
# CONFLICT (content): Merge conflict in exercicios/ex5_duckdb.md
```

**Resolução manual** — o Git marca o arquivo com:
```
<<<<<<< HEAD
# DuckDB — Introdução e Conceitos
=======
# DuckDB — Visão Geral e Performance
>>>>>>> feat/duckdb-overview
```
Editar para o conteúdo desejado, apagar as marcações, salvar.

```powershell
git add exercicios\ex5_duckdb.md
git status    # All conflicts fixed but you are still merging
git commit -m "fix: resolve merge conflict in duckdb title"
```

**Grafo final:**
```
*   9a6fcb8 fix: resolve merge conflict in duckdb title
|\
| * c4cca28 docs(exercises): expand duckdb title in branch B
* |   181afc5 feat: merge branch A
|\ \
| * 638f2cf docs(exercises): expand duckdb title in branch A
|/
*   82663a4 (tag: v0.1.0) feat(exercises): merge duckdb ex5 branch
```
O padrão "diamante duplo" é o histório visual de um conflito resolvido — duas branches divergindo do mesmo ponto e convergindo de volta para a main.
