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
  - [Como o Git funciona internamente](#como-o-git-funciona-internamente)
  - [Configuração inicial e níveis de config](#configuração-inicial-e-níveis-de-config)
  - [As três zonas: working directory, staging e repositório](#as-três-zonas-working-directory-staging-e-repositório)
  - [.gitignore e .gitattributes](#gitignore-e-gitattributes)
  - [Conventional Commits](#conventional-commits)
  - [Branches: internamente e estratégias](#branches-internamente-e-estratégias)
  - [Merge deep dive](#merge-deep-dive)
  - [Rebase deep dive](#rebase-deep-dive)
  - [Resolvendo conflitos](#resolvendo-conflitos)
  - [git reset, git revert e git restore — os três desfazeres](#git-reset-git-revert-e-git-restore--os-três-desfazeres)
  - [git stash](#git-stash)
  - [git cherry-pick](#git-cherry-pick)
  - [git bisect — encontrar o commit que introduziu um bug](#git-bisect--encontrar-o-commit-que-introduziu-um-bug)
  - [git reflog — a rede de segurança](#git-reflog--a-rede-de-segurança)
  - [Tags e Semantic Versioning](#tags-e-semantic-versioning)
  - [GitHub: remote, autenticação e PRs](#github-remote-autenticação-e-prs)
  - [GitHub Actions — CI básico](#github-actions--ci-básico)
  - [Fluxo profissional completo](#fluxo-profissional-completo)
  - [Exercícios Resolvidos — Git](#exercícios-resolvidos--git)
- [DOCKER PARA DATA ENGINEERING](#docker-para-data-engineering)
  - [Por que Docker para Data Engineering?](#por-que-docker-para-data-engineering)
  - [Conceitos fundamentais](#conceitos-fundamentais)
  - [Arquitetura interna do Docker](#arquitetura-interna-do-docker)
  - [Imagens: camadas, cache e otimização](#imagens-camadas-cache-e-otimização)
  - [Dockerfile: instrução por instrução](#dockerfile-instrução-por-instrução)
  - [Multi-stage build](#multi-stage-build)
  - [Volumes: persistência de dados](#volumes-persistência-de-dados)
  - [Networks: comunicação entre containers](#networks-comunicação-entre-containers)
  - [Environment variables e segurança](#environment-variables-e-segurança)
  - [docker-compose: orquestração local](#docker-compose-orquestração-local)
  - [Docker Hub: publicar imagens](#docker-hub-publicar-imagens)
  - [Padrões de produção para DE](#padrões-de-produção-para-de)
  - [Exercícios Resolvidos — Docker](#exercícios-resolvidos--docker)
- [APACHE SPARK / PYSPARK](#apache-spark--pyspark)
  - [Por que Spark existe — o problema que ele resolve](#por-que-spark-existe--o-problema-que-ele-resolve)
  - [Arquitetura: Driver, Executors e Cluster Manager](#arquitetura-driver-executors-e-cluster-manager)
  - [O modelo de dados: RDD, DataFrame e Dataset](#o-modelo-de-dados-rdd-dataframe-e-dataset)
  - [Lazy evaluation: transformações vs actions](#lazy-evaluation-transformações-vs-actions)
  - [DAG de execução: jobs, stages e tasks](#dag-de-execução-jobs-stages-e-tasks)
  - [Shuffle: o inimigo da performance](#shuffle-o-inimigo-da-performance)
  - [Particionamento: a unidade de paralelismo](#particionamento-a-unidade-de-paralelismo)
  - [SparkSession e configuração](#sparksession-e-configuração)
  - [DataFrame API essencial](#dataframe-api-essencial)
  - [Exercícios Resolvidos — Spark](#exercícios-resolvidos--spark)

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

## Como o Git funciona internamente

Entender o modelo de objetos do Git é o que separa quem "usa git" de quem "entende git". Todos os comandos (`commit`, `merge`, `rebase`, `reset`) são operações sobre esse modelo.

### O banco de dados de objetos — `.git/objects/`

Git é um **banco de dados de objetos endereçados por conteúdo**. Cada objeto é identificado pelo SHA-1 (40 caracteres hex) do seu conteúdo. Existem exatamente 4 tipos de objeto:

```
┌──────────┬──────────────────────────────────────────────────────────────────┐
│  BLOB    │ Conteúdo de um arquivo. Não guarda nome nem permissão — só bytes. │
│          │ SHA-1(conteúdo) → o mesmo arquivo em dois lugares tem o MESMO sha │
├──────────┼──────────────────────────────────────────────────────────────────┤
│  TREE    │ Diretório: lista de (modo, tipo, sha, nome). Aponta para blobs   │
│          │ e outras trees. Representa um snapshot da estrutura de pastas.   │
├──────────┼──────────────────────────────────────────────────────────────────┤
│  COMMIT  │ Aponta para uma TREE (snapshot), para commits pai (parent),      │
│          │ e guarda: autor, committer, timestamp, mensagem.                 │
├──────────┼──────────────────────────────────────────────────────────────────┤
│  TAG     │ Objeto anotado: aponta para um commit, inclui mensagem e autor.  │
│          │ Tag leve é só um arquivo de referência (não é objeto).           │
└──────────┴──────────────────────────────────────────────────────────────────┘
```

### Visualizando o modelo — um commit na prática

```
commit 82663a4
  │  tree: f1e2d3c  ←── snapshot do diretório raiz neste momento
  │  parent: d25cb99
  │  author: Cézar
  │  message: "feat(exercises): merge duckdb ex5 branch"
  │
  └─ tree f1e2d3c (raiz)
       ├── blob a1b2c3  README.md
       ├── blob d4e5f6  .gitignore
       └── tree g7h8i9  exercicios/
             ├── blob j1k2l3  ex1.py
             └── blob m4n5o6  ex5_duckdb.md
```

**Implicações importantes:**
```
1. Git não guarda deltas (diff) entre versões — guarda snapshots completos.
   (Na prática usa compressão com packfiles, mas o modelo conceitual é snapshot)

2. Se dois arquivos têm o mesmo conteúdo em qualquer commit, compartilham o mesmo blob.
   Zero duplicação de dados.

3. Um commit é IMUTÁVEL. Mudar qualquer coisa (mensagem, conteúdo, parent) produz
   um SHA diferente — por isso rebase "reescreve" commits (cria novos objetos).

4. Renames são detectados por similaridade de conteúdo, não rastreados explicitamente.
```

### O que existe em `.git/`

```
.git/
├── HEAD           → aponta para a branch atual (ref: refs/heads/main)
├── config         → configurações locais do repositório
├── index          → staging area (arquivo binário)
├── objects/       → banco de dados de todos os objetos (blob/tree/commit/tag)
│   ├── pack/      → objetos comprimidos em packfiles
│   └── ab/cd...  → objetos individuais (primeiros 2 chars = subdiretório)
├── refs/
│   ├── heads/     → branches locais (arquivos com o SHA do último commit)
│   │   └── main   → conteúdo: "82663a4..." (simplesmente o hash do commit)
│   ├── remotes/   → branches remotas rastreadas
│   │   └── origin/main
│   └── tags/      → tags leves
└── logs/
    ├── HEAD       → reflog do HEAD
    └── refs/heads/main  → reflog da branch main
```

```powershell
# Inspecionar qualquer objeto do Git
git cat-file -t 82663a4   # tipo do objeto (commit, tree, blob, tag)
git cat-file -p 82663a4   # conteúdo legível do objeto

# Ver a tree (snapshot) de um commit
git ls-tree HEAD
git ls-tree -r HEAD       # recursivo (todos os arquivos)

# Ver o SHA de um arquivo específico
git hash-object exercicios/ex1.py
```

### Branches e HEAD — ponteiros, não cópias

```
Uma branch é apenas um arquivo em .git/refs/heads/ contendo o SHA de um commit.
HEAD é um arquivo contendo qual branch está ativa: "ref: refs/heads/main"

Criar uma branch é O(1) — criar um arquivo de 41 bytes.
Trocar de branch é O(arquivos modificados) — atualizar o working directory.

HEAD → main → 82663a4 (commit) → f1e2d3c (tree) → ...
```

**Detached HEAD state:**
```powershell
# Acontece quando você faz checkout de um commit (não de uma branch)
git checkout 82663a4

# HEAD agora aponta diretamente para o commit, não para uma branch
# commits feitos aqui FICAM ÓRFÃOS — não têm branch apontando para eles
# serão coletados pelo garbage collector após ~30 dias

# Para preservar trabalho feito em detached HEAD:
git switch -c nova-branch    # cria branch apontando para o commit atual
```

---

## Configuração inicial e níveis de config

Git tem três níveis de configuração — cada nível sobrescreve o anterior:

```
system  → C:\Program Files\Git\etc\gitconfig     (para todos os usuários da máquina)
global  → C:\Users\Cézar\.gitconfig              (para o usuário atual)
local   → d:\3_Estudos\TRILHA_DE\.git\config     (para este repositório)
```

```powershell
# Verificar qual arquivo está sendo lido para cada configuração
git config --show-origin user.email

# Configurações essenciais (global — uma vez por máquina)
git config --global user.name  "Cézar Augusto Meira Carmo"
git config --global user.email "dataengineercezar@gmail.com"
git config --global core.editor "code --wait"
git config --global pull.rebase true          # pull = fetch + rebase (não merge)
git config --global core.autocrlf true        # Windows: normaliza line endings
git config --global credential.helper manager # Windows Credential Manager
git config --global init.defaultBranch main   # branch padrão ao git init

# Configuração local — sobrescreve global para este repo
git config --local user.email "trabalho@empresa.com"

# Ver todas as configurações ativas com origem
git config --list --show-origin
```

### Aliases — atalhos para comandos frequentes

```powershell
git config --global alias.st   "status -s"
git config --global alias.lg   "log --oneline --graph --all"
git config --global alias.last "log -1 HEAD --stat"
git config --global alias.undo "reset HEAD~1 --mixed"    # desfaz último commit, mantém arquivos
git config --global alias.aliases "config --get-regexp alias"

# Uso
git st          # git status -s (formato compacto)
git lg          # grafo visual de todas as branches
git last        # detalhes do último commit
git undo        # desfaz o commit mais recente (não perde as edições)
```

---

## As três zonas: working directory, staging e repositório

```
┌─────────────────────┐    git add    ┌──────────────────┐    git commit    ┌──────────────┐
│  Working Directory  │  ──────────►  │  Staging (Index) │  ─────────────►  │  Repository  │
│  (arquivos no disco)│               │  (próximo commit)│                   │  (.git/hist) │
└─────────────────────┘               └──────────────────┘                   └──────────────┘
         ▲                                                                           │
         │                          git restore                                     │
         └──────────────────── git restore --staged ◄───────────────────────────────┘
                                    git reset
```

### Navegação entre zonas

```powershell
# Ver estado das três zonas
git status          # verbose
git status -s       # compacto: XY filename (X=staging, Y=working)
                    # M = modified, A = added, D = deleted, ? = untracked, ! = ignored

# Ver diffs
git diff                      # working directory vs staging (o que ainda NÃO foi staged)
git diff --staged             # staging vs último commit (o que VAI entrar no commit)
git diff HEAD                 # working directory vs último commit (tudo pendente)
git diff main..feat/branch    # diferença entre duas branches
git diff v0.1.0..HEAD         # diferença desde a tag v0.1.0

# Formatos úteis de diff
git diff --stat               # resumo: quantos arquivos e linhas mudaram
git diff --word-diff          # diff palavra a palavra (ótimo para texto/docs)
git diff --color-words        # colorido por palavra
```

### Staging interativo — `git add -p`

Permite adicionar apenas **partes** de um arquivo ao commit — essencial para commits atômicos e semânticos:

```powershell
git add -p exercicios/ex5_duckdb.md

# Git mostra cada "hunk" (bloco de mudanças) e pergunta:
# Stage this hunk [y,n,q,a,d,e,?]?
#   y → sim, adicionar este hunk ao staging
#   n → não, pular este hunk
#   s → dividir em hunks menores
#   e → editar o hunk manualmente
#   q → sair (o que foi staged permanece staged)
#   ? → ajuda
```

**Por que isso importa em produção:** você pode ter 3 mudanças diferentes no mesmo arquivo (bugfix + refactor + doc) e criar 3 commits separados usando `git add -p`. Isso mantém o histórico semântico mesmo quando as mudanças estão fisicamente no mesmo arquivo.

### git log — explorando o histórico

```powershell
# Formatos
git log                           # completo (autor, data, mensagem)
git log --oneline                 # hash curto + mensagem
git log --oneline --graph         # com grafo de branches
git log --oneline --graph --all   # inclui branches remotas

# Filtros
git log --author="Cézar"
git log --since="2 weeks ago"
git log --since="2026-01-01" --until="2026-06-01"
git log --grep="feat(exercises)"       # busca no texto da mensagem
git log -S "pl.col"                    # busca em conteúdo adicionado/removido (pickaxe)
git log -- exercicios/ex3_pandas.ipynb # histórico de um arquivo específico

# Formato personalizado
git log --format="%h | %an | %ar | %s"
#   %h  → hash curto
#   %an → author name
#   %ar → author date, relative (ex: "3 days ago")
#   %s  → subject (primeira linha da mensagem)

# Ver arquivos alterados em cada commit
git log --stat
git log --name-only
git log --name-status     # M=modified, A=added, D=deleted, R=renamed
```

---

## .gitignore e .gitattributes

### .gitignore — o que não versionar

```gitignore
# ─── Python ───────────────────────────────────────────────
__pycache__/
*.py[cod]           # *.pyc, *.pyo, *.pyd
*.egg-info/
dist/
build/

# ─── Ambientes virtuais ───────────────────────────────────
.venv/
venv/
env/

# ─── Jupyter ──────────────────────────────────────────────
.ipynb_checkpoints/

# ─── Dados ────────────────────────────────────────────────
# Regra geral: nunca versionar dados brutos (podem ser grandes e conter PII)
*.csv
*.parquet
data/raw/
data/bronze/
!data/exemplo.csv   # exceção explícita para arquivo de amostra

# ─── Credenciais ──────────────────────────────────────────
.env
.env.*
*token*
*secret*
*credentials*
secrets.yaml

# ─── Sistema ──────────────────────────────────────────────
.DS_Store           # macOS
Thumbs.db           # Windows Explorer
desktop.ini
*.log
```

### Comandos de diagnóstico do .gitignore

```powershell
# Ver qual regra está ignorando um arquivo
git check-ignore -v token-git.txt
# .gitignore:37:*token*   token-git.txt

# Ver TODOS os arquivos ignorados
git status --ignored

# Forçar adicionar um arquivo ignorado (use com cuidado)
git add -f arquivo_ignorado.csv

# Se adicionou um arquivo que deveria estar no .gitignore
git rm --cached arquivo_sensivel.env    # remove do tracking sem apagar do disco
git commit -m "chore: stop tracking .env file"
```

### .gitattributes — comportamento por tipo de arquivo

```gitattributes
# Normaliza line endings: Git armazena LF, converte ao fazer checkout conforme OS
* text=auto

# Força LF para arquivos de código (evita warnings no Windows)
*.py     text eol=lf
*.ipynb  text eol=lf
*.sql    text eol=lf
*.md     text eol=lf
*.json   text eol=lf
*.yaml   text eol=lf

# Arquivos binários — não fazer diff nem conversão de line endings
*.png    binary
*.jpg    binary
*.parquet binary
*.pkl    binary
```

**Por que `.gitattributes` é superior a `core.autocrlf`:**
```
core.autocrlf  → configuração local de cada desenvolvedor (não versionada)
.gitattributes → versionado no repo, aplica para todos automaticamente
                 garante comportamento consistente em qualquer máquina
```

---

## Conventional Commits

Padrão da indústria que habilita automações: changelogs automáticos, bump de versão semântico, CI/CD condicional por tipo de commit.

### Formato completo

```
<tipo>(<escopo>): <descrição> ← linha de assunto (max 72 chars)

[corpo: contexto, motivação, o que mudou e por quê]

[rodapé]
Refs: #123
BREAKING CHANGE: descrição da quebra de compatibilidade
```

### Tipos e quando usar

| Tipo | Quando usar | Bump SemVer |
|---|---|---|
| `feat` | Nova funcionalidade para o usuário | MINOR |
| `fix` | Correção de bug para o usuário | PATCH |
| `docs` | Só documentação | - |
| `refactor` | Mudança de código sem alterar comportamento externo | - |
| `test` | Adicionando ou corrigindo testes | - |
| `chore` | Manutenção: deps, config, build | - |
| `style` | Formatação, linting (sem mudar lógica) | - |
| `perf` | Melhoria de performance | PATCH |
| `ci` | Arquivos de CI/CD | - |
| `feat!` ou `BREAKING CHANGE:` | Quebra compatibilidade | MAJOR |

### Corpo e rodapé — quando usar

```bash
# Commit simples — apenas assunto (suficiente para a maioria dos casos)
git commit -m "feat(exercises): add polars window function examples"

# Commit com corpo — quando a motivação não é óbvia
git commit -m "refactor(etl): replace pandas apply with vectorized operation

Using .apply() with a Python UDF bypasses pandas' internal optimizations.
Replaced with numpy vectorized operation — 40x faster on 1M row dataset.

Benchmarks:
  Before: 12.3s for 1M rows
  After:  0.3s for 1M rows"

# Commit com breaking change
git commit -m "feat(schema)!: rename column faturamento to revenue

BREAKING CHANGE: all notebooks and queries referencing 'faturamento'
must be updated to use 'revenue'. Run migration/rename_column.sql to
update the PostgreSQL schema."
```

### Por que escopos são importantes

Em projetos de dados, escopos ajudam a rastrear mudanças por área:
```
feat(ingestion):    novos conectores de fonte
feat(transform):    lógica de transformação no pipeline
feat(schema):       mudanças no schema de dados
feat(exercises):    exercícios da trilha
fix(pipeline):      bugs no ETL
docs(reference):    documentação de referência
chore(deps):        atualização de dependências
ci(tests):          automações de CI
```

---

## Branches: internamente e estratégias

### O que é uma branch internamente

```powershell
# Uma branch é literalmente um arquivo de texto com 41 bytes
Get-Content .git\refs\heads\main
# 82663a4a65c9484204164c9aa0454d50fd97fdff

# Criar uma branch = criar esse arquivo
# Deletar uma branch = deletar esse arquivo
# Não existe "conteúdo da branch" — apenas um ponteiro para um commit
```

### Comandos completos

```powershell
# Criar
git switch -c feat/duckdb-ex5          # cria e entra (Git 2.23+)
git switch -c feat/fix-x origin/main   # a partir de uma branch remota específica

# Listar
git branch                             # locais
git branch -v                          # com último commit
git branch -vv                         # com tracking de remote
git branch -a                          # todas (locais + remotas)
git branch --merged main               # branches já mergeadas na main
git branch --no-merged main            # branches com commits que ainda não foram na main

# Deletar
git branch -d feat/concluida           # seguro: falha se não mergeada
git branch -D feat/abandonada          # força

# Renomear
git branch -m nome-antigo nome-novo

# Rastrear remote
git branch --set-upstream-to=origin/main main
git push -u origin feat/duckdb-ex5    # -u configura tracking automaticamente
```

### Estratégias de branching

**Trunk-Based Development (recomendado para times ágeis/CI-CD):**
```
main ──●──────────────────●────────────────●──── (sempre deployável, proteção ativa)
       └─ feat/x ─●─●─● ─┘
                          ↑ branches curtas (< 2 dias)
                          ↑ rebase + squash antes do merge
                          ↑ CI passa antes de abrir PR
```

**Git Flow (projetos com releases cadenciadas):**
```
main      ────────────●────────────────────────●──── (produção — só recebe de release/hotfix)
                      │                        │
                    v1.0                      v1.1
develop   ──●──●──●──────●──●──●──●──●──●──────────── (integração)
             │            │    │       │
feature/x ──●─●─●─────────┘    │       │
feature/y ───────────────────●─●─●─────┘
release/1.1                       └───────●────────── (estabilização antes de merge na main)
hotfix/   ──────────────────────────────────────└──●  (branch da main, merge em main+develop)
```

**Feature Flags (alternativa moderna ao Git Flow):**
```
# Todos commitam na main — features desativadas por flag
if feature_flags.is_enabled("novo_algoritmo", user):
    return novo_algoritmo(data)
return algoritmo_antigo(data)

# Vantagem: elimina branches longas e conflitos massivos de merge
# Usado por: Facebook, GitHub, Netflix
```

---

## Merge deep dive

### Fast-forward vs no-ff vs squash

```
Situação: main não avançou desde que feature foi criada

main:    A ── B
feature:      └── C ── D

─────────────────────────────────────────────────────────────────────────────
FAST-FORWARD (padrão quando possível):
  main:    A ── B ── C ── D      (main simplesmente avança para onde feature está)
  Sem commit de merge, sem evidência de que uma branch existiu
  git merge feat/x               (ou git merge --ff feat/x)

NO-FF (no-fast-forward):
  main:    A ── B ──────────── M  (M = merge commit)
  feature:      └── C ── D ──/
  Preserva evidência da branch. M aponta para B e D como parents.
  git merge --no-ff feat/x -m "feat: merge ..."

SQUASH:
  main:    A ── B ── S           (S = todos os commits de feature em 1 commit novo)
  feature:      └── C ── D      (branch original não é tocada)
  Histórico da main fica linear mas perde granularidade.
  git merge --squash feat/x
  git commit -m "feat: implementação completa da feature X"
─────────────────────────────────────────────────────────────────────────────
```

### Como o Git resolve um merge — 3-way merge

```
Quando duas branches divergiram a partir de um ancestral comum (merge base):

          Ancestral (base)
          ┌──────────────┐
          │ linha 1: AAA │
          │ linha 2: BBB │
          │ linha 3: CCC │
          └──────────────┘
               /        \
  Branch HEAD (ours)    Branch MERGE_HEAD (theirs)
  ┌──────────────┐      ┌──────────────┐
  │ linha 1: AAA │      │ linha 1: AAA │
  │ linha 2: XXX │      │ linha 2: BBB │  ← só "theirs" mudou
  │ linha 3: CCC │      │ linha 3: YYY │  ← só "theirs" mudou
  └──────────────┘      └──────────────┘

Regra do 3-way merge:
  - Se só um lado mudou → aceita a mudança automaticamente
  - Se ambos mudaram a mesma linha → CONFLITO (exige resolução manual)
  - Se ambos mudaram linhas diferentes → aceita ambos automaticamente
```

### Estratégias de merge

```powershell
# Estratégia padrão (Git 2.34+): ort — mais rápida e robusta
git merge --strategy=ort feat/x

# Estratégias por arquivo durante conflito
git checkout --ours   arquivo.py    # aceita a versão da branch atual (HEAD)
git checkout --theirs arquivo.py    # aceita a versão da branch entrante

# Merge de múltiplas branches simultaneamente
git merge feat/a feat/b feat/c      # estratégia 'octopus' (sem conflitos)
```

---

## Rebase deep dive

### O que o rebase faz internamente

```
Situação:
  main:    A ── B ── C
  feature: A ── B ── D ── E

git rebase main (executado na branch feature):
  1. Git encontra o merge base (B)
  2. Salva os diffs de D e E temporariamente
  3. Move o ponteiro de feature para C (ponta da main)
  4. Re-aplica os diffs como novos commits D' e E'
     (novos SHAs — D' ≠ D, mesmo conteúdo idêntico)

  main:    A ── B ── C
  feature:           └── D' ── E'
```

**Regra de ouro do rebase:**
```
⚠️ NUNCA rebase commits que já foram publicados (git push) em branch compartilhada.

Por quê: rebase cria novos commits com SHAs diferentes.
Se outra pessoa tem os commits originais e você sobrescreve com os rebased,
o histórico dela fica incompatível — os "mesmos" commits existem com dois SHAs.

✅ Rebase é seguro:
  - Em branches locais antes do primeiro push
  - Em feature branches que só você usa (com git push --force-with-lease)
  - Em commits que ainda não saíram da sua máquina
```

### Rebase interativo — todos os comandos

```powershell
git rebase -i HEAD~5     # últimos 5 commits
git rebase -i v0.1.0     # desde a tag v0.1.0
git rebase -i <sha>      # desde o commit <sha> (não inclusivo)

# O editor abre com a lista de commits (do mais antigo para o mais novo):
# pick  abc1234  wip: first attempt
# pick  def5678  wip: fix bug
# pick  ghi9012  feat(exercises): complete solution
# pick  jkl3456  docs: add comments

# Ações disponíveis (substitua 'pick' por):
# p, pick   → manter o commit como está
# r, reword → manter mas editar a mensagem
# e, edit   → pausar aqui para modificar o commit (pode fazer amend)
# s, squash → combinar com o commit ANTERIOR, editor para nova mensagem
# f, fixup  → combinar com o anterior, DESCARTAR mensagem deste
# d, drop   → remover o commit completamente
# x, exec   → executar um comando shell neste ponto do rebase
# b, break  → pausar aqui (retomar com git rebase --continue)

# Exemplo prático: squash todos os wip em um commit limpo
# pick  abc1234  wip: first attempt      →  pick
# pick  def5678  wip: fix bug            →  fixup  (descarta mensagem "wip: fix bug")
# pick  ghi9012  feat(exercises): done   →  pick
# pick  jkl3456  docs: add comments      →  fixup
```

### Rebase --onto — mover branch para novo ponto

```powershell
# Situação: feature/b foi criada a partir de feature/a por engano
# Quero mover feature/b para que parta da main

# main:      A ── B
# feature/a: A ── B ── C ── D
# feature/b: A ── B ── C ── D ── E ── F   (deveria partir de B)

git rebase --onto main feature/a feature/b
# Semântica: pegar commits de feature/b que NÃO estão em feature/a
#            e reaplica-los sobre main

# Resultado:
# main:      A ── B ── E' ── F'   (feature/b agora parte de main)
# feature/a: A ── B ── C ── D     (inalterada)
```

### Lidar com conflitos durante rebase

```powershell
# Quando um conflito ocorre, o rebase PAUSA
# CONFLICT (content): Merge conflict in arquivo.py
# Resolve the conflict and run "git rebase --continue"

# 1. Edite os arquivos em conflito (remova marcações <<<, ===, >>>)
# 2. Adicione ao staging
git add arquivo.py

# 3. Continuar para o próximo commit
git rebase --continue

# Outras opções quando em conflito durante rebase:
git rebase --skip      # descarta o commit conflitante (cuidado!)
git rebase --abort     # cancela tudo, volta ao estado antes do rebase
```

---

## Resolvendo conflitos

### Anatomia das marcações de conflito

```
<<<<<<< HEAD                          ← início do bloco "ours" (branch atual)
# DuckDB — Introdução e Conceitos     ← conteúdo da branch atual (HEAD)
=======                               ← separador
# DuckDB — Visão Geral e Performance  ← conteúdo da branch entrante
>>>>>>> feat/duckdb-overview          ← fim do bloco "theirs" (branch que está sendo merged)
```

O arquivo tem 3 versões disponíveis:
- `HEAD` (ours) — o que estava na branch atual
- `MERGE_HEAD` (theirs) — o que veio da branch sendo mergeada
- `MERGE_BASE` — o ancestral comum (o que existia antes de ambas as branches divergirem)

### Estratégias de resolução

```powershell
# Aceitar inteiramente "ours" (versão da branch atual)
git checkout --ours   arquivo_conflitante.py
git add               arquivo_conflitante.py

# Aceitar inteiramente "theirs" (versão da branch entrante)
git checkout --theirs arquivo_conflitante.py
git add               arquivo_conflitante.py

# Edição manual (o caso mais comum — combinar o melhor dos dois)
# 1. Abrir o arquivo no editor
# 2. Remover as marcações e deixar o conteúdo final desejado
# 3. git add <arquivo>
# 4. git commit (merge) ou git rebase --continue (rebase)
```

### rerere — Reuse Recorded Resolution

```powershell
# Ativa o rerere: Git memoriza como você resolveu cada conflito
git config --global rerere.enabled true

# A partir daí: quando um conflito idêntico aparecer novamente
# (ex: durante rebase de uma branch longa), Git aplica automaticamente
# a mesma resolução que você usou antes

# Ver conflitos já resolvidos pelo rerere
git rerere status
git rerere diff     # ver o que seria aplicado automaticamente
```

### Abortando um merge em andamento

```powershell
# Se você iniciou um merge mas quer cancelar tudo
git merge --abort       # volta ao estado antes do merge
git rebase --abort      # volta ao estado antes do rebase
git cherry-pick --abort # volta ao estado antes do cherry-pick
```

---

## git reset, git revert e git restore — os três desfazeres

Esta é a área que mais confunde. Três comandos, três propósitos distintos.

```
┌─────────────────┬─────────────────────────────────────────┬────────────────────────────┐
│  Comando        │  O que faz                              │  Reescreve histórico?      │
├─────────────────┼─────────────────────────────────────────┼────────────────────────────┤
│  git reset      │  Move o ponteiro da branch para trás    │  ✅ SIM — perigoso em remoto│
│  git revert     │  Cria novo commit que inverte as mudanças│  ❌ NÃO — seguro sempre    │
│  git restore    │  Restaura arquivos (não mexe em commits) │  Não se aplica             │
└─────────────────┴─────────────────────────────────────────┴────────────────────────────┘
```

### git reset — mover o ponteiro da branch

```
ANTES:  A ── B ── C ── D   (HEAD → D)
        git reset HEAD~2   (volta 2 commits)
DEPOIS: A ── B             (HEAD → B)
        C e D ficam órfãos — serão coletados pelo GC após ~30 dias
        (mas acessíveis pelo reflog enquanto estiverem lá)
```

**Três modos — o que acontece com as mudanças de C e D:**

```powershell
git reset --soft  HEAD~2   # Mudanças de C e D → ficam no STAGING (prontas para re-commitar)
git reset --mixed HEAD~2   # Mudanças de C e D → ficam no WORKING DIR (não staged)  [padrão]
git reset --hard  HEAD~2   # Mudanças de C e D → DESCARTADAS PERMANENTEMENTE ⚠️

# Casos de uso:
# --soft:  "quero reescrever a mensagem ou combinar com o próximo commit"
# --mixed: "quero desfazer o commit mas manter as edições para revisar/reorganizar"
# --hard:  "quero descartar tudo desta branch e voltar para um estado limpo"
```

### git revert — o desfazer seguro

```powershell
# Cria um novo commit que inverte exatamente o que um commit anterior fez
git revert d25cb99         # inverte um commit específico
git revert HEAD            # inverte o último commit
git revert HEAD~3..HEAD    # inverte os últimos 3 commits (um commit de revert cada)
git revert HEAD~3..HEAD --no-commit   # aplica os reverts mas não commita (agrupa em 1 commit)

# Quando usar revert vs reset:
# revert → sempre que o commit já foi publicado (git push)
#          preserva o histórico, mostra transparência ("isso foi um erro, corrigi assim")
# reset  → apenas em commits locais que ainda não foram publicados
```

### git restore — restaurar arquivos

```powershell
# Descartar edições no working directory (volta ao estado do último commit)
git restore arquivo.py

# Descartar edições de TODOS os arquivos
git restore .

# Remover do staging sem descartar edições (equivale a "unstage")
git restore --staged arquivo.py

# Restaurar para o conteúdo de um commit específico
git restore --source=v0.1.0 arquivo.py
git restore --source=HEAD~3 exercicios/ex3_pandas.ipynb
```

---

## git stash

Salva o estado atual do working directory e staging em uma pilha temporária.

```powershell
# Salvar (inclui arquivos tracked modificados e staged)
git stash push -m "wip: refatorando pipeline de ingestão"

# Salvar incluindo arquivos novos (untracked) — importante!
git stash push -u -m "wip: novo arquivo de configuração"

# Salvar apenas arquivos staged (--keep-index: mantém working dir)
git stash push --keep-index -m "wip: só o staging"

# Listar stashes (pilha LIFO — stash@{0} é o mais recente)
git stash list
# stash@{0}: On feat/pipeline: wip: refatorando pipeline de ingestão
# stash@{1}: On main: wip: teste de configuração

# Recuperar — pop (aplica e remove da pilha)
git stash pop             # stash@{0}
git stash pop stash@{2}   # específico

# Recuperar — apply (aplica mas MANTÉM na pilha — útil para aplicar em outra branch)
git stash apply stash@{0}

# Inspecionar sem aplicar
git stash show stash@{0}          # resumo dos arquivos
git stash show -p stash@{0}       # diff completo

# Criar branch a partir de um stash (o fluxo mais seguro)
git stash branch feat/nova-branch stash@{0}
# Cria a branch no commit onde o stash foi salvo e aplica o stash

# Limpar
git stash drop stash@{0}          # remove um stash específico
git stash clear                   # remove todos ⚠️ irreversível
```

**Quando o stash pop gera conflito:**
```powershell
# O stash tenta aplicar sobre um working directory diferente do original
# Resultado: CONFLICT — resolva como qualquer outro conflito de merge
# Diferença: stash NÃO é removido automaticamente quando há conflito
git stash drop stash@{0}   # remova manualmente após resolver
```

---

## git cherry-pick

Aplica o diff de um commit específico na branch atual — sem fazer merge completo.

```
main:    A ── B ── C ── D ── E
feature:      └── F ── G ── H

# Você quer apenas o commit G na main (sem H, sem F)
git switch main
git cherry-pick G

main:    A ── B ── C ── D ── E ── G'
# G' tem o mesmo diff de G mas novo SHA — pois o parent é diferente
```

```powershell
# Aplicar um commit específico
git cherry-pick abc1234

# Aplicar range de commits (D até F, inclusive)
git cherry-pick D^..F            # ^ = não inclusivo no início, então D^..F = D, E, F

# Sem criar commit automaticamente (aplica as mudanças, fica no staging)
git cherry-pick abc1234 --no-commit

# Em caso de conflito
# 1. Resolver manualmente
# 2. git add <arquivo>
# 3. git cherry-pick --continue
#    ou git cherry-pick --abort
```

**Casos de uso em Data Engineering:**
```
1. Hotfix: você corrigiu um bug na develop e precisa levar para main sem o restante
2. Backport: nova feature foi para main, precisa ir também para branch de release antiga
3. Experimentos: você quer testar uma transformação específica de outra branch no seu pipeline
```

---

## git bisect — encontrar o commit que introduziu um bug

`bisect` usa busca binária no histórico para encontrar exatamente em qual commit um problema foi introduzido.

```
Histórico:  A ── B ── C ── D ── E ── F ── G ── H ── I ── J  (HEAD — tem bug)
            ↑                                              ↑
         funciona                                       tem bug
         (good)                                         (bad)

bisect divide ao meio e testa:  E (?)
  E está ok → bug está em F..J → testa H (?)
  H tem bug → bug está em F..H → testa G (?)
  G tem bug → bug está em F..G → testa F (?)
  F tem bug → F é o commit culpado!

Total de testes: log₂(10) ≈ 4  (em vez de testar todos os 9 commits um a um)
```

```powershell
# Iniciar bisect
git bisect start

# Marcar o commit atual (HEAD) como ruim
git bisect bad

# Marcar um commit antigo que funcionava como bom
git bisect good v0.1.0    # pode ser tag, SHA, HEAD~20...

# Git faz checkout do commit do meio — teste o bug, depois marque:
git bisect good    # este commit não tem o bug
git bisect bad     # este commit tem o bug

# Repita até o Git identificar o commit culpado:
# b4d5e6f is the first bad commit

# Finalizar e voltar para HEAD
git bisect reset
```

**Automatizar com script:**
```powershell
# Se você tem um script que retorna exit code 0 (ok) ou 1 (bug)
git bisect start
git bisect bad HEAD
git bisect good v0.1.0
git bisect run python tests/test_pipeline.py

# Git executa o script em cada commit — você não precisa fazer nada manualmente
```

---

## git reflog — a rede de segurança

`reflog` registra **toda movimentação do HEAD** — mesmo coisas que parecem irreversíveis:

```powershell
git reflog
# 82663a4 HEAD@{0}: merge feat/duckdb-overview: Merge made by the 'ort' strategy.
# 181afc5 HEAD@{1}: merge feat/duckdb-intro: Merge made by the 'ort' strategy.
# d25cb99 HEAD@{2}: checkout: moving from feat/duckdb-ex5 to main
# e67a023 HEAD@{3}: rebase (finish): refs/heads/feat/duckdb-ex5
# ...

# Recuperar commit "perdido" após git reset --hard
git reset --hard HEAD~5        # "perdi" 5 commits
git reflog                     # encontre o SHA do commit antes do reset
git reset --hard abc1234       # volta para ele
# ou
git switch -c branch-recuperada abc1234   # cria branch no commit recuperado
```

**O que o reflog rastreia:**
```
- Todos os commits (mesmo os "deletados" por reset/rebase)
- Troca de branches (checkout/switch)
- Merges e rebases
- Stash pop/drop
- Commits amend

Duração: 90 dias por padrão (configurável com gc.reflogExpire)
Escopo: apenas LOCAL — reflog não é enviado ao remote com git push
```

**Cenários de recuperação:**
```powershell
# Recuperar após git reset --hard acidental
git reflog                              # encontre o SHA antes do reset
git reset --hard <sha-antes-do-reset>

# Recuperar branch deletada
git branch -D feat/trabalho-importante  # ops, deletei sem querer
git reflog | grep feat/trabalho         # encontre o último commit da branch
git switch -c feat/trabalho-importante <sha>

# Recuperar commit amend que sobrescreveu mensagem
git reflog                              # o commit original ainda existe
git switch -c recovery-branch ORIG_HEAD
```

---

## Tags e Semantic Versioning

### SemVer — MAJOR.MINOR.PATCH

```
v2.1.3
│ │ └── PATCH: bugfix retrocompatível → v2.1.4
│ └──── MINOR: nova funcionalidade retrocompatível → v2.2.0 (PATCH volta a 0)
└────── MAJOR: quebra de compatibilidade → v3.0.0 (MINOR e PATCH voltam a 0)

Regras especiais:
  v0.x.x → desenvolvimento inicial, qualquer coisa pode mudar a qualquer momento
  v1.0.0 → primeira versão pública estável
  1.0.0-alpha.1 → pré-release (não estável)
  1.0.0+20260508 → build metadata (ignorado para comparação de versões)
```

### Tag leve vs tag anotada

```powershell
# Tag LEVE — apenas um ponteiro (arquivo em .git/refs/tags/)
git tag v0.1.0

# Tag ANOTADA — objeto completo com metadados (recomendada para releases)
git tag -a v0.1.0 -m "chore: first stable checkpoint - python, sql, pandas, polars, git"

# Diferença: tag anotada tem: tagger, email, data, mensagem, verificação GPG opcional
git show v0.1.0   # tag leve mostra só o commit; anotada mostra o objeto tag também

# Operações
git tag                      # listar todas
git tag -l "v0.*"            # filtrar por padrão
git tag -d v0.1.0            # deletar local
git push origin v0.1.0       # publicar uma tag (tags NÃO sobem com git push padrão)
git push origin --tags       # publicar todas as tags
git push origin --delete v0.1.0   # deletar tag remota

# Fazer checkout no estado de uma tag (detached HEAD)
git checkout v0.1.0
```

### Versionamento deste projeto de estudos

```
v0.1.0 → Python + SQL + Pandas + Polars + Git (checkpoint 1)
v0.2.0 → + Docker + DuckDB (checkpoint 2)
v0.3.0 → + ETL Pipeline + Airflow (checkpoint 3)
v0.4.0 → + dbt + Data Warehouse (checkpoint 4)
v1.0.0 → projeto final completo, portfólio publicado
```

---

## GitHub: remote, autenticação e PRs

### Configurando remote

```powershell
# Adicionar remote
git remote add origin https://github.com/dataengineercezar/trilha-data-engineer.git

# Listar remotes
git remote -v

# Alterar URL (ex: migrar de HTTPS para SSH)
git remote set-url origin git@github.com:dataengineercezar/trilha-data-engineer.git

# Remover remote
git remote remove origin

# Adicionar segundo remote (ex: fork + upstream)
git remote add upstream https://github.com/original/repo.git
```

### Autenticação

**HTTPS com Personal Access Token (recomendado para Windows):**
```
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token → marcar escopo: repo
3. Token aparece UMA VEZ — salve em gerenciador de senhas
4. No primeiro git push: username = seu_usuario, password = o token
5. Windows Credential Manager salva automaticamente após o primeiro uso
```

**SSH (alternativa — sem precisar de token):**
```powershell
# Gerar chave SSH
ssh-keygen -t ed25519 -C "dataengineercezar@gmail.com"

# Adicionar ao SSH agent
ssh-add ~/.ssh/id_ed25519

# Copiar chave pública
Get-Content ~/.ssh/id_ed25519.pub | clip

# Colar em: GitHub → Settings → SSH and GPG keys → New SSH key
# Testar
ssh -T git@github.com
# Hi dataengineercezar! You've successfully authenticated...
```

### Fluxo diário com remote

```powershell
# Sincronizar com o remote antes de começar a trabalhar
git fetch origin                        # baixa objetos, não aplica
git status                              # mostra se está atrás/na frente do remote
git pull                                # fetch + rebase (com pull.rebase=true)
git pull --ff-only                      # falha se houver divergência (mais seguro)

# Trabalhar...
git switch -c feat/nova-feature
# ... commits ...

# Publicar branch e abrir PR
git push -u origin feat/nova-feature    # -u configura tracking

# Sincronizar main após PR mergeado
git switch main
git pull
git branch -d feat/nova-feature         # limpar branch local
```

### Pull Requests — fluxo profissional

**O que um bom PR contém:**
```markdown
## O que foi feito
Implementa a transformação de normalização de CEP no pipeline de clientes.

## Motivação
CEPs chegam em formatos inconsistentes (com e sem hífen). A normalização
garante que joins com tabela de endereços funcionem corretamente.

## Como testar
1. `pytest tests/test_cep_normalizer.py`
2. Rodar o notebook `exercicios/ex5_duckdb.ipynb` — célula 4 deve mostrar 100% de match

## Breaking Changes
Nenhum — a coluna `cep` continua existindo, apenas normalizada.

## Checklist
- [x] Testes passando
- [x] Documentação atualizada
- [x] Sem dados sensíveis commitados
```

### Proteção da branch main

```
GitHub → repositório → Settings → Branches → Add branch protection rule:
  Branch name pattern: main
  ✅ Require a pull request before merging
  ✅ Require approvals: 1
  ✅ Dismiss stale pull request approvals when new commits are pushed
  ✅ Require status checks to pass (ex: CI tests)
  ✅ Require branches to be up to date before merging
  ✅ Do not allow bypassing the above settings
```

---

## GitHub Actions — CI básico

GitHub Actions automatiza workflows disparados por eventos no repositório (push, PR, schedule).

### Estrutura de um workflow

```
.github/
└── workflows/
    └── ci.yml          ← arquivo de workflow (YAML)
```

### Workflow básico — rodar testes Python em cada push

```yaml
# .github/workflows/ci.yml
name: CI

on:                         # eventos que disparam o workflow
  push:
    branches: [main, "feat/**"]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest  # runner: ubuntu, windows-latest, macos-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt

      - name: Run tests
        run: pytest tests/ -v --tb=short

      - name: Check code formatting
        run: |
          pip install black
          black --check exercicios/ src/
```

### Workflow para Data Engineering — validar dados e schema

```yaml
name: Data Validation

on:
  push:
    paths:
      - "exercicios/**"
      - "src/**"

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Install dependencies
        run: pip install polars pandas duckdb great-expectations

      - name: Run data quality checks
        run: python scripts/validate_schemas.py

      - name: Run notebook smoke test
        run: |
          pip install jupyter nbconvert
          jupyter nbconvert --to notebook --execute exercicios/ex4_polars.ipynb
```

### Conceitos de Actions

```
Workflow  → arquivo .yml em .github/workflows/
Job       → unidade de execução em um runner (pode ter vários jobs em paralelo)
Step      → comando ou action dentro de um job (executados em sequência)
Action    → bloco reutilizável (uses: actions/checkout@v4)
Runner    → máquina virtual onde o job roda (GitHub-hosted ou self-hosted)
Secrets   → variáveis sensíveis configuradas em Settings → Secrets (ex: tokens, senhas)
           Acessadas como: ${{ secrets.DB_PASSWORD }}
```

---

## Fluxo profissional completo

Este é o fluxo diário de um engenheiro de dados em um time usando Git/GitHub:

```
1. INÍCIO DO DIA
   git fetch origin          # sincronizar com remote
   git pull                  # aplicar mudanças da main

2. NOVA TAREFA
   git switch -c feat/JIRA-123-normalizar-cep
   # convenção: tipo/ticket-descricao-breve

3. DESENVOLVIMENTO (ciclo repetido)
   # ... editar código/notebooks ...
   git add -p                # staging interativo — commits atômicos
   git commit -m "feat(transform): add CEP normalization function"
   # repita

4. ANTES DE ABRIR PR — limpar histórico
   git fetch origin
   git rebase origin/main    # rebase na main mais recente
   git rebase -i HEAD~N      # squash de commits wip (opcional)
   git push -u origin feat/JIRA-123-normalizar-cep

5. PULL REQUEST
   # GitHub → criar PR → preencher template
   # Aguardar CI passar (Actions)
   # Code review → resolver comentários com novos commits
   # Aprovação → Squash and Merge (ou Rebase and Merge)

6. PÓS MERGE
   git switch main
   git pull
   git branch -d feat/JIRA-123-normalizar-cep

7. RELEASE (quando aplicável)
   git tag -a v0.2.0 -m "chore: add duckdb and docker exercises"
   git push origin v0.2.0
```

### Comandos de inspeção mais úteis no dia a dia

```powershell
git log --oneline --graph --all           # visão geral do estado do repositório
git diff HEAD                             # tudo pendente de commitar
git diff origin/main..HEAD --name-only    # arquivos que vão no PR
git log origin/main..HEAD --oneline       # commits que vão no PR
git shortlog -sn                          # estatísticas de commits por autor
git log --stat --since="1 week ago"       # o que mudou na última semana
```

---

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

---

---

# DOCKER PARA DATA ENGINEERING

> Docker resolve o problema fundamental de Data Engineering: **"funciona na minha máquina"**.
> Com containers, o ambiente de desenvolvimento é idêntico ao de produção.

---

## Por que Docker para Data Engineering?

Um pipeline de dados tem muitas dependências: versão do Python, bibliotecas (pandas, polars, duckdb), bancos de dados (PostgreSQL, Redis), ferramentas (Airflow, dbt, Spark). Sem Docker, gerenciar isso em equipe é caótico.

### Problemas que Docker resolve

| Problema | Sem Docker | Com Docker |
|---|---|---|
| Versão de Python diferente | `ModuleNotFoundError`, comportamentos estranhos | Imagem define `python:3.14.2` — fixo |
| Biblioteca com versão errada | `AttributeError` em produção | `requirements.txt` dentro da imagem |
| Banco de dados local vs produção | Configurações manuais diferentes | `docker-compose up` sobe o mesmo Postgres |
| Onboarding de novo dev | Horas instalando dependências | `docker compose up` — pronto em minutos |
| Deploy em qualquer cloud | Scripts de instalação frágeis | Mesma imagem roda em AWS/GCP/Azure |

### Docker vs máquina virtual

```
Máquina Virtual:                  Container Docker:
┌─────────────────────┐           ┌─────────────────────┐
│ App                 │           │ App                 │
│ Binários/Libs       │           │ Binários/Libs       │
│ Guest OS (Ubuntu)   │           ├─────────────────────┤
│ Hypervisor          │           │ Docker Engine       │  ← compartilha o kernel do host
│ Host OS             │           │ Host OS             │
│ Hardware            │           │ Hardware            │
└─────────────────────┘           └─────────────────────┘
  ~GBs, boot em minutos             ~MBs, boot em < 1s
```

Containers compartilham o **kernel do sistema operacional host** — não virtualizam hardware. Por isso são leves e rápidos.

---

## Conceitos fundamentais

### Glossário essencial

| Termo | O que é | Analogia |
|---|---|---|
| **Image** | Template imutável com tudo para rodar a app | Receita de bolo |
| **Container** | Instância rodando de uma imagem | Bolo assado |
| **Dockerfile** | Script de instruções para construir uma imagem | Lista de ingredientes e modo de preparo |
| **Registry** | Repositório de imagens (Docker Hub, ECR, GCR) | GitHub para imagens |
| **Volume** | Diretório do host montado dentro do container | Pen drive plugado no container |
| **Network** | Rede virtual que conecta containers | Switch virtual |
| **docker-compose** | Ferramenta para definir múltiplos containers em um arquivo YAML | Orquestrador local |

### Ciclo de vida de um container

```
Dockerfile  ──build──►  Image  ──run──►  Container  ──stop──►  Stopped Container
                          ↑                                              │
                          │                               ──rm──►  [deletado]
                     docker pull
                     (do Registry)
```

### Comandos essenciais

```powershell
# ─── Imagens ──────────────────────────────────────────────────────────────────
docker build -t minha-app:1.0 .       # Construir imagem a partir do Dockerfile no diretório atual
docker images                          # Listar imagens locais
docker rmi minha-app:1.0              # Remover imagem
docker pull python:3.14-slim           # Baixar imagem do Docker Hub

# ─── Containers ───────────────────────────────────────────────────────────────
docker run python:3.14-slim python -c "print('ok')"   # Rodar e deletar automaticamente
docker run -d --name meu-postgres -p 5432:5432 postgres:16   # Rodar em background
docker run -it python:3.14-slim bash   # Rodar interativamente com terminal

docker ps                              # Containers rodando
docker ps -a                           # Todos (incluindo parados)
docker stop meu-postgres              # Parar container (graceful)
docker kill meu-postgres              # Parar container (força imediata)
docker rm meu-postgres                # Remover container parado
docker rm -f meu-postgres             # Parar e remover em um comando

# ─── Inspeção e debug ─────────────────────────────────────────────────────────
docker logs meu-postgres              # Ver logs do container
docker logs -f meu-postgres           # Seguir logs em tempo real
docker exec -it meu-postgres bash     # Abrir shell dentro de container rodando
docker inspect meu-postgres           # JSON com todos os detalhes do container
docker stats                          # CPU/memória em tempo real (como htop)

# ─── Sistema ──────────────────────────────────────────────────────────────────
docker system prune                    # Limpar imagens/containers/volumes não usados
docker system prune -a                 # Limpar tudo (inclusive imagens sem container)
docker system df                       # Ver espaço usado pelo Docker
```

---

## Arquitetura interna do Docker

```
┌─────────────────────────────────────────────────────────┐
│                    Docker CLI                           │
│              (docker build, docker run...)              │
└──────────────────────┬──────────────────────────────────┘
                       │ REST API / Unix socket
                       ▼
┌─────────────────────────────────────────────────────────┐
│                  Docker Daemon (dockerd)                 │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────┐ │
│  │ Image Store  │  │  Container   │  │    Network    │ │
│  │ (layers)     │  │  Runtime     │  │    Manager    │ │
│  └──────────────┘  └──────────────┘  └───────────────┘ │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│              containerd + runc                          │
│           (execução real no kernel Linux)               │
└─────────────────────────────────────────────────────────┘
```

**O Daemon** recebe comandos da CLI via socket Unix (`/var/run/docker.sock`), gerencia imagens, containers, volumes e redes. **containerd** faz o gerenciamento de ciclo de vida do container. **runc** executa o container de fato no kernel usando *namespaces* (isolamento de processos) e *cgroups* (limites de recursos).

### Namespaces — isolamento

| Namespace | O que isola |
|---|---|
| `pid` | Processos (container só vê seus próprios processos) |
| `net` | Interfaces de rede |
| `mnt` | Filesystems montados |
| `uts` | Hostname |
| `ipc` | IPC (inter-process communication) |
| `user` | UIDs/GIDs (user namespace mapping) |

### cgroups — limites de recursos

```powershell
# Limitar memória e CPU de um container
docker run --memory="512m" --cpus="1.5" python:3.14-slim python script.py
#            ↑ max 512MB RAM       ↑ até 1.5 núcleos de CPU
```

---

## Imagens: camadas, cache e otimização

### Camadas (layers)

Uma imagem Docker é um **stack de camadas imutáveis**. Cada instrução no Dockerfile cria uma camada:

```dockerfile
FROM python:3.14-slim          # Camada 1: imagem base (~100MB)
RUN pip install polars          # Camada 2: polars instalado (~50MB)
COPY . /app                     # Camada 3: código da app (~1MB)
```

```
Image view:
┌─────────────────────────────┐  ← Camada 3: COPY . /app  (read-only)
├─────────────────────────────┤  ← Camada 2: pip install  (read-only)
├─────────────────────────────┤  ← Camada 1: python:3.14-slim (read-only)
└─────────────────────────────┘

Container (ao rodar):
┌─────────────────────────────┐  ← Container layer  (read-write)
├─────────────────────────────┤  ← Camada 3 (read-only)
├─────────────────────────────┤  ← Camada 2 (read-only)
├─────────────────────────────┤  ← Camada 1 (read-only)
└─────────────────────────────┘
```

**Copy-on-Write**: arquivos das camadas read-only são copiados para a camada do container apenas quando modificados. Isso torna containers rápidos e eficientes em memória (múltiplos containers compartilham as camadas base).

### Cache de build

Docker reutiliza camadas em cache se a instrução não mudou **e** nenhuma camada anterior mudou. Isso torna `docker build` rápido em iterações.

**Ordem importa** — coloque o que muda mais para o **final**:

```dockerfile
# ❌ RUIM: toda mudança de código invalida o cache do pip install
FROM python:3.14-slim
COPY . /app                     # se qualquer arquivo mudar → cache inválido aqui
RUN pip install -r requirements.txt  # executa TODA VEZ mesmo sem mudança de deps

# ✅ BOM: requirements só reinstala quando requirements.txt mudar
FROM python:3.14-slim
COPY requirements.txt /app/requirements.txt   # muda raramente
RUN pip install -r /app/requirements.txt       # usa cache na maioria das builds
COPY . /app                                    # muda frequentemente — vai para o final
```

### .dockerignore

Como `.gitignore`, mas para o build context enviado ao daemon:

```dockerignore
# .dockerignore na raiz do projeto
.git/
.venv/
__pycache__/
*.pyc
.env*
*.csv
*.parquet
*.log
.ipynb_checkpoints/
```

Sem `.dockerignore`, `docker build` envia tudo para o daemon (incluindo `.git/` e `.venv/` que podem ter centenas de MBs).

---

## Dockerfile: instrução por instrução

```dockerfile
# ─── Imagem base ──────────────────────────────────────────────────────────────
FROM python:3.14-slim
# python:3.14-slim = imagem oficial Python 3.14 baseada em Debian Bookworm,
# sem pacotes desnecessários (slim). ~120MB vs ~1GB do python:3.14 completo.
# Outras variantes:
#   python:3.14-alpine    → ~50MB, mas usa musl libc (problemas com pacotes C)
#   python:3.14-bookworm  → Debian completo, mais compatível

# ─── Metadados ────────────────────────────────────────────────────────────────
LABEL maintainer="cezar@example.com"
LABEL version="1.0"
LABEL description="Pipeline de dados ETL"

# ─── Variáveis de ambiente ────────────────────────────────────────────────────
ENV PYTHONUNBUFFERED=1
# PYTHONUNBUFFERED=1 → logs aparecem imediatamente (sem buffer)
# Essencial para ver output de scripts Python em tempo real nos logs do container

ENV PYTHONDONTWRITEBYTECODE=1
# Evita criar arquivos .pyc (não necessários em container)

ENV APP_HOME=/app

# ─── Usuário não-root ─────────────────────────────────────────────────────────
# Por padrão containers rodam como root — má prática de segurança
RUN groupadd --gid 1001 appuser \
    && useradd --uid 1001 --gid appuser --shell /bin/bash --create-home appuser

# ─── Diretório de trabalho ────────────────────────────────────────────────────
WORKDIR $APP_HOME
# Cria e define /app como diretório padrão — todos os COPY/RUN subsequentes são relativos a ele

# ─── Dependências do sistema ──────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*
# --no-install-recommends: instala apenas o pacote, sem dependências extras
# rm -rf /var/lib/apt/lists/*: apaga o cache do apt → reduz tamanho da camada

# ─── Dependências Python ──────────────────────────────────────────────────────
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# --no-cache-dir: não salva cache do pip dentro da imagem → menor tamanho

# ─── Código da aplicação ──────────────────────────────────────────────────────
COPY --chown=appuser:appuser . .
# --chown: define dono dos arquivos copiados (não root)

# ─── Trocar para usuário não-root ─────────────────────────────────────────────
USER appuser

# ─── Porta (documentação) ─────────────────────────────────────────────────────
EXPOSE 8080
# EXPOSE é apenas documentação — não publica a porta automaticamente
# A publicação real acontece com docker run -p 8080:8080

# ─── Healthcheck ──────────────────────────────────────────────────────────────
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# ─── Entrypoint vs CMD ────────────────────────────────────────────────────────
ENTRYPOINT ["python"]
CMD ["pipeline.py"]
# ENTRYPOINT ["python"] + CMD ["pipeline.py"]
#   → executa: python pipeline.py
#   → pode sobrescrever CMD: docker run imagem outro_script.py
#   → não pode sobrescrever ENTRYPOINT (a não ser com --entrypoint)

# Alternativa para scripts:
# CMD ["python", "pipeline.py"]      # sem ENTRYPOINT — mais simples
# ENTRYPOINT ["./entrypoint.sh"]     # script de inicialização
```

---

## Multi-stage build

Técnica que usa múltiplos `FROM` no mesmo Dockerfile. O estágio final copia apenas os artefatos necessários, descartando ferramentas de build.

### Por que usar

Um pipeline Python tem dependências que precisam ser compiladas (pyarrow, grpcio, cryptography), mas o container final não precisa do compilador C, headers de sistema, etc.

```
Sem multi-stage:  imagem final ~800MB (compilador + código + libs)
Com multi-stage:  imagem final ~150MB (apenas código + libs compiladas)
```

### Exemplo para Data Engineering

```dockerfile
# ─── Estágio 1: builder ───────────────────────────────────────────────────────
FROM python:3.14-slim AS builder

# Instala dependências de compilação
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Cria virtualenv isolado para copiar no próximo estágio
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
#   ↑ aqui compila pyarrow, cryptography, etc. com o gcc disponível

# ─── Estágio 2: runtime ───────────────────────────────────────────────────────
FROM python:3.14-slim AS runtime
# Nova imagem limpa — sem gcc, sem headers, sem cache de compilação

# Copia apenas o virtualenv compilado do estágio anterior
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Usuário não-root
RUN groupadd --gid 1001 appuser \
    && useradd --uid 1001 --gid appuser --create-home appuser

WORKDIR /app
COPY --chown=appuser:appuser pipeline/ ./pipeline/
COPY --chown=appuser:appuser main.py .

USER appuser
CMD ["python", "main.py"]
```

---

## Volumes: persistência de dados

Containers são **efêmeros** — ao removê-los, todos os dados dentro são perdidos. Volumes resolvem isso.

### Tipos

| Tipo | Sintaxe | Uso |
|---|---|---|
| **Named volume** | `-v meus-dados:/app/data` | Dados persistentes gerenciados pelo Docker |
| **Bind mount** | `-v /host/path:/container/path` | Sincronizar código em desenvolvimento |
| **tmpfs** | `--tmpfs /tmp` | Dados temporários na RAM (não persistentes) |

### Named volumes

```powershell
# Criar volume
docker volume create postgres-data

# Usar volume em container
docker run -d \
    --name postgres-estudo \
    -v postgres-data:/var/lib/postgresql/data \
    -e POSTGRES_PASSWORD=estudo123 \
    postgres:16

# Listar volumes
docker volume ls

# Ver onde está salvo no host
docker volume inspect postgres-data
# "Mountpoint": "/var/lib/docker/volumes/postgres-data/_data"

# Remover volume (⚠️ apaga dados)
docker volume rm postgres-data

# Remover volumes não usados
docker volume prune
```

### Bind mounts — desenvolvimento local

```powershell
# Montar código local dentro do container para desenvolvimento
# Mudanças nos arquivos do host refletem imediatamente no container

docker run -d \
    --name pipeline-dev \
    -v ${PWD}/pipeline:/app/pipeline \
    -v ${PWD}/data:/app/data \
    minha-app:latest python -m watchdog pipeline/

# No docker-compose (mais comum em desenvolvimento):
# volumes:
#   - ./pipeline:/app/pipeline   # bind mount
#   - ./data:/app/data
```

---

## Networks: comunicação entre containers

Por padrão containers são isolados. Networks permitem que eles se comuniquem entre si.

### Tipos de network

| Driver | Quando usar |
|---|---|
| `bridge` | Padrão — containers na mesma máquina se comunicam pelo nome |
| `host` | Container compartilha a rede do host (performance, menos seguro) |
| `none` | Container completamente isolado da rede |
| `overlay` | Docker Swarm — múltiplas máquinas |

### Comunicação entre containers

```powershell
# Criar network
docker network create trilha-network

# Rodar Postgres na network
docker run -d \
    --name postgres-estudo \
    --network trilha-network \
    -e POSTGRES_PASSWORD=estudo123 \
    postgres:16

# Rodar app Python na mesma network
docker run -d \
    --name pipeline-app \
    --network trilha-network \
    -e DB_HOST=postgres-estudo \   # ← usa o NAME do container como hostname!
    -e DB_PORT=5432 \
    minha-app:latest

# Containers na mesma network se resolvem pelo nome → postgres-estudo:5432
# Não precisa expor portas com -p quando comunicação é interna
```

```powershell
# Inspecionar network
docker network inspect trilha-network

# Remover networks não usadas
docker network prune
```

---

## Environment variables e segurança

### Formas de passar variáveis

```powershell
# 1. Flag -e (simples, mas visível no docker ps e histórico do shell)
docker run -e DB_PASSWORD=estudo123 minha-app

# 2. Arquivo .env (nunca commitar no Git!)
docker run --env-file .env minha-app

# 3. docker-compose com .env (mais comum em desenvolvimento)
# compose lê automaticamente o .env na raiz do projeto
```

### No Dockerfile — nunca hardcode secrets

```dockerfile
# ❌ ERRADO — senha fica visível em qualquer layer da imagem
RUN pip install --extra-index-url https://user:SENHA@private.pypi.org/simple/ pacote

# ✅ CORRETO — usar ARG para build-time secrets (não persiste na imagem)
ARG PYPI_TOKEN
RUN pip install --extra-index-url https://__token__:${PYPI_TOKEN}@private.pypi.org/simple/ pacote
# Passar na build: docker build --build-arg PYPI_TOKEN=$TOKEN .

# ✅ MELHOR — Docker BuildKit secrets (nunca aparece em nenhuma layer)
# syntax=docker/dockerfile:1
RUN --mount=type=secret,id=pypi_token \
    pip install --extra-index-url https://__token__:$(cat /run/secrets/pypi_token)@... pacote
```

### Arquitetura de segredos em produção

```
Desenvolvimento:    .env file (no .gitignore)
CI/CD:              GitHub Actions Secrets → variável de ambiente
Produção (AWS):     AWS Secrets Manager ou Parameter Store
Produção (k8s):     Kubernetes Secrets
```

---

## docker-compose: orquestração local

docker-compose (ou `docker compose` v2) define múltiplos containers, networks e volumes em um arquivo YAML declarativo.

### Estrutura completa — projeto DE com Postgres + Adminer + Python

```yaml
# docker-compose.yml
version: "3.9"

services:

  # ─── Banco de dados ──────────────────────────────────────────────────────────
  postgres:
    image: postgres:16
    container_name: postgres-trilha
    environment:
      POSTGRES_DB: trilha
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: ${DB_PASSWORD}     # lê do arquivo .env
    ports:
      - "5432:5432"                          # host:container
    volumes:
      - postgres-data:/var/lib/postgresql/data    # named volume (persistente)
      - ./sql/init:/docker-entrypoint-initdb.d    # scripts SQL executados na 1ª inicialização
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - trilha-network
    restart: unless-stopped

  # ─── Interface web para Postgres ─────────────────────────────────────────────
  adminer:
    image: adminer:4.8.1
    container_name: adminer-trilha
    ports:
      - "8080:8080"
    environment:
      ADMINER_DEFAULT_SERVER: postgres
    depends_on:
      postgres:
        condition: service_healthy    # espera o healthcheck do postgres passar
    networks:
      - trilha-network
    restart: unless-stopped

  # ─── App Python (pipeline ETL) ────────────────────────────────────────────────
  pipeline:
    build:
      context: .                      # usa Dockerfile na raiz
      dockerfile: Dockerfile
      target: runtime                 # estágio do multi-stage build
    container_name: pipeline-trilha
    environment:
      DB_HOST: postgres               # nome do service no compose = hostname
      DB_PORT: 5432
      DB_NAME: trilha
      DB_USER: postgres
      DB_PASSWORD: ${DB_PASSWORD}
      PYTHONUNBUFFERED: 1
    volumes:
      - ./data:/app/data              # bind mount para output dos pipelines
      - ./pipeline:/app/pipeline      # bind mount para desenvolvimento (código sincronizado)
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - trilha-network
    command: python main.py           # sobrescreve CMD do Dockerfile

# ─── Volumes ───────────────────────────────────────────────────────────────────
volumes:
  postgres-data:
    driver: local

# ─── Networks ──────────────────────────────────────────────────────────────────
networks:
  trilha-network:
    driver: bridge
```

### Arquivo .env (nunca commitar!)

```env
# .env — na raiz do projeto
DB_PASSWORD=estudo123
POSTGRES_VERSION=16
```

### Comandos essenciais do docker-compose

```powershell
# Subir todos os services (em background)
docker compose up -d

# Subir e reconstruir imagens (após mudança no Dockerfile ou código)
docker compose up -d --build

# Ver logs de todos os services
docker compose logs -f

# Ver logs de um service específico
docker compose logs -f pipeline

# Ver status dos containers
docker compose ps

# Parar todos os containers (mantém volumes e networks)
docker compose stop

# Parar e remover containers (mantém volumes — dados preservados)
docker compose down

# Parar e remover containers E volumes (⚠️ apaga dados do banco)
docker compose down -v

# Executar comando em service rodando
docker compose exec postgres psql -U postgres -d trilha

# Escalar um service (múltiplas instâncias)
docker compose up -d --scale pipeline=3

# Ver configuração final (com variáveis substituídas)
docker compose config
```

---

## Docker Hub: publicar imagens

### Autenticação e push

```powershell
# Login (pede usuário e senha/token)
docker login

# Ou com token (mais seguro — usar Access Token do Docker Hub)
docker login -u MEU_USUARIO --password-stdin
# → colar o token e pressionar Enter, depois Ctrl+Z (Windows)

# Taguear a imagem com o namespace do Docker Hub
docker tag minha-app:1.0 meu-usuario/trilha-de-pipeline:1.0
docker tag minha-app:1.0 meu-usuario/trilha-de-pipeline:latest

# Push para o registry
docker push meu-usuario/trilha-de-pipeline:1.0
docker push meu-usuario/trilha-de-pipeline:latest

# Pull de qualquer máquina
docker pull meu-usuario/trilha-de-pipeline:latest
```

### Boas práticas de versionamento de imagens

```
meu-usuario/pipeline:latest      → sempre a versão mais recente (não recomendado em produção)
meu-usuario/pipeline:1.0.0       → versão SemVer estável
meu-usuario/pipeline:1.0.0-slim  → variante slim (menor)
meu-usuario/pipeline:sha-06d62f9 → commit hash do Git (rastreabilidade total)
```

### Automatizar com GitHub Actions

```yaml
# .github/workflows/docker-publish.yml
name: Build and Push Docker Image

on:
  push:
    tags: ["v*"]          # publica ao criar uma tag v1.0.0

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            ${{ secrets.DOCKERHUB_USERNAME }}/trilha-de-pipeline:latest
            ${{ secrets.DOCKERHUB_USERNAME }}/trilha-de-pipeline:${{ github.ref_name }}
```

---

## Padrões de produção para DE

### Pattern 1: Pipeline isolado por execução

```dockerfile
# Cada execução do pipeline cria um container novo, roda e morre
# Ideal para pipelines batch (Airflow tasks, AWS Batch, GCP Cloud Run Jobs)

FROM python:3.14-slim AS builder
# ... (multi-stage igual ao anterior)

FROM python:3.14-slim AS runtime
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /app
COPY pipeline/ ./pipeline/
COPY main.py .
USER appuser
ENTRYPOINT ["python", "main.py"]
# → docker run pipeline:1.0 --date=2026-05-08 --source=s3://bucket/...
```

### Pattern 2: Ambiente de desenvolvimento completo

```yaml
# docker-compose.dev.yml — sobrescreve o compose principal em desenvolvimento
services:
  pipeline:
    build:
      target: builder               # usa estágio com devdeps (pytest, black, etc.)
    volumes:
      - .:/app                      # código completo montado (hot-reload)
    command: sleep infinity         # container fica rodando aguardando comandos
    # → docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
    # → docker compose exec pipeline pytest
    # → docker compose exec pipeline python -m ipykernel install
```

### Pattern 3: Healthchecks e restart policies

```yaml
services:
  pipeline:
    restart: unless-stopped     # reinicia automaticamente se crashar (exceto se parado manualmente)
    # Outras opções:
    # restart: no              → não reinicia (default)
    # restart: always          → sempre reinicia (inclusive após docker daemon restart)
    # restart: on-failure:3    → reinicia até 3 vezes em caso de erro
```

### Tamanho de imagem — referência para Python DE

| Imagem base | Tamanho aprox. | Indicado para |
|---|---|---|
| `python:3.14` | ~1.0 GB | Nunca — muito grande |
| `python:3.14-slim` | ~120 MB | Maioria dos casos |
| `python:3.14-alpine` | ~50 MB | Apenas apps simples (problemas com libs C) |
| Multi-stage (slim) | ~200-400 MB | Apps com deps compiladas (pyarrow, grpcio) |

---

## Exercícios Resolvidos — Docker

### Q1 — Primeiro container Python

**Objetivo:** construir e rodar uma imagem Docker com Python + Polars.

**`hello_pipeline.py`:**
```python
import polars as pl
import os

vendas = pl.DataFrame({
    "produto":    ["Notebook", "Mouse", "Teclado", "Monitor", "Headset"],
    "categoria":  ["Eletrônicos", "Periféricos", "Periféricos", "Eletrônicos", "Periféricos"],
    "valor":      [3500.00, 120.00, 280.00, 1800.00, 350.00],
    "quantidade": [2, 10, 5, 3, 7],
})

resultado = (
    vendas
    .with_columns((pl.col("valor") * pl.col("quantidade")).alias("total"))
    .group_by("categoria")
    .agg(pl.col("total").sum().alias("faturamento_total"))
    .sort("faturamento_total", descending=True)
)

print("=" * 45)
print("  Faturamento por categoria")
print("=" * 45)
print(resultado)
print()
print("✅ Pipeline executado dentro do container Docker!")
print(f"   Python rodando em: {os.uname().sysname if hasattr(os, 'uname') else 'Windows container'}")
```

**`Dockerfile` (v1 — baseline):**
```dockerfile
FROM python:3.14-slim

RUN pip install --no-cache-dir polars pyarrow

COPY hello_pipeline.py /app/hello_pipeline.py

WORKDIR /app

CMD ["python", "hello_pipeline.py"]
```

**Comandos:**
```powershell
docker build -t trilha-hello:1.0 .
docker run --rm trilha-hello:1.0
```

**Output:**
```
=============================================
  Faturamento por categoria
=============================================
shape: (2, 2)
┌─────────────┬───────────────────┐
│ categoria   ┆ faturamento_total │
╞═════════════╪═══════════════════╡
│ Eletrônicos ┆ 12400.0           │
│ Periféricos ┆ 5050.0            │
└─────────────┴───────────────────┘

✅ Pipeline executado dentro do container Docker!
   Python rodando em: Linux
```

**Aprendizado-chave:** mesmo no Windows, containers rodam sobre kernel Linux via Docker Desktop. A flag `--rm` remove o container automaticamente após a execução — o container é efêmero.

---

### Q2 — Otimizando com cache, .dockerignore e usuário não-root

**Problema identificado:** na versão Q1, o `pip install` estava antes do `COPY` do código, mas qualquer mudança no código reinvalidava o cache de forma desnecessária. Além disso, o container rodava como `root`.

**`Dockerfile` (v2 — otimizado):**
```dockerfile
FROM python:3.14-slim

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

RUN useradd --no-create-home appuser && chown appuser:appuser /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=appuser:appuser . .

USER appuser

CMD ["python", "hello_pipeline.py"]
```

**Ordem das camadas — por que importa:**
```
COPY requirements.txt .          ← muda raramente → cache reutilizado
RUN pip install ...               ← ~30s de instalação → CACHED na maioria dos rebuilds
COPY --chown=appuser:appuser . .  ← muda sempre → sem cache, mas só copia arquivos (rápido)
```
Se o `COPY . .` viesse antes do `pip install`, qualquer edição no código Python forçaria reinstalar todas as dependências.

**`.dockerignore`:**
```dockerignore
.git/
.gitignore
.venv/
venv/
env/
__pycache__/
*.pyc
*.pyo
*.pyd
.pytest_cache/
.mypy_cache/
.ruff_cache/
*.md
.env
.env.*
*.log
.DS_Store
Thumbs.db
```

**`requirements.txt`:**
```
polars
pyarrow
```

**Validação:**
```powershell
docker build -t trilha-hello:2.0 .
docker run --rm trilha-hello:2.0 whoami
# appuser  ← não root

docker run --rm trilha-hello:2.0 touch /app/teste.txt
# Permission denied ← arquivos pertenciam ao root (bug encontrado)
```

**Bug encontrado e corrigido:** `useradd` e `COPY . .` estavam na ordem errada — os arquivos eram copiados com dono `root` e o `appuser` não conseguia escrever em `/app`. Solução: criar o usuário **antes** do `COPY`, usar `--chown` e garantir que o próprio diretório `/app` pertença ao `appuser` com `chown appuser:appuser /app`.

```powershell
# Após a correção:
docker build -t trilha-hello:3.0 .
docker run --rm trilha-hello:3.0 touch /app/teste.txt   # sem erro
docker run --rm trilha-hello:3.0 ls -la /app
# drwxr-xr-x 1 appuser appuser ... .
# -rwxr-xr-x 1 appuser appuser ... hello_pipeline.py
```

---

### Q3 — Multi-stage build

**Objetivo:** separar a fase de instalação de dependências (builder) da imagem final (runtime), reduzindo o que vai para produção.

**Por que usar virtualenv no builder (e não pip install global):**
Quando o pip instala globalmente, os pacotes se espalham por `/usr/local/lib/python3.x/site-packages/`, `/usr/local/bin/` etc. — misturados com a stdlib e arquivos do SO. Com `python -m venv /opt/venv`, tudo fica em um diretório autocontido. O `COPY --from=builder /opt/venv /opt/venv` leva exatamente e somente as dependências instaladas, sem arrastar o compilador, headers ou qualquer outra coisa do estágio de build.

**`Dockerfile.multistage`:**
```dockerfile
# ── Estágio 1: builder ────────────────────────────────────────────────────────
FROM python:3.14-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ── Estágio 2: runtime ────────────────────────────────────────────────────────
FROM python:3.14-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN useradd --no-create-home appuser && chown appuser:appuser /app

COPY --chown=appuser:appuser . .

USER appuser

CMD ["python", "hello_pipeline.py"]
```

**Comparação de tamanhos (CONTENT SIZE):**
```
REPOSITORY       TAG          CONTENT SIZE
trilha-hello     1.0          158MB
trilha-hello     2.0          154MB
trilha-hello     3.0          154MB
trilha-hello     multistage   158MB   ← ligeiramente maior!
```

**Por que o multistage ficou maior neste caso:**
O virtualenv carrega overhead que o pip install global não tem. O `python -m venv` instala automaticamente `pip` e `setuptools` dentro do próprio venv — mesmo que a imagem base já os tenha. O delta de ~4MB é exatamente esses pacotes duplicados.

**Quando multi-stage realmente compensa:**

| Cenário | Builder | Runtime | Economia típica |
|---|---|---|---|
| Deps puras Python (este exercício) | slim + venv | slim + venv | 0 (até negativo) |
| Lib com C extension (numpy, grpcio) | slim + gcc + build-essential | slim + venv | ~300–500MB |
| App Go/Rust | OS + compilador | scratch ou distroless | ~800MB+ |

**Lição:** multi-stage não é sempre melhor. Para dependências puras Python instaladas via wheels pré-compilados, o pip install direto é mais eficiente. O ganho real aparece quando o builder precisa de ferramentas pesadas (gcc, CMake, Rust) que não têm lugar no runtime.

---

### Q4 — Pipeline ETL conectando ao PostgreSQL

**Objetivo:** container Python que extrai dados do PostgreSQL, transforma com Polars e salva resultado de volta no banco.

**Decisões de design:**

1. **Variáveis de ambiente, não hardcode:** `localhost:5432` dentro de um container aponta para o próprio container, não para o host nem para outro container. A mesma imagem precisa funcionar em dev, staging e produção — quem sabe o endereço é quem sobe o container.

2. **Network user-defined:** na rede bridge padrão, containers não resolvem nomes entre si. Em uma rede user-defined, o Docker fornece DNS automático — o container Python usa o nome do container Postgres como hostname.

3. **`psycopg2-binary` não `psycopg2`:** em imagens `slim` sem `gcc` e `build-essential`, o `psycopg2` puro falha na instalação (precisa ser compilado). A variante `-binary` vem pré-compilada.

**`Dockerfile.etl`:**
```dockerfile
FROM python:3.14-slim

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

WORKDIR /app

RUN useradd --no-create-home appuser && chown appuser:appuser /app

COPY requirements-etl.txt .
RUN pip install --no-cache-dir -r requirements-etl.txt

COPY --chown=appuser:appuser etl_pipeline.py .

USER appuser

CMD ["python", "etl_pipeline.py"]
```

**`requirements-etl.txt`:**
```
polars
psycopg2-binary
```

**`etl_pipeline.py`:**
```python
import os
import polars as pl
import psycopg2

DB_HOST = os.environ.get("DB_HOST", "localhost")
DB_PORT = os.environ.get("DB_PORT", "5432")
DB_NAME = os.environ.get("DB_NAME", "postgres")
DB_USER = os.environ.get("DB_USER", "postgres")
DB_PASS = os.environ.get("DB_PASS", "")

def extract(conn) -> pl.DataFrame:
    query = """
        SELECT p.categoria,
               SUM(ip.quantidade * ip.preco_unit) AS faturamento_total
        FROM itens_pedido ip
        JOIN produtos p ON ip.id_produto = p.id_produto
        GROUP BY p.categoria
        ORDER BY faturamento_total DESC
    """
    with conn.cursor() as cur:
        cur.execute(query)
        rows = cur.fetchall()
        cols = [desc[0] for desc in cur.description]
    return pl.DataFrame(rows, schema=cols, orient="row")

def transform(df: pl.DataFrame) -> pl.DataFrame:
    total = df["faturamento_total"].sum()
    return df.with_columns(
        (pl.col("faturamento_total") / total * 100).round(2).alias("percentual")
    )

def load(df: pl.DataFrame, conn) -> None:
    with conn.cursor() as cur:
        cur.execute("""
            DROP TABLE IF EXISTS resumo_faturamento_categoria;
            CREATE TABLE resumo_faturamento_categoria (
                categoria         VARCHAR(100),
                faturamento_total NUMERIC(12,2),
                percentual        NUMERIC(5,2)
            )
        """)
        for row in df.iter_rows(named=True):
            cur.execute(
                "INSERT INTO resumo_faturamento_categoria VALUES (%s, %s, %s)",
                (row["categoria"], row["faturamento_total"], row["percentual"])
            )
    conn.commit()

def main():
    conn = psycopg2.connect(
        host=DB_HOST, port=DB_PORT, dbname=DB_NAME, user=DB_USER, password=DB_PASS
    )
    try:
        df_raw   = extract(conn)
        df_final = transform(df_raw)
        load(df_final, conn)
    finally:
        conn.close()

if __name__ == "__main__":
    main()
```

**Bug de encoding encontrado e corrigido:**
Output original mostrava `Eletr??nicos`, `Perif??ricos` — cada `??` representava um byte UTF-8 multibyte tratado individualmente como ASCII desconhecido. A imagem `python:slim` não instala locales; o padrão é POSIX (ASCII). Solução: adicionar `PYTHONIOENCODING=utf-8`, `LANG=C.UTF-8` e `LC_ALL=C.UTF-8` no Dockerfile. Havia também um bug paralelo de encoding no pipe do PowerShell ao inserir o SQL — resolvido usando `docker cp` + `psql -f` diretamente.

**Comandos para rodar manualmente:**
```powershell
docker start postgres-estudo
docker network create trilha-network
docker network connect trilha-network postgres-estudo
docker build -f Dockerfile.etl -t trilha-etl:1.0 .
docker run --rm `
    --network trilha-network `
    -e DB_HOST=postgres-estudo `
    -e DB_NAME=postgres `
    -e DB_USER=postgres `
    -e DB_PASS=estudo123 `
    trilha-etl:1.0
```

---

### Q5 — docker-compose: orquestração completa

**Objetivo:** `docker compose up --build` sobe Postgres + ETL pipeline, com dataset carregado automaticamente e healthcheck garantindo a ordem correta de inicialização.

**`docker-compose.yml`:**
```yaml
services:

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: estudo123
      POSTGRES_DB: postgres
    volumes:
      - ../../sql/setup_dataset.sql:/docker-entrypoint-initdb.d/setup_dataset.sql:ro
      - pg_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres -d postgres"]
      interval: 5s
      timeout: 5s
      retries: 5
      start_period: 10s

  etl:
    build:
      context: .
      dockerfile: Dockerfile.etl
    environment:
      DB_HOST: db
      DB_PORT: "5432"
      DB_NAME: postgres
      DB_USER: postgres
      DB_PASS: estudo123
    depends_on:
      db:
        condition: service_healthy
    restart: "no"

volumes:
  pg_data:
```

**Decisões técnicas:**

| Decisão | Motivo |
|---|---|
| `postgres:16-alpine` | Menor que `postgres:16` (~85MB vs ~400MB), sem sacrificar funcionalidade |
| `setup_dataset.sql` montado em `initdb.d/` | Postgres executa todos os `.sql` neste diretório na primeira inicialização — sem `docker cp` manual |
| `pg_data` volume nomeado | Dados persistem entre `docker compose up/down`; só `down -v` apaga |
| `DB_HOST: db` | Nome do serviço no compose = hostname resolvido via DNS interno automático |
| `condition: service_healthy` | Aguarda `pg_isready` passar antes de iniciar o ETL — garante que o Postgres aceita conexões |
| `restart: "no"` | ETL é job pontual (batch), não serviço contínuo |

**Output do `docker compose up --build`:**
```
✔ Network ex6_docker_default  Created
✔ Volume ex6_docker_pg_data   Created
✔ Container ex6_docker-db-1   Created
✔ Container ex6_docker-etl-1  Created

db-1  | running /docker-entrypoint-initdb.d/setup_dataset.sql
db-1  | INSERT 0 34    ← dataset carregado automaticamente
db-1  | database system is ready to accept connections
etl-1 | [1/3] Extraindo dados do PostgreSQL...
etl-1 | │ Eletrônicos ┆ 32400.00 │
etl-1 | │ Periféricos ┆  3916.20 │
etl-1 | [3/3] Carregando resultado em resumo_faturamento_categoria...
etl-1 |   Tabela criada com sucesso.
etl-1 exited with code 0
```

**Limpeza:**
```powershell
docker compose down      # remove containers e rede, preserva volume (dados)
docker compose down -v   # remove tudo incluindo volume (⚠️ apaga dados do banco)
```

---

---

# APACHE SPARK / PYSPARK

> Spark é o motor de processamento distribuído mais usado em Data Engineering.
> Entender como ele funciona por dentro é o que separa quem "usa Spark" de quem "entende Spark".

---

## Por que Spark existe — o problema que ele resolve

### O problema: dados maiores que uma máquina

Em 2004, o Google publicou o paper **MapReduce** — um modelo para processar terabytes de dados dividindo o trabalho entre centenas de máquinas. O Hadoop implementou isso em Java, mas era lento: cada etapa do processamento escrevia no disco (HDFS) antes de passar para a próxima.

**Spark (2009, UC Berkeley AMP Lab)** resolveu o gargalo principal: processamento **em memória**. Em vez de escrever no disco entre cada etapa, o Spark mantém os dados em RAM sempre que possível. Resultado: até **100x mais rápido** que MapReduce para workloads iterativos (machine learning, SQL analítico).

### Quando usar Spark vs alternativas

| Volume | Ferramenta certa |
|---|---|
| < 1GB | Polars ou Pandas |
| 1GB – 100GB | DuckDB, Polars LazyFrame |
| > 100GB / múltiplas máquinas | **Spark** |
| Streaming em tempo real | Spark Structured Streaming, Flink |

Spark tem overhead de inicialização (~10s para criar SparkSession). Para datasets pequenos, Polars ou DuckDB são melhores escolhas.

---

## Arquitetura: Driver, Executors e Cluster Manager

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          CLUSTER MANAGER                                │
│              (YARN / Kubernetes / Standalone / Mesos)                   │
│           Aloca recursos (CPU/RAM) para a aplicação Spark               │
└──────────────────────────┬──────────────────────────────────────────────┘
                           │
           ┌───────────────▼───────────────┐
           │           DRIVER              │
           │  SparkContext / SparkSession   │  ← seu código Python roda aqui
           │  Analisa o código              │
           │  Cria o DAG de execução        │
           │  Divide em stages e tasks      │
           │  Coordena os executors         │
           └──────┬──────────────┬──────────┘
                  │              │
       ┌──────────▼──┐      ┌────▼──────────┐
       │  EXECUTOR 1 │      │  EXECUTOR 2   │   ← processos JVM nas máquinas worker
       │  ┌────────┐ │      │  ┌──────────┐ │
       │  │ Task 1 │ │      │  │  Task 3  │ │   ← menor unidade de trabalho
       │  │ Task 2 │ │      │  │  Task 4  │ │   ← processa 1 partition
       │  └────────┘ │      │  └──────────┘ │
       │  Cache/RAM  │      │  Cache/RAM    │
       └─────────────┘      └───────────────┘
```

### Responsabilidades de cada componente

**Driver:**
- Processo principal onde seu código Python/Scala/Java roda
- Cria a `SparkSession` (ponto de entrada da aplicação)
- Traduz transformações em um DAG (grafo acíclico dirigido)
- Programa tasks nos executors via o Cluster Manager
- Coleta resultados das actions

**Executor:**
- Processo JVM rodando em cada máquina worker
- Executa as tasks enviadas pelo Driver
- Armazena dados em cache (memória ou disco)
- Reporta status e resultados de volta ao Driver
- Cada executor pode ter múltiplos slots de task (= threads)

**Cluster Manager:**
- Gerencia os recursos do cluster
- Aloca CPU e RAM para a aplicação Spark
- **Standalone**: próprio do Spark, simples
- **YARN**: padrão no Hadoop ecosystem (EMR, Dataproc)
- **Kubernetes**: padrão moderno em cloud
- **Local**: Driver e Executor no mesmo processo (desenvolvimento/testes)

### Modo local (desenvolvimento)

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("meu-pipeline") \
    .master("local[*]") \
    .getOrCreate()
# local[*] = usa todos os cores da máquina
# local[1] → 1 thread (sem paralelismo, bom para debug)
# local[4] → 4 threads
```

---

## O modelo de dados: RDD, DataFrame e Dataset

### Evolução histórica

```
2009  RDD (Resilient Distributed Dataset)
         ↓
2013  DataFrame (Spark SQL) — API de alto nível com otimizador (Catalyst)
         ↓
2015  Dataset (Scala/Java) — tipo seguro em compile-time
         ↓
2020+ DataFrame = Dataset[Row] em Python — DataFrame é o padrão atual
```

### RDD — a fundação

O **RDD** é a abstração original do Spark: uma coleção distribuída e imutável de objetos particionada entre as máquinas do cluster.

```python
sc = spark.sparkContext
rdd = sc.parallelize([1, 2, 3, 4, 5, 6], numSlices=3)
# numSlices=3 → 3 partições distribuídas entre os executors

rdd_dobrado = rdd.map(lambda x: x * 2)     # transformação (lazy)
rdd_par = rdd_dobrado.filter(lambda x: x > 4)  # transformação (lazy)
resultado = rdd_par.collect()               # action → executa tudo → [6, 8, 10, 12]
```

**Características:**
- **Resilient**: recalcula partições perdidas usando lineage (grafo de como foi construído)
- **Distributed**: particionado entre múltiplas máquinas
- **Imutável**: transformações criam novos RDDs
- **Sem schema**: Spark não conhece os tipos → não consegue otimizar

### DataFrame — o padrão atual

DataFrame tem **schema** (colunas com tipos definidos). O otimizador **Catalyst** pode reordenar, combinar e otimizar operações automaticamente.

```python
from pyspark.sql.types import StructType, StructField, StringType, DoubleType, IntegerType

schema = StructType([
    StructField("id_pedido",  IntegerType(), nullable=False),
    StructField("categoria",  StringType(),  nullable=True),
    StructField("valor",      DoubleType(),  nullable=True),
])
df = spark.read.csv("dados.csv", header=True, schema=schema)
```

### Catalyst Optimizer — o que acontece por dentro

```
Código Python/SQL
      ↓
  Unresolved Logical Plan   (parse)
      ↓
  Resolved Logical Plan     (verifica que colunas existem no schema)
      ↓
  Optimized Logical Plan    (predicate pushdown, column pruning, etc.)
      ↓
  Physical Plans            (múltiplas estratégias possíveis)
      ↓
  Selected Physical Plan    (Cost Model escolhe o mais barato)
      ↓
  Tungsten (code generation) → JVM bytecode otimizado
```

- **Predicate pushdown**: filtros são empurrados antes de joins/aggregations — lê menos dados
- **Column pruning**: colunas não usadas são eliminadas antes de ler o arquivo

---

## Lazy evaluation: transformações vs actions

### Transformações — não executam imediatamente

```python
# Nenhuma dessas linhas toca nos dados — apenas constroem o plano
df_filtrado = df.filter(F.col("valor") > 1000)
df_agrupado = df_filtrado.groupBy("categoria").agg(F.sum("valor").alias("total"))
df_ordenado = df_agrupado.orderBy(F.col("total").desc())
```

**Narrow (sem shuffle):** cada partition de output depende de no máximo uma partition de input.
```python
df.filter(...)       # narrow — processamento local
df.select(...)       # narrow
df.withColumn(...)   # narrow
```

**Wide (com shuffle):** dados de múltiplas partitions precisam ser combinados.
```python
df.groupBy(...).agg(...)   # wide — shuffle
df.join(other, ...)        # wide — shuffle
df.orderBy(...)            # wide — shuffle global
df.distinct()              # wide — shuffle
```

### Actions — disparam a execução

```python
df_ordenado.show(20)              # exibe no console
df_ordenado.collect()             # retorna lista de Row para o Driver ⚠️ cuidado com memória
df_ordenado.count()               # conta registros
df_ordenado.first()               # primeiro registro
df_ordenado.take(5)               # primeiros N registros
df_ordenado.toPandas()            # converte para Pandas ⚠️ carrega tudo no Driver
df_ordenado.write.parquet(path)   # salva em disco
```

### Por que lazy evaluation é uma vantagem

O Catalyst combina múltiplas transformações em um único passo otimizado, aplica predicate pushdown e column pruning antes de ler o arquivo. Sem lazy evaluation, cada transformação executaria separadamente, relendo os dados.

---

## DAG de execução: jobs, stages e tasks

```
ACTION → JOB
          │
          ├─ STAGE 0 (narrow transformations)
          │     ├─ Task 0 (partition 0)
          │     ├─ Task 1 (partition 1)
          │     └─ Task 2 (partition 2)
          │          ↓ SHUFFLE BOUNDARY (wide transformation)
          └─ STAGE 1 (após shuffle)
                ├─ Task 3 (partition 0 do shuffle output)
                └─ Task 4 (partition 1 do shuffle output)
```

- **Job**: uma action = um job
- **Stage**: grupo de transformações sem shuffle entre elas. Fronteira = wide transformation
- **Task**: processa **uma partition**. Tasks do mesmo stage rodam em paralelo

### Ver o plano de execução

```python
df_resultado.explain()                    # plano físico resumido
df_resultado.explain(mode="formatted")    # plano detalhado (Spark 3.0+)
# Procure por: Exchange (shuffle), HashAggregate, Filter, FileScan
```

O **Spark UI** fica em `http://localhost:4040` durante a execução — mostra o DAG visual, duração de cada stage/task e quantidade de shuffle read/write.

---

## Shuffle: o inimigo da performance

Shuffle redistribui dados entre partições — registros com a mesma chave precisam ir para o mesmo executor.

```
ANTES:                               DEPOIS:
Partition 0: [A=10, B=5, A=3]        Partition 0: [A=10, A=3, A=7]
Partition 1: [B=2,  C=8, A=7]   →   Partition 1: [B=5,  B=2, B=9]
Partition 2: [C=1,  B=9, C=4]        Partition 2: [C=8,  C=1, C=4]
```

Custo: escrita em disco + transferência de rede entre todos os executors.

### Como minimizar shuffle

```python
# 1. Filtrar ANTES de agregar
df.filter(F.col("valor") > 0).groupBy("categoria").agg(F.sum("valor"))

# 2. Broadcast join — elimina shuffle em joins com tabelas pequenas
from pyspark.sql.functions import broadcast
df_pedidos.join(broadcast(df_categorias), "id_categoria")
# Automático quando tabela < spark.sql.autoBroadcastJoinThreshold (default: 10MB)

# 3. Reduzir spark.sql.shuffle.partitions (default 200 é excessivo para dados pequenos)
spark.conf.set("spark.sql.shuffle.partitions", "8")

# 4. AQE — Adaptive Query Execution (Spark 3.0+): ajuste automático
spark.conf.set("spark.sql.adaptive.enabled", "true")
```

---

## Particionamento: a unidade de paralelismo

```python
df.rdd.getNumPartitions()       # ver número de partições atuais

df.repartition(16)              # aumentar (COM shuffle — redistribuição por hash)
df.repartition(16, "categoria") # reparticionar por coluna (otimiza joins subsequentes)
df.coalesce(4)                  # diminuir (SEM shuffle — combina partições adjacentes)

# Regra prática: ~128MB por partition, pelo menos tantas quanto cores disponíveis
```

---

## SparkSession e configuração

```python
from pyspark.sql import SparkSession

spark = (
    SparkSession.builder
    .appName("pipeline-vendas")
    .master("local[*]")
    .config("spark.driver.memory", "4g")
    .config("spark.sql.shuffle.partitions", "8")
    .config("spark.sql.adaptive.enabled", "true")
    .config("spark.sql.adaptive.coalescePartitions.enabled", "true")
    .getOrCreate()
)
spark.sparkContext.setLogLevel("WARN")   # reduzir logs verbosos
```

---

## DataFrame API essencial

```python
from pyspark.sql import functions as F
from pyspark.sql.window import Window

# ─── Leitura ──────────────────────────────────────────────────────────────────
df = spark.read.option("header", "true").option("inferSchema", "true").csv("dados.csv")
df = spark.read.parquet("dados/")

# ─── Seleção / filtros / novas colunas ────────────────────────────────────────
df.select("id", "categoria", F.col("valor") * 1.1)
df.filter((F.col("categoria") == "Eletrônicos") & F.col("valor").isNotNull())
df.withColumn("valor_com_iva", F.col("valor") * 1.23)
df.withColumnRenamed("old", "new")

# ─── Aggregações ──────────────────────────────────────────────────────────────
df.groupBy("categoria").agg(
    F.sum("valor").alias("total"),
    F.avg("valor").alias("media"),
    F.count("*").alias("qtd"),
    F.countDistinct("id_cliente").alias("clientes_unicos"),
)

# ─── Joins ────────────────────────────────────────────────────────────────────
df_pedidos.join(df_clientes, on="id_cliente", how="left")
df_pedidos.join(broadcast(df_categorias), "id_categoria")

# ─── Window Functions ─────────────────────────────────────────────────────────
w = Window.partitionBy("categoria").orderBy(F.col("valor").desc())
df.withColumn("rank", F.rank().over(w))
df.withColumn("lag_valor", F.lag("valor", 1).over(
    Window.partitionBy("id_cliente").orderBy("data_pedido")
))

# ─── Escrita ──────────────────────────────────────────────────────────────────
df.write.mode("overwrite").partitionBy("ano", "mes").parquet("output/vendas/")
df.coalesce(1).write.mode("overwrite").parquet("output/resultado_final/")
# coalesce(1) antes de escrever evita centenas de arquivos pequenos
```

---

## Exercícios Resolvidos — Spark

### Q1 — SparkSession, leitura e primeiras transformações

**Conceitos praticados:** SparkSession, `createDataFrame`, `filter`, `withColumn`, `select`, `explain()`, lazy evaluation.

```python
import os
os.environ["JAVA_HOME"] = r"C:\Program Files\Java\jre1.8.0_471"  # necessário se JAVA_HOME não estiver nas variáveis de sistema

from pyspark.sql import SparkSession
from pyspark.sql.functions import col

spark = SparkSession.builder \
    .appName("Exercicio_Q1") \
    .master("local[*]") \
    .config("spark.sql.shuffle.partitions", "4") \
    .config("spark.ui.enabled", "false") \
    .getOrCreate()
spark.sparkContext.setLogLevel("ERROR")

dados_pedidos = [
    (1, 150.0, "entregue"), (2, 80.0, "processando"), (3, 200.0, "entregue"),
    (4, 50.0, "cancelado"), (5, 300.0, "entregue"), (6, 120.0, "entregue"),
    (7, 90.0, "processando"), (8, 400.0, "entregue"), (9, 25.0, "entregue"),
    (10, 600.0, "cancelado")
]
df_pedidos = spark.createDataFrame(dados_pedidos, schema=["id_pedido", "valor", "status"])

df_transformado = (
    df_pedidos
    .filter(col("status") == "entregue")
    .withColumn("valor_com_taxa", col("valor") * 1.1)
    .select("id_pedido", "valor_com_taxa")
)

df_transformado.explain()
df_transformado.show()
```

**Plano gerado (output real):**
```
== Physical Plan ==
*(1) Project [id_pedido#0L, (valor#1 * 1.1) AS valor_com_taxa#6]
+- *(1) Filter (isnotnull(status#2) AND (status#2 = entregue))
   +- *(1) Scan ExistingRDD[id_pedido#0L,valor#1,status#2]
```

**Lições do plano:**
- Prefixo `*(1)` = **WholeStageCodegen**: Catalyst fundiu Scan + Filter + Project em um único bloco JVM compilado — seus 3 passos viram 1 só.
- `isnotnull(status)` foi adicionado automaticamente pelo Catalyst — ele sabe que `filter(col == valor)` nunca pode ser verdadeiro para `null`.
- Nenhum `Exchange` = nenhum shuffle = **1 stage único**. Comportamento ideal para transformações narrow.
- `explain()` não executou os dados — ele apenas imprime o plano já construído no DAG desde o último `select()`. O processamento só ocorre quando uma action é chamada (`show()`, `count()`, `collect()`).

**Bug de ponto flutuante** (`220.00000000000003`): comportamento normal de IEEE 754. Em produção: `F.round(col, 2)` antes de escrever.

---

### Q2 — Narrow vs Wide: identificando shuffle boundaries

**Conceitos praticados:** `explain(mode="formatted")`, `Exchange`, `HashAggregate` two-phase, `hashpartitioning` vs `rangepartitioning`, stages.

```python
from pyspark.sql.functions import col, avg

data = [(i, f"Produto_{i % 5}", i * 10.5) for i in range(1, 51)]
df = spark.createDataFrame(data, ["id", "categoria", "preco"])

df_final = (
    df
    .filter(col("preco") > 100)
    .withColumn("preco_com_desconto", col("preco") * 0.9)
    .groupBy("categoria")
    .agg(avg("preco_com_desconto").alias("media_preco"))
    .orderBy("media_preco")
)

df_final.explain(mode="formatted")
```

**Plano real — com `orderBy` (2 `Exchange`, 3 stages):**
```
Sort
+- Exchange (7) rangepartitioning(media_preco, 200)      ← stage boundary 2
   +- HashAggregate (final)
      +- Exchange (5) hashpartitioning(categoria, 200)   ← stage boundary 1
         +- HashAggregate (partial_avg)
            +- Project (withColumn)
               +- Filter
                  +- Scan ExistingRDD
```

**Sem `orderBy` (1 `Exchange`, 2 stages):** Exchange (7) e Sort desaparecem.

**Lições:**
- **Two-phase aggregation**: o Catalyst inseriu `partial_avg` automaticamente antes do shuffle. Cada executor calcula `sum` e `count` locais e envia apenas esses dois números pela rede — não os registros brutos. Reduz o volume do shuffle em 10–100x.
- **Dois tipos de `Exchange`**: `hashpartitioning` (garante que mesma chave vai pro mesmo executor) vs `rangepartitioning` (divide intervalos de valores para ordenação global).
- **`hashpartitioning(categoria, 200)`** para 5 categorias únicas = 195 partições vazias. Usar `spark.sql.shuffle.partitions = "4"` ou AQE resolve isso.
- Transformações **narrow**: `filter`, `withColumn`, `HashAggregate partial` (processamento local).
- Transformações **wide**: `groupBy + agg`, `orderBy` (exigem shuffle).

---

### Q3 — DataFrame API: join, Window Functions, lag()

**Conceitos praticados:** `join`, `Window.partitionBy`, `rank()`, `lag()`, crescimento percentual, `groupBy + agg`.

```python
from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Dados
clientes = [
    (1, "João Silva",     "Premium"),
    (2, "Maria Oliveira", "Standard"),
    (3, "Pedro Costa",    "Premium"),
    (4, "Lucia Alves",    "Standard"),
    (5, "Roberto Nunes",  "Premium"),
]
df_clientes = spark.createDataFrame(clientes, ["id_cliente", "nome", "segmento"])

pedidos = [(i, (i % 5) + 1, round(random.uniform(50, 1500), 2),
            categorias[i % 4], (i % 12) + 1)
           for i in range(1, 21)]
df_pedidos = spark.createDataFrame(
    pedidos, ["id_pedido", "id_cliente", "valor", "categoria", "mes"]
)
```

**Q3.1 — Join + filtro por segmento:**
```python
df_q31 = (
    df_pedidos
    .join(df_clientes, on="id_cliente", how="inner")
    .filter(F.col("segmento") == "Premium")
    .select("id_pedido", "nome", "segmento", "categoria", "valor", "mes")
    .orderBy("id_pedido")
)
```

**Q3.2 — Ranking por cliente (Window Function):**
```python
janela_cliente = Window.partitionBy("id_cliente").orderBy(F.col("valor").desc())

df_q32 = (
    df_pedidos
    .withColumn("rank_valor", F.rank().over(janela_cliente))
    .join(df_clientes, on="id_cliente", how="inner")
    .select("id_cliente", "nome", "id_pedido", "valor", "rank_valor")
    .orderBy("id_cliente", "rank_valor")
)
# rank()       → pula números em empate (1, 1, 3)
# dense_rank() → não pula (1, 1, 2)
# row_number() → único sempre, ordem arbitrária nos empates (1, 2, 3)
```

**Q3.3 — Crescimento mês a mês com lag():**
```python
df_mensal = (
    df_pedidos
    .groupBy("mes")
    .agg(F.round(F.sum("valor"), 2).alias("faturamento"))
    .orderBy("mes")
)

janela_mes = Window.orderBy("mes")  # sem partitionBy = sequência global

df_q33 = (
    df_mensal
    .withColumn("fat_mes_anterior", F.lag("faturamento", 1).over(janela_mes))
    .withColumn(
        "crescimento_pct",
        F.round(
            (F.col("faturamento") - F.col("fat_mes_anterior"))
            / F.col("fat_mes_anterior") * 100,
            2
        )
    )
)
# lag(col, offset=1) → valor da linha anterior na janela
# Primeira linha retorna null (sem mês anterior) — esperado e correto
# Em produção com múltiplos anos: Window.partitionBy("ano").orderBy("mes")
```

**Q3.4 — Top categoria por valor médio:**
```python
df_q34 = (
    df_pedidos
    .groupBy("categoria")
    .agg(F.round(F.avg("valor"), 2).alias("ticket_medio"))
    .orderBy(F.col("ticket_medio").desc())
    .limit(1)
)

# Alternativa com dense_rank() — ranqueia todas as categorias sem limit:
janela_rank = Window.orderBy(F.col("ticket_medio").desc())
df_todas = (
    df_pedidos
    .groupBy("categoria")
    .agg(F.round(F.avg("valor"), 2).alias("ticket_medio"))
    .withColumn("rank", F.dense_rank().over(janela_rank))
)
```

---

### Q4 — Performance: broadcast join, shuffle.partitions, AQE

**Conceitos praticados:** `broadcast()`, `SortMergeJoin` vs `BroadcastHashJoin`, `spark.sql.shuffle.partitions`, `autoBroadcastJoinThreshold`.

```python
# df_grande: 1000 registros (tabela fato)
# df_categorias: 10 registros (tabela dimensão — candidata a broadcast)

# Cenário A — join padrão (broadcast desativado)
spark.conf.set("spark.sql.autoBroadcastJoinThreshold", "-1")
df_join_a = df_grande.join(df_categorias, on="id_categoria", how="inner")
df_join_a.explain(mode="formatted")
# Plano: SortMergeJoin ou ShuffledHashJoin → 2 Exchange (shuffle nos dois lados)

# Cenário B — broadcast join explícito
from pyspark.sql.functions import broadcast
df_join_b = df_grande.join(broadcast(df_categorias), on="id_categoria")
df_join_b.explain(mode="formatted")
# Plano: BroadcastHashJoin → 0 Exchange (df_categorias copiado para cada executor)

# shuffle.partitions: 200 vs 4
spark.conf.set("spark.sql.shuffle.partitions", "200")  # 200 tasks, 190 vazias
spark.conf.set("spark.sql.shuffle.partitions", "4")    # 4 tasks, todas úteis
```

**Análise dos planos:**
- **Cenário A**: `SortMergeJoin` — ambos os DataFrames fazem `Exchange` antes do join. Custo: serialização + rede + deserialização + sort nos dois lados.
- **Cenário B**: `BroadcastHashJoin` — `df_categorias` é enviado uma vez para cada executor. O join é resolvido via hash lookup em memória sem nenhum shuffle.
- **Por que broadcast é mais rápido**: evita shuffle nos dois lados. Para tabelas de dimensão pequenas (< 10MB), o custo de broadcast é marginal.
- **Risco de broadcast em tabela grande**: driver coleta o DataFrame inteiro, serializa e envia para cada executor — pode saturar rede e causar OOM. Usar apenas quando tabela cabe confortavelmente na memória de um executor.
- **shuffle.partitions=200 para dados pequenos**: 10 categorias únicas → 190 das 200 partições ficam vazias. O scheduler ainda agenda 200 tasks — overhead puro. AQE (`spark.sql.adaptive.enabled=true`) resolve automaticamente.

---

### Q5 — Leitura e escrita de Parquet particionado

**Conceitos praticados:** `write.partitionBy()`, Partition Pruning, `PartitionFilters` no explain, small files problem, schema ao ler partição diretamente.

```python
# Escrita particionada
df_transacoes.write \
    .mode("overwrite") \
    .partitionBy("ano", "mes") \
    .parquet("output/transacoes")
# Estrutura gerada: output/transacoes/ano=2022/mes=1/part-00000-....parquet
#                                     ano=2022/mes=2/...
#                                     ano=2023/mes=1/...

# Leitura com Partition Pruning
df_leitura = spark.read.parquet("output/transacoes")
df_filtrado = df_leitura.filter(F.col("ano") == 2023)
df_filtrado.explain(mode="formatted")
# PartitionFilters: [isnotnull(ano), (ano = 2023)]
# → Spark lê APENAS os diretórios ano=2023/ — 2022 e 2024 nunca são abertos

# Comparação: filtro em coluna NÃO-particionada (sem Partition Pruning)
df_sem_pruning = df_leitura.filter(F.col("categoria") == "Livros")
df_sem_pruning.explain(mode="formatted")
# Nenhum PartitionFilters → Spark lê TODOS os diretórios e filtra dentro dos arquivos

# Leitura direta de uma partição
df_jun_2023 = spark.read.parquet("output/transacoes/ano=2023/mes=6/")
df_jun_2023.printSchema()
# ATENÇÃO: colunas `ano` e `mes` NÃO aparecem no schema ao ler partição diretamente
# Elas só são inferidas do path quando lendo o diretório raiz
```

**Lições:**
- **Partition Pruning** = seletividade no nível de I/O. O Spark usa os nomes dos diretórios (`ano=2023`) para eliminar partições antes de qualquer leitura.
- **`PartitionFilters`** no explain = o filtro eliminou diretórios inteiros. **`PushedFilters`** = filtro dentro do arquivo Parquet (Predicate Pushdown — filtra row groups sem desserializar tudo).
- **`(ano, mes, categoria)` vs `(ano, mes)`** para leitura de "todos os dados de 2023": `(ano, mes)` é melhor. Com `categoria` como terceiro nível, um filtro só em `ano=2023` ainda percorreria N×12 diretórios (N = cardinalidade de categoria). Além disso, mais níveis = mais arquivos pequenos (small files problem).
- **Regra de particionamento**: particione pelas colunas que aparecem nos filtros mais frequentes, do mais geral ao mais específico. Evite colunas de alta cardinalidade.
- **Schema ao ler partição diretamente**: colunas de partição (`ano`, `mes`) não aparecem no schema — o Spark as infere do path apenas ao ler o diretório raiz.

---
