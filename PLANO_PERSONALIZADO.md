# PLANO PERSONALIZADO — Data Engineer → Senior / ML Engineer
> Gerado em: Mai/2026 | 12h/semana | Meta: Nível Sênior + ML Engineer
> **Atualizado:** Semana 9 concluída (Spark/PySpark fundamentos)

---

## PROGRESSO ATUAL

| Fase | Semanas | Status |
|------|---------|--------|
| Fundamentos Python | 1–2 | ✅ Concluído |
| SQL + DuckDB | 3 | ✅ Concluído |
| Pandas | 4 | ✅ Concluído |
| Polars + LazyFrame | 5 | ✅ Concluído |
| Git Profissional | 6–7 | ✅ Concluído |
| Docker para DE | 8 | ✅ Concluído |
| Spark / PySpark | 9 | ✅ Concluído |
| **Spark Avançado** | **10** | **🔄 Próxima** |
| dbt Core | 11 | ⬜ |
| Airflow | 12 | ⬜ |
| AWS | 13 | ⬜ |

---

---

## DIAGNÓSTICO ATUAL

> Atualizado: Mai/2026 — após conclusão da Semana 9

| Habilidade | Nível Inicial | Nível Atual | Meta |
|---|---|---|---|
| Python | Básico | Intermediário ✅ | Avançado |
| SQL | Básico | Intermediário ✅ | Avançado |
| Docker | Superficial | Proficiente ✅ | Proficiente |
| Git/GitHub | Superficial | Proficiente ✅ | Proficiente |
| Spark/PySpark | Superficial | Intermediário ✅ | Avançado |
| DuckDB / Polars | Superficial | Intermediário ✅ | Intermediário |
| Airflow | Superficial | Superficial | Proficiente |
| dbt | Superficial | Superficial | Proficiente |
| Kafka | Superficial | Superficial | Intermediário |
| Cloud | Superficial | Superficial | AWS Proficiente |
| Databricks | Superficial | Superficial | Certificado |

**Diagnóstico atual:** Fase 1 concluída — fundamentos sólidos. Entrando na Fase 2 com Spark Avançado. Gap crítico atual: ainda sem experiência real em orquestração (Airflow) e transformação declarativa (dbt).

---

## DISTRIBUIÇÃO SEMANAL (12h)

```
Seg  → 2h (Teoria + leitura)
Ter  → 2h (Prática / código)
Qui  → 2h (Prática / código)
Sex  → 1h (Revisão + anotações)
Sáb  → 3h (Projeto prático)
Dom  → 2h (Exercícios / desafios)
────────────────────────────────
Total → 12h
```

---

## FASE 1 — FUNDAMENTOS SÓLIDOS (Semanas 1–8)
> ⚠️ Essa fase é o que separa o "já vi isso" do "entendo de verdade"

---

### SEMANAS 1–2 — Python de Verdade

**Por que voltar ao Python se já conheço?**
Porque Spark, Airflow, dbt, e MLflow são escritos e configurados em Python. Qualquer limitação aqui se multiplica em todas as ferramentas.

**Conteúdo:**
```
Semana 1 (12h):
  Seg 2h → Tipos de dados, strings, listas, dicionários (do jeito certo)
  Ter 2h → Funções, *args, **kwargs, escopo
  Qui 2h → List/dict comprehensions, generators, iteradores
  Sex 1h → Revisão: reescreva scripts anteriores usando comprehensions
  Sáb 3h → PROJETO: ETL em Python puro (lê CSV → limpa → salva)
  Dom 2h → Exercícios no HackerRank (Python Easy/Medium)

Semana 2 (12h):
  Seg 2h → OOP: classes, herança, @property, __dunder__ methods
  Ter 2h → Context managers (with), decoradores, functools
  Qui 2h → Tratamento de erros (try/except), logging, pathlib
  Sex 1h → Type hints e mypy básico
  Sáb 3h → PROJETO: ETL refatorado com classes + logging
  Dom 2h → HackerRank Python + revisão
```

