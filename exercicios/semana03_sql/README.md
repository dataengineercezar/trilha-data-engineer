# Semana 3 — SQL + DuckDB

**Objetivo:** SQL de produção — JOINs, CTEs, Window Functions, query optimization. DuckDB como motor analítico local sobre arquivos.

## Arquivos

| Arquivo | Conteúdo |
|---------|----------|
| `setup_dataset.sql` | Script de criação e carga do dataset de prática no PostgreSQL |
| `ex5_duckdb.md` | Visão geral do DuckDB, queries sobre Parquet/CSV, comparativo com PostgreSQL |

## Setup do PostgreSQL

```powershell
docker start postgres-estudo
# localhost:5432 | database: trilha | user: postgres | password: estudo123
```

```sql
-- Carregar o dataset
\i setup_dataset.sql
```

## Conceitos cobertos

- INNER / LEFT / RIGHT / FULL JOIN — quando usar cada um
- CTEs (`WITH`) — legibilidade e reutilização
- Window Functions: `ROW_NUMBER`, `RANK`, `LAG`, `LEAD`, `SUM OVER`
- Subqueries correlacionadas vs não-correlacionadas
- Query execution plan (`EXPLAIN ANALYZE`)
- DuckDB: SQL sobre arquivos sem servidor

## Referência

Ver seções **SQL** e seção DuckDB em [../../documentos/exercicios_resolvidos.md](../../documentos/exercicios_resolvidos.md)
