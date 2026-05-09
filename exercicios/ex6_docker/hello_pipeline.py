import polars as pl
import os

# Dados fictícios de vendas
vendas = pl.DataFrame({
    "produto": ["Notebook", "Mouse", "Teclado", "Monitor", "Headset"],
    "categoria": ["Eletrônicos", "Periféricos", "Periféricos", "Eletrônicos", "Periféricos"],
    "valor": [3500.00, 120.00, 280.00, 1800.00, 350.00],
    "quantidade": [2, 10, 5, 3, 7],
})

# Total de vendas por produto
resultado = (
    vendas
    .with_columns(
        (pl.col("valor") * pl.col("quantidade")).alias("total")
    )
    .group_by("categoria")
    .agg(pl.col("total").sum().alias("faturamento_total"))
    .sort("faturamento_total", descending=True)
)

print("=" * 45)
print("  Faturamento por categoria")
print("=" * 45)
print(resultado)
print()
print("✅ Pipeline executado com sucesso dentro do container Docker!")
print(f"   Python rodando em: {os.uname().sysname if hasattr(os, 'uname') else 'Windows container'}")
