# 🗺️ GUIA DE ESTUDOS — Data Engineering · Machine Learning · IA
> Trilha baseada nas demandas reais do mercado em 2025/2026  
> Organizada por nível: **Fundamentos → Intermediário → Avançado → Especialização**

---

## 📐 MAPA MENTAL DA PROFISSÃO

```
DATA ENGINEER / ML ENGINEER / AI ENGINEER
│
├── FUNDAMENTOS
│   ├── Programação (Python, SQL)
│   ├── Matemática & Estatística
│   └── Sistemas Operacionais & Redes
│
├── ENGENHARIA DE DADOS
│   ├── Ingestão & Pipelines (Kafka, Spark, Airflow)
│   ├── Armazenamento (Data Lake, DW, Lakehouse)
│   ├── Transformação (dbt, Spark SQL)
│   └── Qualidade & Governança
│
├── MACHINE LEARNING
│   ├── Modelagem Clássica (Scikit-learn)
│   ├── Deep Learning (PyTorch, TensorFlow)
│   └── MLOps (MLflow, DVC, Ray)
│
└── INTELIGÊNCIA ARTIFICIAL MODERNA
    ├── LLMs & Generative AI
    ├── RAG & Vector Databases
    └── AI Agents (LangChain, CrewAI)
```

---

## FASE 1 — FUNDAMENTOS SÓLIDOS
> Prazo sugerido: 2–3 meses

### 1.1 Python para Dados
| Tópico | Ferramentas | Recursos |
|---|---|---|
| Sintaxe, OOP, Funcional | Python 3.12+ | python.org / Real Python |
| Manipulação de Dados | **Pandas**, **Polars** | Docs oficiais |
| Computação Numérica | **NumPy** | numpy.org |
| Visualização | **Matplotlib**, **Seaborn**, **Plotly** | - |
| Ambientes e Pacotes | **uv**, **Poetry**, **venv** | - |

**Foque em:** list comprehensions, generators, context managers, decorators, async/await.

---

### 1.2 SQL — A Linguagem mais Cobrada no Mercado
```
Nível básico   → SELECT, JOIN (INNER/LEFT/RIGHT/FULL), WHERE, GROUP BY
Nível médio    → Window Functions, CTEs (WITH), Subqueries
Nível avançado → Query optimization, Execution plans, Indexes
```
- **Pratique em:** LeetCode SQL, Mode Analytics, HackerRank SQL, StrataScratch
- **Banco para praticar:** PostgreSQL (local) ou BigQuery (free tier)

---

### 1.3 Matemática & Estatística
| Área | Conteúdo Essencial |
|---|---|
| Álgebra Linear | Vetores, Matrizes, Decomposições (SVD, PCA) |
| Cálculo | Gradientes, Derivadas parciais, Regra da cadeia |
| Probabilidade | Distribuições, Bayes, MLE, MAP |
| Estatística | Testes de hipótese, A/B Testing, Intervalos de confiança |

> Recursos: **3Blue1Brown** (YouTube) · **StatQuest** · Khan Academy · Livro "Mathematics for ML" (grátis no GitHub)

---

### 1.4 Git & Boas Práticas
```bash
# Dominar:
git flow, branching strategies, pull requests
pre-commit hooks, .gitignore para projetos de dados
conventional commits
```

---

## FASE 2 — ENGENHARIA DE DADOS
> Prazo sugerido: 3–4 meses

### 2.1 Arquiteturas de Dados Modernas

```
Batch Pipeline:     Source → Ingest → Store → Transform → Serve
Streaming Pipeline: Source → Kafka → Flink/Spark Streaming → Store → Serve
Data Lakehouse:     Landing (Raw) → Bronze → Silver → Gold (Medallion Architecture)
```

---

### 2.2 Armazenamento & Formatos

| Categoria | Tecnologias | O que estudar |
|---|---|---|
| Data Warehouse | **BigQuery**, **Snowflake**, **Redshift** | Modelo dimensional, particionamento, clustering |
| Data Lake | **S3**, **Azure Data Lake**, **GCS** | Organização de pastas, versionamento |
| Data Lakehouse | **Delta Lake**, **Apache Iceberg**, **Apache Hudi** | ACID, time travel, schema evolution |
| Formatos de Arquivo | **Parquet**, **ORC**, **Avro**, **JSON** | Compressão, columnar vs row |

