import os
import polars as pl
import psycopg2

# ── Configuração via variáveis de ambiente ─────────────────────────────────────
# Nunca hardcodar credenciais ou endereços — quem sabe é quem sobe o container
DB_HOST = os.environ.get("DB_HOST", "localhost")
DB_PORT = os.environ.get("DB_PORT", "5432")
DB_NAME = os.environ.get("DB_NAME", "postgres")
DB_USER = os.environ.get("DB_USER", "postgres")
DB_PASS = os.environ.get("DB_PASS", "")


def extract(conn) -> pl.DataFrame:
    """Extrai faturamento por categoria de produtos via JOIN."""
    query = """
        SELECT
            p.categoria,
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
    """Adiciona coluna com percentual sobre o faturamento total."""
    total = df["faturamento_total"].sum()
    return df.with_columns(
        (pl.col("faturamento_total") / total * 100)
        .round(2)
        .alias("percentual")
    )


def load(df: pl.DataFrame, conn) -> None:
    """Salva o resultado em uma tabela de resumo no próprio banco."""
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
    print("=" * 50)
    print("  ETL Pipeline — Faturamento por Categoria")
    print("=" * 50)
    print(f"  Conectando em {DB_HOST}:{DB_PORT}/{DB_NAME}...")

    conn = psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASS,
    )

    try:
        print("\n[1/3] Extraindo dados do PostgreSQL...")
        df_raw = extract(conn)
        print(df_raw)

        print("\n[2/3] Transformando...")
        df_final = transform(df_raw)
        print(df_final)

        print("\n[3/3] Carregando resultado em resumo_faturamento_categoria...")
        load(df_final, conn)
        print("  Tabela criada com sucesso.")

    finally:
        conn.close()

    print("\nPipeline concluído.")


if __name__ == "__main__":
    main()
