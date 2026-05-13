-- ============================================================
-- DATASET: E-commerce simplificado
-- Tabelas: clientes, produtos, pedidos, itens_pedido, vendedores
-- ============================================================

-- Limpa se já existir
DROP TABLE IF EXISTS itens_pedido CASCADE;
DROP TABLE IF EXISTS pedidos     CASCADE;
DROP TABLE IF EXISTS produtos    CASCADE;
DROP TABLE IF EXISTS clientes    CASCADE;
DROP TABLE IF EXISTS vendedores  CASCADE;

-- ── Vendedores ────────────────────────────────────────────────
CREATE TABLE vendedores (
    id_vendedor   SERIAL PRIMARY KEY,
    nome          VARCHAR(100) NOT NULL,
    regiao        VARCHAR(50)  NOT NULL,
    meta_mensal   NUMERIC(10,2) NOT NULL
);

INSERT INTO vendedores (nome, regiao, meta_mensal) VALUES
    ('Ana Lima',       'Sul',       15000.00),
    ('Bruno Melo',     'Sudeste',   20000.00),
    ('Carla Souza',    'Nordeste',  12000.00),
    ('Diego Ferreira', 'Sudeste',   20000.00),
    ('Elena Martins',  'Norte',      8000.00);

-- ── Clientes ──────────────────────────────────────────────────
CREATE TABLE clientes (
    id_cliente   SERIAL PRIMARY KEY,
    nome         VARCHAR(100) NOT NULL,
    cidade       VARCHAR(100) NOT NULL,
    estado       CHAR(2)      NOT NULL,
    criado_em    DATE         NOT NULL
);

INSERT INTO clientes (nome, cidade, estado, criado_em) VALUES
    ('João Silva',      'São Paulo',      'SP', '2023-01-15'),
    ('Maria Oliveira',  'Rio de Janeiro', 'RJ', '2023-03-22'),
    ('Pedro Costa',     'Belo Horizonte', 'MG', '2023-05-10'),
    ('Lucia Alves',     'Curitiba',       'PR', '2023-06-01'),
    ('Roberto Nunes',   'Salvador',       'BA', '2023-07-19'),
    ('Fernanda Lima',   'Recife',         'PE', '2023-08-05'),
    ('Carlos Rocha',    'Fortaleza',      'CE', '2023-09-12'),
    ('Beatriz Santos',  'Porto Alegre',   'RS', '2023-10-30'),
    ('Marcelo Dias',    'Manaus',         'AM', '2024-01-07'),
    ('Patrícia Gomes',  'Brasília',       'DF', '2024-02-14'),
    ('Thiago Mendes',   'Goiânia',        'GO', '2024-03-03'),
    ('Renata Cardoso',  'Florianópolis',  'SC', '2024-04-18');

-- ── Produtos ──────────────────────────────────────────────────
CREATE TABLE produtos (
    id_produto   SERIAL PRIMARY KEY,
    nome         VARCHAR(150) NOT NULL,
    categoria    VARCHAR(50)  NOT NULL,
    preco        NUMERIC(10,2) NOT NULL,
    estoque      INT          NOT NULL
);

INSERT INTO produtos (nome, categoria, preco, estoque) VALUES
    ('Notebook Pro 15',       'Eletrônicos',   4500.00, 30),
    ('Mouse Sem Fio',         'Periféricos',     89.90, 200),
    ('Teclado Mecânico',      'Periféricos',    299.00, 80),
    ('Monitor 27" 4K',        'Eletrônicos',   1800.00, 45),
    ('Headset Gamer',         'Periféricos',    450.00, 60),
    ('SSD 1TB NVMe',          'Componentes',    380.00, 120),
    ('Cadeira Ergonômica',    'Móveis',        1200.00, 25),
    ('Webcam HD',             'Periféricos',    250.00, 90),
    ('Hub USB-C 7 portas',    'Acessórios',    180.00, 150),
    ('Suporte para Monitor',  'Acessórios',    120.00, 70),
    ('Desk Pad XL',           'Acessórios',     85.00, 180),
    ('Caixinha Bluetooth',    'Áudio',         320.00, 55);

-- ── Pedidos ───────────────────────────────────────────────────
CREATE TABLE pedidos (
    id_pedido    SERIAL PRIMARY KEY,
    id_cliente   INT          NOT NULL REFERENCES clientes(id_cliente),
    id_vendedor  INT          REFERENCES vendedores(id_vendedor),  -- pode ser NULL (venda direta)
    data_pedido  DATE         NOT NULL,
    status       VARCHAR(20)  NOT NULL CHECK (status IN ('aprovado','cancelado','pendente','entregue')),
    desconto     NUMERIC(5,2) NOT NULL DEFAULT 0.00  -- percentual
);