> ⭐ **Delta Lake + Iceberg** são os mais demandados em 2025.

---

### 2.3 Processamento de Dados

#### Apache Spark (Obrigatório)
```python
# Fundamentos que todo DE precisa dominar
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Estude:
# - DataFrames API vs SQL API
# - Transformações lazy vs ações
# - Particionamento e shuffling
# - Broadcast joins e otimizações
# - Structured Streaming
```

#### dbt (data build tool) — O mais pedido em vagas
```yaml
# O que dominar:
# - Models (SQL transforms versionados)
# - Tests (not_null, unique, relationships)
# - Documentation
# - Macros com Jinja2
# - Sources e Seeds
# - Incremental models
# - dbt Cloud vs dbt Core
```

---

### 2.4 Orquestração de Pipelines

| Ferramenta | Posição no Mercado | O que aprender |
|---|---|---|
| **Apache Airflow** | ⭐ Mais usado | DAGs, Operators, XCom, TaskFlow API |
| **Prefect** | Crescendo muito | Flows, Tasks, Deployments |
| **Dagster** | Usado em Big Techs | Assets, Jobs, Sensors, IO Managers |

```python
# Airflow — TaskFlow API (moderno)
from airflow.decorators import dag, task
from datetime import datetime

@dag(schedule="@daily", start_date=datetime(2025, 1, 1))
def meu_pipeline():
    @task
    def extrair():
        return {"dados": [...]}

    @task
    def transformar(dados):
        return dados

    transformar(extrair())
```

---

### 2.5 Streaming & Mensageria

#### Apache Kafka — O padrão da indústria
```
Conceitos obrigatórios:
  - Topics, Partitions, Replication
  - Producers e Consumers
  - Consumer Groups
  - Kafka Connect (conectores prontos)
  - Kafka Streams / ksqlDB
  - Schema Registry + Avro
```

#### Apache Flink (para streaming avançado)
- Processamento stateful
- Event time vs processing time
- Watermarks e janelas

---

### 2.6 Cloud (Escolha 1 para aprofundar)

| Cloud | Serviços Dados Essenciais | Certificação |
|---|---|---|
| **AWS** | S3, Glue, Athena, EMR, Kinesis, Redshift, Lambda | AWS Data Engineer Associate |
| **GCP** | BigQuery, Dataflow, Pub/Sub, Dataproc, Composer | Professional Data Engineer |
| **Azure** | Data Factory, Synapse, Event Hubs, Databricks | DP-203 |

> ⭐ **AWS** tem maior volume de vagas no BR. **GCP/BigQuery** é muito forte em startups e fintechs.

---

### 2.7 Databricks — A Plataforma Unificada
```
O que estudar:
  - Workspace e Clusters
  - Delta Lake nativo
  - Notebooks colaborativos
  - Workflows (orquestração)
  - Unity Catalog (governança)
  - Databricks SQL
  - MLflow integrado
```
> Certificação: **Databricks Certified Data Engineer Associate/Professional**

---

### 2.8 Containerização e Infraestrutura

```dockerfile
# Docker — Obrigatório
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "pipeline.py"]
```

| Ferramenta | Nível Requerido |
|---|---|
| **Docker** | Obrigatório — criar imagens, docker-compose |
| **Kubernetes** | Intermediário — pods, deployments, services |
| **Terraform** | Recomendado — IaC para provisionar infra de dados |
| **Helm** | Para deploys K8s de ferramentas de dados |

---

### 2.9 Qualidade de Dados & Observabilidade
```
Great Expectations  → validação programática de dados
dbt Tests          → testes declarativos no pipeline SQL
Monte Carlo / Soda → observabilidade de dados (data quality monitoring)
Apache Atlas       → catalogação e linhagem
OpenMetadata       → catálogo open-source moderno
DataHub (LinkedIn) → catálogo + linhagem + governança
```

