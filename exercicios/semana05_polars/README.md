# Semana 5 — Polars

**Objetivo:** Polars como alternativa moderna ao Pandas — API lazy, expressões paralelas, performance em datasets médios (1–100GB em uma máquina).

## Arquivos

| Arquivo | Conteúdo |
|---------|----------|
| `ex4_polars.ipynb` | Exercícios completos com soluções e comparativos com Pandas |

## Conceitos cobertos

- `pl.col()` e o modelo de expressões
- `with_columns()` — transformações sem mutação
- `filter()` com expressões Polars
- `group_by().agg()` — agregações paralelas
- `over()` — window functions
- Lazy API: `scan_csv()`, `scan_parquet()`, `collect()`
- Comparativo de performance vs Pandas

## Referência

Ver seção **POLARS** em [../../documentos/exercicios_resolvidos.md](../../documentos/exercicios_resolvidos.md)