**Recurso:** [Real Python](https://realpython.com) — artigos gratuitos, altíssima qualidade.

---

### SEMANAS 3–4 — SQL Profissional

**Conteúdo:**
```
Semana 3 (12h):
  Seg 2h → JOINs (todos os tipos) + NULLs e comportamento
  Ter 2h → Subqueries correlacionadas, EXISTS, NOT EXISTS
  Qui 2h → GROUP BY avançado, HAVING, ROLLUP, CUBE
  Sex 1h → Explain plan básico no PostgreSQL
  Sáb 3h → PROJETO: Análise de dataset real (Kaggle) só com SQL
  Dom 2h → LeetCode SQL (problems 1–10)

Semana 4 (12h):
  Seg 2h → Window Functions: ROW_NUMBER, RANK, LAG, LEAD, NTILE
  Ter 2h → CTEs (WITH), CTEs recursivas
  Qui 2h → Índices, particionamento, VACUUM no PostgreSQL
  Sex 1h → Revisão geral SQL
  Sáb 3h → PROJETO: Dashboard SQL — perguntas de negócio em puro SQL
  Dom 2h → LeetCode SQL (problems 10–20) + StrataScratch
```

**Ferramentas:** PostgreSQL (local via Docker) + DBeaver

```bash
# Subir PostgreSQL local instantaneamente
docker run -d \
  --name postgres-estudo \
  -e POSTGRES_PASSWORD=senha123 \
  -p 5432:5432 \
  postgres:16
```

---

### SEMANAS 5–6 — Python para Dados (Pandas + Polars)

```
Semana 5 — Pandas profundo:
  - Index, MultiIndex, .loc vs .iloc
  - apply, map, groupby avançado
  - merge, join, concat com todos os parâmetros
  - dtypes e conversões, memory optimization
  - Leitura de CSV, JSON, Parquet, Excel

Semana 6 — Polars (o futuro):
  - Por que Polars > Pandas para big data
  - LazyFrame vs DataFrame (analogia com Spark)
  - Expressões, contextos, .with_columns()
  - Leitura de Parquet + integração com DuckDB
```

**DuckDB** — aprenda junto com Polars. É o "SQLite dos dados" e está explodindo no mercado.
```python
import duckdb
# SQL direto em Parquet, CSV, DataFrames — sem servidor
duckdb.sql("SELECT * FROM 'dados.parquet' WHERE valor > 1000").show()
```

---

### SEMANAS 7–8 — Git Profissional + Docker Real

```
Semana 7 — Git além do básico:
  - Branching strategies (Git Flow, Trunk-based)
  - Rebase vs Merge (quando usar cada um)
  - git stash, cherry-pick, bisect
  - Pull Requests com code review
  - GitHub Actions básico (CI para rodar testes)
  - Conventional Commits + Semantic Versioning

Semana 8 — Docker para Data Engineering:
  - Dockerfile otimizado para Python (multi-stage)
  - docker-compose com múltiplos serviços
  - Volumes, networks, environment variables
  - PROJETO: ambiente completo com Postgres + Adminer + app Python
  - Docker Hub: publicar imagem do projeto
```

---

## FASE 2 — ENGENHARIA DE DADOS REAL (Semanas 9–24)

### SEMANAS 9–12 — Apache Spark / PySpark (Aprofundamento)

> Você já viu Spark — agora vamos entender de verdade o que acontece por baixo.

```
Semana 9 — Como o Spark funciona internamente:
  - Driver vs Executors vs Cluster Manager
  - RDD vs DataFrame vs Dataset
  - DAG de execução, stages, tasks
  - Transformações LAZY vs Actions
  - Por que shuffle é o inimigo

Semana 10 — DataFrame API completa:
  - Todas as funções do pyspark.sql.functions
  - Window Functions no Spark
  - UDFs e quando NÃO usá-las (perf)
  - Broadcast join vs Sort-merge join
  - Caching e persistência

Semana 11 — Spark otimizado:
  - Particionamento: repartition vs coalesce
  - Salvar em Parquet com partições
  - Spark UI: interpretar plano de execução
  - AQE (Adaptive Query Execution)
  - Configurações críticas de performance

Semana 12 — Spark Structured Streaming:
  - Micro-batch vs Continuous processing
  - Fontes: Kafka, arquivos
  - Sinks: Delta Lake, console, Kafka
  - Watermarks e janelas de tempo
  - Checkpointing e tolerância a falhas
```

---

### SEMANAS 13–16 — dbt + Modelagem Dimensional

```
Semana 13 — dbt Core do zero:
  - Instalar e configurar com PostgreSQL
  - Models: SELECT → tabela versionada
  - Materializations: view, table, incremental, ephemeral
  - Sources e seeds

Semana 14 — dbt intermediário:
  - Tests: not_null, unique, relationships, accepted_values
  - dbt docs generate (documentação automática)
  - Macros com Jinja2
  - Hooks e operations

Semana 15 — Modelagem Dimensional (Kimball):
  - Fatos vs Dimensões
  - Star Schema vs Snowflake Schema
  - Slowly Changing Dimensions (SCD tipo 1, 2, 3)
  - Grain de uma fact table

Semana 16 — PROJETO: Data Warehouse com dbt:
  - Fonte: dataset público (ENEM, Flights, NYC Taxi)
  - Camadas: staging → intermediate → marts
  - Testes em todas as camadas
  - Documentação completa
  - Publicar no GitHub
```

---

### SEMANAS 17–20 — Airflow + Orquestração

```
Semana 17 — Airflow fundamentos:
  - Arquitetura: Scheduler, Webserver, Workers, MetaDB
  - DAGs, Operators, Sensors, Hooks
  - Subir Airflow local com Docker Compose

Semana 18 — Airflow moderno (TaskFlow API):
  - @dag, @task decorators
  - XCom e passagem de dados entre tasks
  - Connections e Variables
  - Retries, SLAs, alertas por email

Semana 19 — Airflow avançado:
  - Dynamic task mapping (paralelismo dinâmico)
  - Pools e prioridades
  - DAG dependencies (TriggerDagRunOperator)
  - Testing de DAGs com pytest

Semana 20 — PROJETO: Pipeline completo orquestrado:
  - Ingestão → transformação (dbt) → carga → alerta
  - Tudo versionado no GitHub
  - README profissional com arquitetura
```

---

### SEMANAS 21–24 — Kafka + Streaming + Delta Lake

```
Semana 21 — Kafka fundamentos reais:
  - Topics, partitions, replication factor
  - Producers e Consumers em Python (confluent-kafka)
  - Consumer Groups e rebalanceamento
  - Offset management (auto-commit vs manual)

Semana 22 — Kafka avançado:
  - Kafka Connect (source + sink connectors)
  - Schema Registry + Avro (evitar breaking changes)
  - ksqlDB básico
  - Monitorar com Kafka UI (Docker)

Semana 23 — Delta Lake profundo:
  - ACID em Data Lakes (por que importa)
  - Time travel (versioning de dados)
  - Schema evolution e enforcement
  - OPTIMIZE, VACUUM, Z-ORDER
  - Delta Live Tables (DLT) no Databricks

Semana 24 — PROJETO INTEGRADOR DE FASE:
  Pipeline end-to-end completo:
  Kafka → PySpark Streaming → Delta Lake → dbt → Airflow → Dashboard
  Publicar no GitHub com diagrama de arquitetura
```

---

## FASE 3 — CLOUD + DATABRICKS (Semanas 25–36)

```
Semanas 25–28 → AWS (Free Tier):
  S3, Glue, Athena, Lambda, IAM, CloudWatch
  Infraestrutura com Terraform
  Meta: pipeline na AWS sem custo

Semanas 29–32 → Databricks Certificação:
  Clusters, Repos, Workflows, Unity Catalog
  Delta Live Tables
  Meta: aprovação no Databricks Associate

Semanas 33–36 → MLflow + Qualidade de Dados:
  MLflow para tracking de experimentos
  Great Expectations / dbt Tests
  DataHub ou OpenMetadata
  Meta: pipeline com qualidade de dados automatizada
```

---

## FASE 4 — ML ENGINEERING (Semanas 37–48)
> A partir daqui você cruza para o caminho de ML Engineer

```
Semanas 37–40 → ML clássico com Scikit-learn
Semanas 41–44 → MLOps com MLflow + DVC + BentoML
Semanas 45–48 → Deep Learning (PyTorch) + HuggingFace
```

---

## CHECKPOINTS DE AVALIAÇÃO

A cada 4 semanas, farei uma avaliação técnica:
- **Semana 4** → ✅ SQL (Window Functions + CTEs) — concluído
- **Semana 8** → ✅ ETL containerizado + publicado no Docker Hub — concluído
- **Semana 12** → ⬜ Desafio PySpark com dataset real
- **Semana 16** → ⬜ Revisão do projeto dbt no GitHub
- **Semana 20** → ⬜ Avaliação do pipeline Airflow
- **Semana 24** → ⬜ Revisão do projeto integrador

---

## PORTFÓLIO — ENTREGAS POR FASE

```
Fase 1 (mês 2):  ✅ github.com/dataengineercezar053/trilha-data-engineer
                     + hub.docker.com/r/dataengineercezar053/trilha-de-pipeline
Fase 2 (mês 6):  repo "dw-dbt-airflow" + repo "streaming-kafka-delta"
Fase 3 (mês 9):  repo "aws-data-pipeline" + certificação Databricks
Fase 4 (mês 12): repo "mlops-pipeline"
```

---

## PRÓXIMO PASSO IMEDIATO

**Semana 10 — Spark Avançado** (ambiente já configurado)

Temas:
- Window Functions com `rowsBetween` / `rangeBetween`
- UDFs — quando usar e por que evitar (overhead de serialização Python ↔ JVM)
- `cache()` vs `persist(StorageLevel.MEMORY_AND_DISK)`
- AQE — Adaptive Query Execution (skew join, coalesce automático)

```powershell
# Ativar ambiente
cd d:\3_Estudos\TRILHA_DE
.\.venv\Scripts\Activate.ps1

# PostgreSQL (se necessário)
docker start postgres-estudo
```

Notebook: `exercicios/semana09_spark/` → criar `semana10_spark_avancado/`

---
