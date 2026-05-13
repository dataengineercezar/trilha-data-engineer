# Semana 10 — Spark Avançado

> Pré-requisito: Semana 9 concluída (DAG, lazy eval, shuffle, Window basics, Parquet particionado)

## Como rodar

```powershell
cd d:\3_Estudos\TRILHA_DE\exercicios\semana10_spark_avancado
docker compose up --build -d
# Acesse: http://localhost:8888
# Abra: ex8_spark_avancado.ipynb
```

---

## Q1 — Window Frames: rowsBetween vs rangeBetween

**Contexto:** Na Semana 9 você usou `Window.partitionBy().orderBy()` com funções como `lag()` e `sum()`. Agora vamos controlar o *frame* da janela — ou seja, quais linhas participam do cálculo para cada linha.

**Dataset:** transações de clientes com `cliente_id`, `data` (inteiro = dias desde época), `valor`.

**Tarefas:**

**a)** Crie o seguinte DataFrame (pode expandir se quiser):
```python
dados = [
    ("C1", 1, 100.0), ("C1", 2, 200.0), ("C1", 3, 150.0), ("C1", 4, 300.0), ("C1", 5, 50.0),
    ("C2", 1, 400.0), ("C2", 2, 100.0), ("C2", 3, 250.0),
]
# schema: cliente_id, dia, valor
```

**b)** Calcule a **média móvel dos últimos 3 registros** por cliente (janela deslizante de posição):
- Use `Window.partitionBy("cliente_id").orderBy("dia")`
- Frame: `rowsBetween(-2, 0)` — inclui a linha atual e as 2 anteriores
- Coluna resultado: `media_movel_3`

**c)** Calcule a **soma dos últimos 5 dias** por cliente (janela baseada em valor):
- Frame: `rangeBetween(-4, 0)` — inclui linhas onde `dia` está entre `(dia_atual - 4)` e `dia_atual`
- Coluna resultado: `soma_5_dias`

**d)** Mostre o resultado com todas as colunas e analise as diferenças.

**Perguntas de reflexão:**
1. Qual a diferença fundamental entre `rowsBetween` e `rangeBetween`?
2. O que acontece com `rangeBetween` se duas linhas têm o mesmo valor no `orderBy`? (ties)
3. O que significa `Window.unboundedPreceding` e quando você usaria?

---

## Q2 — UDFs Python: o custo da serialização

**Contexto:** UDFs (User Defined Functions) permitem usar Python puro dentro do Spark. O problema é que elas quebram o **Catalyst Optimizer** — o Spark não consegue otimizar código Python arbitrário.

**Tarefas:**

**a)** Crie um DataFrame com 500.000 linhas de transações com colunas `id`, `valor` (float aleatório 0–1000):
```python
import random
from pyspark.sql.types import StructType, StructField, IntegerType, DoubleType

dados = [(i, random.uniform(0, 1000)) for i in range(500_000)]
df = spark.createDataFrame(dados, ["id", "valor"])
```

**b)** Implemente uma **UDF Python** que categoriza o valor:
- `valor < 100` → `"baixo"`
- `100 <= valor <= 500` → `"medio"`
- `valor > 500` → `"alto"`

Registre com `@udf(returnType=StringType())` e aplique no DataFrame.

**c)** Use `df_com_udf.explain(True)` — observe como o plano mostra `PythonUDF` no physical plan.

**d)** Reimplemente **sem UDF** usando `F.when().otherwise()` nativo do Spark.

**e)** Use `explain(True)` na versão nativa — compare com o plano da UDF.

**Perguntas de reflexão:**
1. Por que UDFs Python "quebram" o Catalyst Optimizer?
2. O que é serialização/deserialização de dados entre JVM e Python? Por que tem custo?
3. Em que situação uma UDF Python ainda é justificável?

---

## Q3 — Pandas UDF (Arrow-based / Vectorized)

**Contexto:** Pandas UDFs (também chamadas de Vectorized UDFs) usam **Apache Arrow** para transferir dados entre a JVM e o Python em lotes (*batches*), em vez de linha-a-linha. São muito mais rápidas que UDFs Python normais.

**Tarefas:**

**a)** Reimplemente a função de categorização do Q2 como `@pandas_udf`:
```python
from pyspark.sql.functions import pandas_udf
import pandas as pd

@pandas_udf(StringType())
def categorizar_pandas(serie: pd.Series) -> pd.Series:
    # implemente aqui usando operações vetorizadas do pandas
    ...
```

**b)** Aplique no mesmo DataFrame do Q2 e verifique que o resultado é idêntico.

**c)** Use `explain(True)` — observe `ArrowEvalPython` no physical plan (vs `PythonUDF` do Q2).

**d)** Opcional: meça o tempo de execução dos três métodos (UDF Python, Pandas UDF, `F.when`) usando `%%time` ou `time.time()`.

