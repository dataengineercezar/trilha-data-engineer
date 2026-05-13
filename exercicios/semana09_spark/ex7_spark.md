# Semana 9 — Apache Spark / PySpark

**Objetivo:** Compreender a arquitetura do Spark, o modelo de execução lazy, shuffle e como usar a DataFrame API para construir pipelines de dados eficientes.

**Pré-requisitos:**
- PySpark instalado no `.venv` (`pip show pyspark`)
- Java 8+ disponível (`java -version`)
- Kernel do Jupyter usando o `.venv`

---

## Q1 — SparkSession, leitura e primeiras transformações

**Contexto:** Antes de escrever qualquer pipeline Spark, você precisa entender o ponto de entrada da aplicação e como o Spark representa dados.

**Conceitos envolvidos:** SparkSession, DataFrame com schema explícito, transformações básicas, `show()`, `printSchema()`, `explain()`.

**Tarefa:**

1. Crie uma `SparkSession` com:
   - `appName = "ex7-q1"`
   - `master = "local[*]"`
   - `spark.sql.shuffle.partitions = "4"` (para não criar 200 partições para 100 registros)
   - log level `WARN`

2. Crie um DataFrame **a partir de uma lista Python** com 10 pedidos fictícios. Campos: `id_pedido (int)`, `categoria (str)`, `valor (float)`, `ano (int)`, `mes (int)`.

3. Aplique as seguintes transformações (em cadeia, sem executar ainda):
   - Filtre apenas pedidos com `valor > 200`
   - Adicione coluna `valor_com_iva = valor * 1.23`
   - Selecione apenas `id_pedido`, `categoria`, `valor_com_iva`

4. Chame `explain()` **antes** de chamar `show()`. Leia o output e identifique:
   - O que o plano mostra? Quais operações aparecem?
   - Quantas vezes o dado "bruto" é lido?

5. Chame `show()` para ver o resultado.

**Pergunta para reflexão:** O `explain()` foi chamado antes do `show()` mas não executou os dados. Por quê? O que isso revela sobre como o Spark funciona?

---

## Q2 — Narrow vs Wide: identificando shuffle boundaries

**Contexto:** Performance em Spark depende de minimizar shuffle. Você precisa conseguir olhar para um pipeline e identificar onde estão os shuffle boundaries.

**Conceitos envolvidos:** Narrow vs wide transformations, stages, `explain()`, shuffle.

**Tarefa:**

1. Crie um DataFrame com 50 registros com campos: `id`, `cidade`, `produto`, `quantidade`, `preco_unit`.

2. Construa um pipeline com estas transformações **nesta ordem**:
   ```python
   df
     .filter(quantidade > 0)           # transformação A
     .withColumn("total", quantidade * preco_unit)  # transformação B
     .groupBy("cidade").agg(sum("total"))            # transformação C
     .orderBy(sum("total").desc())                   # transformação D
   ```

3. Chame `explain(mode="formatted")` e identifique:
   - Quantos **stages** este job terá?
   - Onde estão as **shuffle boundaries**? (dica: procure por `Exchange` no plano)
   - Quais transformações são **narrow** e quais são **wide**?

4. **Experimento:** Troque o `orderBy` por `sort` dentro do `groupBy` (use `.agg(...).orderBy(...)`). O plano muda? Quantos shuffles agora?

**Pergunta:** Se você tivesse que remover UM shuffle deste pipeline para ganhar performance, qual removeria e como?

---

## Q3 — DataFrame API: filter, groupBy, join, window functions

**Contexto:** O dia a dia de um Data Engineer com Spark é trabalhar com a DataFrame API para transformar dados. Este exercício cobre as operações mais frequentes em pipelines reais.

**Conceitos envolvidos:** `filter`, `groupBy`, `agg`, `join`, `Window`, `rank`, `lag`.

**Tarefa:**

Você tem dois DataFrames:
- `df_pedidos`: `id_pedido`, `id_cliente`, `categoria`, `valor`, `data_pedido` (string "YYYY-MM-DD")
- `df_clientes`: `id_cliente`, `nome`, `cidade`, `segmento`

Crie-os manualmente com pelo menos 15 pedidos e 5 clientes.

**Subtarefas:**

1. **Join + filtro**: Junte os dois DataFrames e filtre apenas clientes do segmento "Premium". Mostre `nome`, `categoria`, `valor`.

2. **Ranking por cliente**: Para cada cliente, calcule o rank dos pedidos por valor (do maior para o menor). Use Window Function. Mostre os top-2 pedidos por cliente.

3. **Crescimento mês a mês**: Calcule o total de vendas por mês. Depois use `lag()` para calcular a diferença em relação ao mês anterior. Mostre: `mes`, `total`, `total_mes_anterior`, `variacao`.