---

## FASE 3 — MACHINE LEARNING
> Prazo sugerido: 3–4 meses

### 3.1 Fundamentos de ML

#### Algoritmos que você DEVE dominar
```
SUPERVISIONADO:
  Regressão    → Linear, Ridge, Lasso, ElasticNet
  Classificação → Logistic Regression, SVM, KNN, Naive Bayes
  Ensemble     → Random Forest, Gradient Boosting (XGBoost, LightGBM, CatBoost)
  
NÃO-SUPERVISIONADO:
  Clustering   → K-Means, DBSCAN, Hierarchical
  Redução dim. → PCA, t-SNE, UMAP
  
OUTROS:
  Séries Temporais → ARIMA, Prophet, NeuralProphet, TimesFM
  Anomaly Detection → Isolation Forest, Autoencoders
```

#### Scikit-learn — Domínio total
```python
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.model_selection import cross_val_score, GridSearchCV

pipeline = Pipeline([
    ('scaler', StandardScaler()),
    ('model', GradientBoostingClassifier())
])

# Avaliação robusta
scores = cross_val_score(pipeline, X, y, cv=5, scoring='roc_auc')
```

---

### 3.2 Feature Engineering — O que separa bons de grandes modelos
```
- Encoding (OneHot, Target, Ordinal, Frequency)
- Scaling (StandardScaler, MinMax, RobustScaler)
- Feature Selection (RFE, SHAP, Mutual Information)
- Handling Imbalanced Data (SMOTE, class_weight)
- Missing Values (KNNImputer, IterativeImputer)
- Feature Store (Feast, Tecton, Vertex Feature Store)
```

---

### 3.3 Métricas de Avaliação
```
Classificação:  Accuracy, Precision, Recall, F1, ROC-AUC, PR-AUC
Regressão:      MAE, RMSE, MAPE, R²
Ranking:        NDCG, MAP
Negócio:        KPI lift, Revenue impact, Cost-benefit matrix
```

> ⚠️ **Saiba interpretar e escolher a métrica certa para o problema de negócio!**

---

### 3.4 Deep Learning

#### PyTorch (o framework dominante em pesquisa e produção)
```python
import torch
import torch.nn as nn

class MeuModelo(nn.Module):
    def __init__(self):
        super().__init__()
        self.layers = nn.Sequential(
            nn.Linear(128, 64),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(64, 1)
        )
    
    def forward(self, x):
        return self.layers(x)
```

**Arquiteturas para estudar:**
```
CNN          → Visão Computacional
RNN/LSTM     → Séries temporais (base)
Transformer  → Fundamento de toda IA moderna
Autoencoder  → Compressão e anomalias
GAN          → Geração de dados
Diffusion    → Geração de imagens (DALL-E, Stable Diffusion)
```

#### Bibliotecas de Alto Nível
| Biblioteca | Uso |
|---|---|
| **Hugging Face Transformers** | NLP, CV, Multimodal — padrão da indústria |
| **Keras** | Prototipagem rápida |
| **FastAI** | Transfer learning rápido |
| **timm** | Modelos de visão pré-treinados |
| **Lightning** | PyTorch boilerplate reduction |

---

### 3.5 MLOps — Levar ML para Produção

#### O ciclo MLOps completo
```
Data Collection → Feature Engineering → Training → Evaluation
      ↑                                                  ↓
  Monitoring  ←  Serving/Deployment ← Model Registry ←──┘
```

#### Stack MLOps do Mercado
| Categoria | Ferramentas |
|---|---|
| **Experiment Tracking** | **MLflow**, Weights & Biases (W&B), Neptune |
| **Model Registry** | MLflow Registry, Vertex AI, SageMaker |
| **Feature Store** | **Feast** (open-source), Tecton |
| **Pipeline CI/CD** | **ZenML**, Kubeflow Pipelines, Vertex Pipelines |
| **Serving** | **BentoML**, Seldon, TorchServe, Triton, Ray Serve |
| **Monitoramento** | **Evidently AI**, WhyLabs, Arize |
| **Data Versioning** | **DVC**, LakeFS |

