# Exercício 6 — Docker para Data Engineering
> Semana 8 da Trilha Data Engineer → Senior/ML Engineer

---

## Objetivos

- Construir imagens Docker otimizadas para Python
- Usar multi-stage build para reduzir o tamanho final da imagem
- Criar um pipeline ETL que roda dentro de um container
- Orquestrar múltiplos serviços (Postgres + Adminer + Python) com docker-compose
- Conectar ao banco de dados existente pelo container
- Publicar a imagem no Docker Hub

---

## Pré-requisitos

- Docker Desktop instalado e rodando
- Docker Hub account (gratuita em hub.docker.com)
- Banco de dados `postgres-estudo` existente (container do PostgreSQL das semanas anteriores)

---

## Q1 — Primeiro container Python

Crie um `Dockerfile` em `ex6_docker/` que:
1. Use `python:3.14-slim` como imagem base
2. Instale `polars` e `pyarrow`
3. Copie o arquivo `hello_pipeline.py`
4. Execute o arquivo como comando padrão

Crie também o arquivo `hello_pipeline.py` que:
- Cria um DataFrame Polars com 5 linhas de dados fictícios de vendas (produto, valor, data)
- Imprime o total de vendas por produto
- Imprime uma mensagem confirmando que rodou dentro de um container

**Comandos para testar:**
```powershell
# Na pasta ex6_docker/
docker build -t trilha-hello:1.0 .
docker run --rm trilha-hello:1.0
```

**Esperado:** saída com o aggregation do Polars e a mensagem de confirmação.

---

## Q2 — Otimizando com cache e .dockerignore

Modifique o `Dockerfile` da Q1 para:
1. Separar o `COPY requirements.txt` do `COPY . .` (ordem correta para cache)
2. Adicionar `ENV PYTHONUNBUFFERED=1` e `ENV PYTHONDONTWRITEBYTECODE=1`
3. Rodar o container como usuário não-root (`appuser`)

Crie o arquivo `.dockerignore` para excluir arquivos desnecessários do build context.

Crie o `requirements.txt` com as dependências.

**Validação:**
```powershell
docker build -t trilha-hello:2.0 .
# Faça uma mudança pequena no hello_pipeline.py e rebuild
# Verifique que o "pip install" usa cache (deve aparecer "CACHED")
docker build -t trilha-hello:2.0 .

# Verificar que roda como usuário não-root
docker run --rm trilha-hello:2.0 whoami
# Esperado: appuser  (não root)
```

---

## Q3 — Multi-stage build

Crie um `Dockerfile.multistage` com dois estágios:
- **Estágio `builder`**: instala todas as dependências em um virtualenv (`/opt/venv`)
- **Estágio `runtime`**: imagem limpa que copia apenas o `/opt/venv` do builder

Compare os tamanhos:
```powershell
# Build versão simples
docker build -t trilha-hello:simple .

# Build multi-stage
docker build -f Dockerfile.multistage -t trilha-hello:multistage .

# Comparar tamanhos
docker images trilha-hello
```

**Esperado:** a imagem multistage deve ser igual ou menor que a simples (para deps puras Python a diferença é pequena; o ganho real é com libs compiladas como `grpcio`).

**Desafio:** adicione `pyarrow` nos requirements e compare novamente — o ganho deve ser maior.

---

## Q4 — Pipeline que conecta ao PostgreSQL

Crie o arquivo `etl_pipeline.py` que:
1. Lê as variáveis de ambiente `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`
2. Conecta ao PostgreSQL usando `psycopg2` ou `sqlalchemy`
3. Executa uma query na tabela de pedidos (do dataset criado nas semanas de SQL)
4. Carrega o resultado em um DataFrame Polars
5. Calcula as 5 categorias com maior faturamento
6. Salva o resultado em `/app/output/top_categorias.parquet`

Crie um `Dockerfile.etl` para este pipeline.

**Rodar conectando ao container postgres-estudo existente:**
```powershell
# Subir o postgres existente
docker start postgres-estudo

# Criar a network se não existir
docker network create trilha-network

# Conectar postgres-estudo à network
docker network connect trilha-network postgres-estudo

# Build
docker build -f Dockerfile.etl -t trilha-etl:1.0 .

# Rodar com variáveis de ambiente e output montado
docker run --rm `
    --network trilha-network `
    -e DB_HOST=postgres-estudo `
    -e DB_PORT=5432 `
    -e DB_NAME=trilha `
    -e DB_USER=postgres `
    -e DB_PASSWORD=estudo123 `
    -v ${PWD}/output:/app/output `
    trilha-etl:1.0
```

**Esperado:** arquivo `output/top_categorias.parquet` criado no host.

---

## Q5 — docker-compose completo

Crie o arquivo `docker-compose.yml` em `ex6_docker/` que orquestra:
1. **postgres** — PostgreSQL 16 com volume nomeado e healthcheck
2. **adminer** — Interface web na porta 8080, dependente do postgres
3. **pipeline** — Seu `Dockerfile.etl`, dependente do postgres healthy, com bind mount no `./output`

Crie o `.env` com `DB_PASSWORD=estudo123` (adicionar ao `.gitignore`!).

**Testar:**
```powershell
# Subir tudo
docker compose up -d

# Verificar que todos subiram
docker compose ps

# Verificar logs do pipeline
docker compose logs pipeline

# Acessar Adminer
# Abrir browser: http://localhost:8080
# Sistema: PostgreSQL, Servidor: postgres, Usuário: postgres, Senha: estudo123, BD: trilha

# Derrubar (preservando volume com dados)
docker compose down
```

**Esperado:**
- Adminer acessível em http://localhost:8080
- Pipeline roda o ETL e gera o parquet em `./output/`
- `docker compose down` não apaga os dados do banco

---

## Q6 — Publicar no Docker Hub

1. Crie uma conta em hub.docker.com (se ainda não tiver)
2. Crie um repositório público chamado `trilha-de-pipeline`
3. Faça login via CLI e publique a imagem do ETL pipeline

```powershell
# Login
docker login

# Tag com seu username
docker tag trilha-etl:1.0 SEU_USUARIO/trilha-de-pipeline:1.0
docker tag trilha-etl:1.0 SEU_USUARIO/trilha-de-pipeline:latest

# Push
docker push SEU_USUARIO/trilha-de-pipeline:1.0
docker push SEU_USUARIO/trilha-de-pipeline:latest
```

**Validar:** acesse `hub.docker.com/r/SEU_USUARIO/trilha-de-pipeline` e confirme que a imagem aparece com as tags `1.0` e `latest`.

**Bonus:** adicione um `README.md` ao repositório do Docker Hub descrevendo o que o pipeline faz.

---

## Respostas

*(Preencher abaixo após completar cada questão)*

### Q1
```
[colar código do Dockerfile e hello_pipeline.py]
```

### Q2
```
[colar Dockerfile otimizado + .dockerignore + requirements.txt]
```

### Q3
```
[colar Dockerfile.multistage e saída do docker images comparando tamanhos]
```

### Q4
```
[colar etl_pipeline.py e Dockerfile.etl]
```

### Q5
```
[colar docker-compose.yml]
```

### Q6
```
[colar link do Docker Hub e print do docker push]
```