4. **Top categoria**: Qual categoria teve o maior valor médio de pedido? Use `groupBy + agg + orderBy`.

**Regra:** Não use `.toPandas()` ou loops Python. Tudo deve ser resolvido com a DataFrame API.

---

## Q4 — Performance: broadcast join, shuffle.partitions, AQE e explain()

**Contexto:** Escrever código Spark que funciona é diferente de escrever código que escala. Neste exercício você vai comparar planos de execução e aplicar otimizações.

**Conceitos envolvidos:** `broadcast()`, `spark.sql.shuffle.partitions`, `spark.sql.adaptive.enabled`, `explain()`, custo de shuffle.

**Tarefa:**

1. Crie dois DataFrames:
   - `df_grande`: 1000 registros com `id_produto`, `id_categoria`, `quantidade`, `preco`
   - `df_categorias`: 10 registros com `id_categoria`, `nome_categoria`, `margem_percentual`

2. **Cenário A — join padrão:**
   ```python
   spark.conf.set("spark.sql.autoBroadcastJoinThreshold", "-1")  # desativa broadcast automático
   resultado = df_grande.join(df_categorias, "id_categoria")
   resultado.explain(mode="formatted")
   ```
   - Qual estratégia de join o Spark escolheu? (procure por `SortMergeJoin` ou `ShuffledHashJoin`)
   - Quantos shuffles?

3. **Cenário B — broadcast join explícito:**
   ```python
   from pyspark.sql.functions import broadcast
   resultado = df_grande.join(broadcast(df_categorias), "id_categoria")
   resultado.explain(mode="formatted")
   ```
   - O plano mudou? Por quê isso é mais rápido?
   - Quantos shuffles agora?

4. **Experimento com shuffle.partitions:**
   ```python
   spark.conf.set("spark.sql.shuffle.partitions", "200")  # default
   df_grande.groupBy("id_categoria").agg({"quantidade": "sum"}).count()
   # vs
   spark.conf.set("spark.sql.shuffle.partitions", "4")
   df_grande.groupBy("id_categoria").agg({"quantidade": "sum"}).count()
   ```
   - Use `spark.sparkContext.statusTracker` ou o Spark UI (localhost:4040) para comparar.
   - O que acontece quando `shuffle.partitions` é muito alto para poucos dados?

**Pergunta:** Em produção, quando você usaria broadcast join? Qual é o risco de fazer broadcast de uma tabela grande?

---

## Q5 — Leitura e escrita de Parquet particionado

**Contexto:** Parquet é o formato padrão em Data Lakes. Particionar corretamente os dados de saída é fundamental para que leituras futuras sejam eficientes (partition pruning).

**Conceitos envolvidos:** `write.partitionBy()`, `read.parquet()`, partition pruning, `coalesce()`, compressão.

**Tarefa:**

1. Crie um DataFrame com 200 registros simulando transações com campos: `id_transacao`, `ano`, `mes`, `categoria`, `valor`.
   - Use anos 2022, 2023, 2024 e meses 1-12 distribuídos aleatoriamente.

2. **Escrita particionada:**
   ```python
   df.write \
     .mode("overwrite") \
     .partitionBy("ano", "mes") \
     .parquet("output/transacoes/")
   ```
   - Explore a estrutura de diretórios criada. O que você encontra em `output/transacoes/`?
   - Quantos arquivos Parquet foram criados? Por quê?

3. **Leitura com partition pruning:**
   ```python
   df_filtrado = spark.read.parquet("output/transacoes/") \
     .filter((F.col("ano") == 2023) & (F.col("mes") == 6))
   df_filtrado.explain()
   ```
   - O explain mostra `PartitionFilters`? O que isso significa?

4. **Problema de small files:** Verifique quantos arquivos foram criados por partição. Se forem muitos arquivos pequenos, use `coalesce(1)` antes de escrever e compare.

5. **Leitura de uma única partição diretamente:**
   ```python
   spark.read.parquet("output/transacoes/ano=2023/mes=6/").show()
   ```
   Funciona? Por que Spark consegue ler isso diretamente?

**Pergunta:** Se você particiona por `(ano, mes, categoria)`, a leitura de "todos os dados de 2023" vai ser mais rápida ou mais lenta do que particionar só por `(ano, mes)`? Por quê?

---

## Checklist de conclusão

- [ ] Q1: SparkSession criada, explain() chamado antes do show(), lazy evaluation observada
- [ ] Q2: Shuffle boundaries identificadas com explain(formatted), narrow vs wide documentados
- [ ] Q3: Join, Window Function com rank() e lag(), crescimento mês a mês calculado
- [ ] Q4: Plano com e sem broadcast comparado, entendimento de shuffle.partitions
- [ ] Q5: Parquet particionado escrito e lido, partition pruning observado no explain()