```bash
# MLflow — básico que todo ML Engineer precisa saber
mlflow experiments create -n "meu_experimento"
mlflow run . -P alpha=0.5
mlflow models serve -m runs:/<run_id>/model --port 5000
```

---

### 3.6 Retrieval-Augmented Generation (RAG) como Feature de ML
- Embeddings como features em modelos clássicos
- Busca semântica para recomendação
- Vector Stores como Feature Store para embeddings

---

## FASE 4 — INTELIGÊNCIA ARTIFICIAL MODERNA (GenAI / LLMs)
> Prazo sugerido: 2–3 meses (área em constante evolução)

### 4.1 Fundamentos de LLMs

```
O que entender:
  - Arquitetura Transformer (Attention is All You Need)
  - Pre-training vs Fine-tuning vs Prompting
  - Tokenização
  - Context window e limitações
  - Temperature, Top-p, Top-k
  - Hallucination e mitigação
```

**Modelos que você deve conhecer:**
| Família | Modelos | Uso |
|---|---|---|
| OpenAI | GPT-4o, o1, o3 | API comercial |
| Meta | LLaMA 3.1/3.2/4 | Open-source, self-hosted |
| Google | Gemini 2.0/2.5, Gemma 3 | API + open |
| Mistral | Mistral Large, Mixtral | Open-source eficiente |
| Anthropic | Claude Sonnet/Opus | API comercial |
| DeepSeek | R1, V3 | Open-source, raciocínio |

---

### 4.2 Engenharia de Prompt
```
Técnicas obrigatórias:
  - Zero-shot e Few-shot prompting
  - Chain of Thought (CoT)
  - ReAct (Reason + Act)
  - Tree of Thought
  - System prompts e personas
  - Structured output (JSON mode)
  - Prompt injection e defesas
```

---

### 4.3 RAG — Retrieval Augmented Generation
```
Pipeline RAG completo:

[Documentos] → Chunking → Embedding → Vector Store
                                           ↓
[Query] → Embedding → Similarity Search → Contexto + LLM → Resposta

Ferramentas:
  - Embedding models: text-embedding-3, nomic-embed, BGE
  - Vector DBs: Chroma, FAISS, Pinecone, Weaviate, Qdrant, pgvector
  - Orquestração: LangChain, LlamaIndex
  - Avaliação RAG: RAGAS framework

Técnicas avançadas:
  - HyDE (Hypothetical Document Embeddings)
  - Re-ranking (Cohere, cross-encoders)
  - Hybrid Search (BM25 + semantic)
  - Agentic RAG
  - GraphRAG (Microsoft)
```

---

### 4.4 Fine-tuning de LLMs
```
Quando usar:
  ✓ Comportamento/tom específico do domínio
  ✓ Formato de saída muito específico
  ✓ Custo de inferência (modelo menor = mais barato)
  ✗ Quando RAG resolve (mais simples)

Técnicas:
  - Full fine-tuning (caro, para grandes empresas)
  - LoRA / QLoRA (mais usado — eficiente em memória)
  - PEFT (Parameter Efficient Fine-Tuning)
  - RLHF / DPO / PPO (alinhamento)

Ferramentas:
  - Hugging Face TRL + PEFT
  - Unsloth (QLoRA ultra rápido)
  - LLaMA-Factory
  - Axolotl
```

---

### 4.5 AI Agents — O Futuro do Trabalho com IA

#### O que são Agents
```
Agent = LLM + Tools + Memory + Planning

Componentes:
  - Reasoning (CoT, ReAct, Reflection)
  - Tool Use (APIs, código, buscas, DBs)
  - Memory (conversacional, episódica, semântica)
  - Multi-agent collaboration
```

#### Frameworks de Agents
| Framework | Foco | Popularidade |
|---|---|---|
| **LangChain / LangGraph** | Pipelines + Stateful Agents | ⭐⭐⭐⭐⭐ |
| **CrewAI** | Multi-agent colaborativo | ⭐⭐⭐⭐ |
| **AutoGen (Microsoft)** | Conversação multi-agent | ⭐⭐⭐⭐ |
| **Pydantic AI** | Agents type-safe | ⭐⭐⭐ |
| **Smolagents (HuggingFace)** | Lightweight agents | ⭐⭐⭐ |
| **OpenAI Agents SDK** | Novo padrão OpenAI | ⭐⭐⭐⭐ |