INSERT INTO pedidos (id_cliente, id_vendedor, data_pedido, status, desconto) VALUES
    (1,  2, '2024-01-10', 'entregue',  0.00),
    (1,  2, '2024-03-05', 'entregue',  5.00),
    (2,  1, '2024-01-22', 'entregue',  0.00),
    (3,  4, '2024-02-14', 'entregue', 10.00),
    (4,  1, '2024-02-28', 'cancelado', 0.00),
    (5,  3, '2024-03-11', 'entregue',  0.00),
    (6,  3, '2024-03-19', 'entregue',  5.00),
    (7,  5, '2024-04-02', 'pendente',  0.00),
    (8,  2, '2024-04-15', 'entregue',  0.00),
    (9,  4, '2024-04-22', 'entregue', 15.00),
    (10, 2, '2024-05-03', 'entregue',  0.00),
    (11, NULL,'2024-05-10','entregue', 0.00),
    (12, 1, '2024-05-18', 'entregue',  5.00),
    (2,  2, '2024-06-01', 'entregue',  0.00),
    (3,  4, '2024-06-15', 'cancelado', 0.00),
    (1,  2, '2024-07-04', 'entregue',  0.00),
    (5,  3, '2024-07-20', 'entregue', 10.00),
    (8,  2, '2024-08-08', 'entregue',  0.00),
    (10, 2, '2024-08-25', 'pendente',  0.00),
    (4,  1, '2024-09-01', 'entregue',  5.00);

-- ── Itens do Pedido ───────────────────────────────────────────
CREATE TABLE itens_pedido (
    id_item      SERIAL PRIMARY KEY,
    id_pedido    INT           NOT NULL REFERENCES pedidos(id_pedido),
    id_produto   INT           NOT NULL REFERENCES produtos(id_produto),
    quantidade   INT           NOT NULL CHECK (quantidade > 0),
    preco_unit   NUMERIC(10,2) NOT NULL  -- preço no momento da compra (pode diferir do atual)
);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unit) VALUES
    -- Pedido 1
    (1, 1, 1, 4500.00), (1, 2, 2, 89.90),
    -- Pedido 2
    (2, 3, 1, 299.00),  (2, 9, 1, 180.00),
    -- Pedido 3
    (3, 4, 1, 1800.00),
    -- Pedido 4
    (4, 1, 1, 4500.00), (4, 6, 2, 380.00),
    -- Pedido 5 (cancelado)
    (5, 7, 1, 1200.00),
    -- Pedido 6
    (6, 5, 1, 450.00),  (6, 8, 1, 250.00),
    -- Pedido 7
    (7, 3, 1, 299.00),  (7, 11, 2, 85.00),
    -- Pedido 8
    (8, 2, 1, 89.90),
    -- Pedido 9
    (9, 1, 2, 4500.00), (9, 4, 1, 1800.00),
    -- Pedido 10
    (10, 6, 1, 380.00), (10, 9, 2, 180.00),
    -- Pedido 11
    (11, 10, 2, 120.00),(11, 11, 1, 85.00),
    -- Pedido 12
    (12, 7, 1, 1200.00),(12, 5, 1, 450.00),
    -- Pedido 13
    (13, 2, 3, 89.90),  (13, 3, 1, 299.00),
    -- Pedido 14
    (14, 1, 1, 4500.00),
    -- Pedido 15 (cancelado)
    (15, 4, 1, 1800.00),
    -- Pedido 16
    (16, 6, 2, 380.00), (16, 9, 1, 180.00),
    -- Pedido 17
    (17, 5, 2, 450.00), (17, 8, 1, 250.00),
    -- Pedido 18
    (18, 12, 1, 320.00),(18, 11, 2, 85.00),
    -- Pedido 19
    (19, 1, 1, 4500.00),
    -- Pedido 20
    (20, 7, 1, 1200.00),(20, 2, 2, 89.90);

-- ── View auxiliar (faturamento real por pedido) ───────────────
CREATE VIEW vw_faturamento_pedidos AS
SELECT
    p.id_pedido,
    p.id_cliente,
    p.id_vendedor,
    p.data_pedido,
    p.status,
    p.desconto,
    SUM(i.quantidade * i.preco_unit) AS valor_bruto,
    ROUND(SUM(i.quantidade * i.preco_unit) * (1 - p.desconto / 100), 2) AS valor_liquido
FROM pedidos p
JOIN itens_pedido i ON i.id_pedido = p.id_pedido
GROUP BY p.id_pedido, p.id_cliente, p.id_vendedor, p.data_pedido, p.status, p.desconto;

-- ── Verificação rápida ────────────────────────────────────────
SELECT 'clientes'     AS tabela, COUNT(*) AS registros FROM clientes
UNION ALL
SELECT 'produtos',    COUNT(*) FROM produtos
UNION ALL
SELECT 'vendedores',  COUNT(*) FROM vendedores
UNION ALL
SELECT 'pedidos',     COUNT(*) FROM pedidos
UNION ALL
SELECT 'itens_pedido',COUNT(*) FROM itens_pedido;
