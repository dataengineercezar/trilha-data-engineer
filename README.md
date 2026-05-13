# Trilha Data Engineer → Senior

Repositório de estudos pessoal — referência técnica, exercícios resolvidos e projetos práticos.
Organizado como guia de consulta para revisão rápida e aprofundamento progressivo.

---

## Onde estou agora

| Semana | Tema | Status |
|--------|------|--------|
| 1–2 | Python (comprehensions, generators, funcional, type hints) | ✅ |
| 3 | SQL (JOINs, CTEs, Window Functions, performance) | ✅ |
| 4 | Pandas | ✅ |
| 5 | Polars + LazyFrame | ✅ |
| 6–7 | Git Profissional + DuckDB | ✅ |
| 8 | Docker para Data Engineering | ✅ |
| 9 | Apache Spark / PySpark — fundamentos e DataFrame API | ✅ |
| 10 | Spark Avançado (Window frames, UDFs, AQE, caching) | 🔄 próxima |
| 11 | dbt Core | ⬜ |
| 12 | Airflow | ⬜ |
| 13 | Cloud — AWS (S3, Glue, Athena) | ⬜ |
| 14 | Data Warehousing (modelagem dimensional) | ⬜ |
| 15 | Streaming — Kafka | ⬜ |
| 16 | Lakehouse — Delta Lake / Iceberg | ⬜ |
| 17 | Arquitetura de Dados (Medallion, Data Mesh, system design) | ⬜ |

---

## Estrutura do repositório

```
trilha-data-engineer/
│
├── README.md                          ← você está aqui
│
├── documentos/
│   └── exercicios_resolvidos.md       ← guia técnico principal (referência viva)
│
├── exercicios/
│   ├── semana01-02_python/            ← Python fundamentals
│   ├── semana03_sql/                  ← SQL + setup do dataset PostgreSQL
│   ├── semana04_pandas/
│   ├── semana05_polars/
│   ├── semana08_docker/               ← Dockerfile, docker-compose, ETL pipeline
│   └── semana09_spark/                ← PySpark, DAG, shuffle, Parquet particionado
│
└── PLANO_PERSONALIZADO.md             ← diagnóstico e distribuição semanal
```

---

## O guia técnico principal

Tudo que foi estudado está documentado em detalhe em
[documentos/exercicios_resolvidos.md](documentos/exercicios_resolvidos.md).

Ele contém:
- Conceitos aprofundados com explicação de **como funcionam por dentro**
- Código real com saídas e análise de planos de execução
- Padrões de produção e armadilhas comuns
- Exercícios resolvidos com comentários de review

---

## Setup do ambiente

```powershell
# Ativar o ambiente virtual
.\.venv\Scripts\Activate.ps1

# Dependências principais instaladas
# pyspark 4.1.1 | polars 1.40.1 | pandas 3.x | duckdb 1.5.2
# pyarrow | psycopg2-binary | ipykernel

# PostgreSQL (exercícios de SQL)
docker start postgres-estudo   # localhost:5432 | db: trilha | user: postgres | pw: estudo123

# Kernel Jupyter correto
# Selecionar: "Python (.venv trilha)" no VS Code
```

---

## Roadmap — Senior DE Wheel

Baseado no framework de tiers do mercado (2026):

```
Tier Junior  → Programming ✅ | Cloud ⬜ | Warehousing ⬜
Tier Mid     → Processing ✅  | Orchestration ⬜ | Data Quality ⬜
Tier Senior  → Streaming ⬜   | Lakehouse ⬜    | DevOps ✅ | Architecture ⬜
```

> "Você não precisa de todas as ferramentas — precisa de uma tool profunda por categoria
> + capacidade de trocar quando o job exigir. Isso é o que separa Mid de Senior."