```python
# Exemplo conceitual — LangGraph Agent
from langgraph.graph import StateGraph, END
from langchain_openai import ChatOpenAI

# Nodes = steps do agente
# Edges = transições condicionais
# State = memória compartilhada entre nodes
```

---

### 4.6 Observabilidade e Avaliação de LLMs
```
Ferramentas:
  - LangSmith (tracing para LangChain)
  - LangFuse (open-source, qualquer LLM)
  - Phoenix (Arize) — debugging de LLMs
  - PromptLayer — versionamento de prompts
  
Métricas de avaliação:
  - RAGAS (faithfulness, relevance, context recall)
  - G-Eval
  - Human evaluation (gold standard)
```

---

### 4.7 Deploy e Infra para LLMs
```
Self-hosted inference:
  - Ollama (local, dev)
  - vLLM (produção, alta performance)
  - llama.cpp (CPU, edge)
  - TGI - Text Generation Inference (HuggingFace)

APIs gerenciadas:
  - OpenAI, Anthropic, Groq (ultra rápido), Together AI

Infra:
  - GPUs: NVIDIA A100/H100 (cloud), RTX 4090 (local)
  - Quantização: GGUF, GPTQ, AWQ
```

---

## FASE 5 — HABILIDADES TRANSVERSAIS

### 5.1 Soft Skills Técnicas Valorizadas no Mercado
```
✓ Documentação clara de pipelines e modelos
✓ Code review e boas práticas (PEP8, type hints, testes)
✓ Comunicar resultados técnicos para stakeholders
✓ Estimativa de custos de infraestrutura
✓ Pensamento em trade-offs (custo × performance × complexidade)
```

### 5.2 Testes e Qualidade de Código
```python
# Pytest para dados e ML
import pytest
import pandas as pd

def test_pipeline_output_schema():
    df = executar_pipeline()
    assert "usuario_id" in df.columns
    assert df["valor"].dtype == float
    assert df.shape[0] > 0
```

### 5.3 Design Patterns para Dados
```
- Medallion Architecture (Bronze/Silver/Gold)
- Lambda Architecture (batch + streaming)
- Kappa Architecture (tudo streaming)
- Data Mesh (domínios autônomos)
- Data Contract (produtor × consumidor)
```

---

## CERTIFICAÇÕES — Por Prioridade de Mercado

```
🥇 TIER 1 — Alta demanda, alto diferencial
   ├── AWS Certified Data Engineer Associate
   ├── Databricks Certified Data Engineer Associate
   ├── Google Professional Data Engineer
   └── dbt Analytics Engineering Certification

🥈 TIER 2 — Valor adicional significativo  
   ├── AWS ML Specialty
   ├── Databricks ML Professional
   ├── Snowflake SnowPro Core
   └── Azure DP-203 (Data Engineering on Azure)

🥉 TIER 3 — Complementares
   ├── Google TensorFlow Developer Certificate
   ├── AWS Solutions Architect Associate
   └── CKA — Certified Kubernetes Administrator
```

---

## RECURSOS DE APRENDIZADO

### Livros Essenciais
```
Engenharia de Dados:
  📘 "Fundamentals of Data Engineering" — Joe Reis & Matt Housley (O'Reilly)
  📘 "Designing Data-Intensive Applications" — Martin Kleppmann (obrigatório!)
  📘 "The Data Warehouse Toolkit" — Ralph Kimball

Machine Learning:
  📘 "Hands-On ML with Scikit-Learn, Keras & TensorFlow" — Aurélien Géron
  📘 "Pattern Recognition and ML" — Christopher Bishop (grátis online)
  📘 "Deep Learning" — Goodfellow, Bengio, Courville (deeplearningbook.org)

GenAI / LLMs:
  📘 "Build a Large Language Model (From Scratch)" — Sebastian Raschka
  📘 "Generative Deep Learning" — David Foster (O'Reilly)
```