**Perguntas de reflexão:**
1. O que é o Apache Arrow e por que elimina a serialização linha-a-linha?
2. Qual a diferença entre `BatchEvalPython` (UDF normal) e `ArrowEvalPython` (Pandas UDF) no plano físico?
3. Quando você ainda preferiria `F.when()` sobre Pandas UDF?

---

## Q4 — Cache e Persist: StorageLevel

**Contexto:** Quando você reutiliza um DataFrame várias vezes, o Spark recomputa todo o plano a partir do início a cada ação. `cache()` e `persist()` armazenam o resultado materializado em memória/disco para evitar recomputação.

**Tarefas:**

**a)** Crie um DataFrame com transformação "cara" — groupby + window function:
```python
from pyspark.sql import Window
import pyspark.sql.functions as F

df_base = spark.range(0, 200_000).withColumn(
    "categoria", (F.col("id") % 5).cast("string")
).withColumn(
    "valor", (F.rand() * 1000).cast("double")
)

w = Window.partitionBy("categoria").orderBy("id")
df_caro = df_base.withColumn("rank", F.rank().over(w)) \
                 .withColumn("soma_acum", F.sum("valor").over(w))
```

**b)** Execute `df_caro.count()` duas vezes **sem cache**. Use `explain()` para confirmar que o plano de execução completo está presente nas duas chamadas.

**c)** Aplique `df_caro.cache()`. Qual é o `StorageLevel` padrão? (use `df_caro.storageLevel`)

**d)** Execute `df_caro.count()` novamente — agora o Spark lê do cache. Confirme com `explain()` que o plan agora mostra `InMemoryRelation`.

**e)** Agora use `df_caro.unpersist()` para liberar o cache. Depois aplique:
```python
from pyspark import StorageLevel
df_caro.persist(StorageLevel.MEMORY_AND_DISK)
```

**Perguntas de reflexão:**
1. Qual a diferença entre `MEMORY_ONLY`, `MEMORY_AND_DISK`, e `DISK_ONLY`?
2. O que acontece quando o cache não cabe inteiro na memória com `MEMORY_ONLY`?
3. Em quais cenários de pipeline você aplicaria cache/persist?

---

## Q5 — AQE: Adaptive Query Execution

**Contexto:** O AQE (introduzido no Spark 3.0) permite que o Spark **adapte o plano de execução em tempo real**, usando estatísticas coletadas durante o processamento. As três principais otimizações são:
1. **Post-shuffle coalesce** — reduz partições pequenas automaticamente
2. **Skew join** — divide partições muito grandes para balancear o trabalho
3. **Broadcast join dinâmico** — promove um join para broadcast se o lado "grande" se revelar pequeno após filtros

**Tarefas:**

**a)** Crie um dataset com **skew severo** — uma chave tem 90% dos dados:
```python
import random

# 100k linhas — "A" aparece em 90%, "B","C","D","E" dividem 10%
chaves = ["A"] * 90_000 + [random.choice(["B","C","D","E"]) for _ in range(10_000)]
random.shuffle(chaves)

df_skew = spark.createDataFrame(
    [(i, chaves[i], random.uniform(0, 1000)) for i in range(100_000)],
    ["id", "chave", "valor"]
)

df_lookup = spark.createDataFrame(
    [("A", "Alto Volume"), ("B", "Baixo"), ("C", "Baixo"), ("D", "Baixo"), ("E", "Baixo")],
    ["chave", "descricao"]
)
```

**b)** **Desative o AQE** e execute o join:
```python
spark.conf.set("spark.sql.adaptive.enabled", "false")
df_join = df_skew.join(df_lookup, "chave")
df_join.explain(True)
df_join.count()
```
Observe o plano — provavelmente `SortMergeJoin`.

**c)** **Reative o AQE** e execute o mesmo join:
```python
spark.conf.set("spark.sql.adaptive.enabled", "true")
spark.conf.set("spark.sql.adaptive.skewJoin.enabled", "true")
df_join2 = df_skew.join(df_lookup, "chave")
df_join2.explain(True)
df_join2.count()
```
Observe o plano — procure por `SkewedMergeJoinExec` ou `BroadcastHashJoin`.

**d)** Teste o **coalesce automático de partições**:
```python
spark.conf.set("spark.sql.adaptive.coalescePartitions.enabled", "true")
spark.conf.set("spark.sql.shuffle.partitions", "200")  # força 200 partições de shuffle

df_agg = df_skew.groupBy("chave").agg(F.sum("valor").alias("total"))
df_agg.explain(True)
print(f"Partições: {df_agg.rdd.getNumPartitions()}")
```
Observe quantas partições resultam após o AQE coalescer.

**Perguntas de reflexão:**
1. Quais são as 3 otimizações principais do AQE?
2. O que é "data skew" e por que é um problema grave em joins distribuídos?
3. Por que o AQE só consegue otimizar **após** o primeiro stage? O que o distingue do Catalyst Optimizer (que otimiza antes)?