### Plataformas de Cursos
| Plataforma | Foco |
|---|---|
| **Coursera** | Especializações com certificado (DeepLearning.AI, Google, IBM) |
| **DataCamp** | Trilhas práticas de dados e ML |
| **Udemy** | Cursos baratos, muito conteúdo prático |
| **fast.ai** | Deep Learning prático e gratuito |
| **DeepLearning.AI** | O melhor para IA (Andrew Ng) |
| **Hugging Face Course** | NLP e LLMs — 100% gratuito |
| **dbt Learn** | dbt oficial, gratuito |
| **DataTalksClub** | Bootcamps gratuitos (DE, MLOps, LLM) |

### YouTube / Comunidades
```
Canais imperdíveis:
  - Andrej Karpathy    → LLMs from scratch
  - 3Blue1Brown        → Matemática
  - StatQuest          → ML intuitivo
  - Yannic Kilcher     → Papers de AI
  - Data with Zach     → Data Engineering prático
  - Seattle Data Guy   → Carreira + técnico
  - Andreas Kretz      → Data Engineering

Comunidades BR:
  - Comunidade Data Hackers (Slack)
  - Pizza de Dados (Podcast + comunidade)
  - Engenharia de Dados BR (Discord)
```

---

## PLANO DE ESTUDO SUGERIDO (12 MESES)

```
MÊS 1-2  → Python avançado + SQL avançado + Git
MÊS 3-4  → Spark + dbt + Airflow + arquiteturas de dados  
MÊS 5    → Cloud (AWS ou GCP) + Docker + Terraform
MÊS 6    → Kafka + Streaming + Databricks + Delta Lake
MÊS 7-8  → ML clássico + Feature Engineering + Scikit-learn
MÊS 9    → Deep Learning (PyTorch) + MLOps (MLflow, DVC)
MÊS 10   → LLMs + RAG + Embeddings + Vector DBs
MÊS 11   → AI Agents + Fine-tuning + Observabilidade
MÊS 12   → Projetos completos + Portfólio + Certificações
```

---

## PROJETOS PARA PORTFÓLIO

### Nível Engenharia de Dados
```
1. Pipeline completo: API pública → Kafka → Spark → Delta Lake → dbt → Dashboard
2. ELT moderno: múltiplas fontes → BigQuery/Snowflake → dbt → Metabase
3. Data Quality Pipeline com Great Expectations + alertas Slack
4. Infraestrutura com Terraform + Airflow na AWS
```

### Nível ML / MLOps
```
5. Modelo preditivo com feature store (Feast) + MLflow + API (FastAPI) + monitoramento (Evidently)
6. Recomendação em tempo real: Kafka → feature store → modelo online → API
7. Detecção de anomalias em logs de aplicação
```

### Nível GenAI
```
8. RAG sobre documentos empresariais (PDFs) com LangChain + pgvector + LangFuse
9. AI Agent para análise de dados com ferramentas (SQL query, charts, alertas)
10. Fine-tuning de LLM para domínio específico (saúde, jurídico, finanças)
```

---

## STACK TÉCNICA — RESUMO EXECUTIVO

```
Linguagens:        Python, SQL
Processamento:     Apache Spark, dbt, Pandas, Polars
Orquestração:      Apache Airflow, Prefect ou Dagster
Streaming:         Apache Kafka, Apache Flink
Armazenamento:     Delta Lake / Iceberg, BigQuery, Snowflake, S3
Cloud:             AWS (prioridade) ou GCP
Plataforma:        Databricks
MLOps:             MLflow, DVC, Evidently, BentoML
DL Framework:      PyTorch + HuggingFace
GenAI Stack:       LangChain/LangGraph, vLLM, Ollama
Vector DBs:        Chroma, Qdrant, pgvector
Infra:             Docker, Kubernetes, Terraform
Qualidade:         Great Expectations, dbt Tests
Catálogo:          OpenMetadata ou DataHub
```

---

*Última atualização: Mai/2026 — A área evolui rapidamente. Revise este guia trimestralmente.*
