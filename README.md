# 👶 Análise de Nomes de Bebês nos EUA
> Documentação completa da análise realizada com **SQL** e **Python (Pandas)** sobre o dataset `names` + `regions`

---

## 📋 Sobre o Dataset

O projeto utiliza **dois datasets** combinados via JOIN/merge para enriquecer a análise com informações geográficas.

### Tabela `names`

| Coluna | Tipo | Descrição |
|---|---|---|
| `State` | Texto | Sigla do estado americano (ex: CA, TX, NY) |
| `Gender` | Texto | Gênero do nome (`M` para masculino, `F` para feminino) |
| `Year` | Inteiro | Ano de registro |
| `Name` | Texto | Nome do bebê |
| `Births` | Inteiro | Quantidade de nascimentos com aquele nome |

### Tabela `regions`

| Coluna | Tipo | Descrição |
|---|---|---|
| `State` | Texto | Sigla do estado (chave de junção com `names`) |
| `Region` | Texto | Região geográfica dos EUA (South, Pacific, Midwest, etc.) |

> 📌 O dataset `names` contém **2.212.361 registros** abrangendo todos os 50 estados americanos + DC, de 1980 a 2009.

---

## 🔍 Análises Realizadas

---

### 1. Visualizar todos os dados

**SQL**
```sql
SELECT * FROM names;
```

**O que faz:** Retorna todas as colunas e linhas da tabela — o ponto de partida de qualquer análise exploratória.

**Por que foi feita:** Antes de qualquer filtro ou agrupamento, é essencial entender como os dados estão estruturados, como os valores estão formatados e se há inconsistências visíveis.

**Python**
```python
import pandas as pd

df_nomes = pd.read_csv('names.csv', sep=';')
df_nomes.head()
```

**Por que esse modo:** O `pd.read_csv()` carrega o arquivo direto em um DataFrame — estrutura de dados tabular do Pandas, equivalente a uma tabela SQL. O `.head()` exibe as 5 primeiras linhas, assim como um `SELECT *` com `LIMIT 5`. O parâmetro `sep=';'` indica que o arquivo usa ponto e vírgula como separador (em vez da vírgula padrão).

**Resultado (primeiras 5 linhas):**

| State | Gender | Year | Name | Births |
|---|---|---|---|---|
| AK | F | 1980 | Jessica | 116 |
| AK | F | 1980 | Jennifer | 114 |
| AK | F | 1980 | Sarah | 82 |
| AK | F | 1980 | Amanda | 71 |
| AK | F | 1980 | Melissa | 65 |

---

### 2. Quantidade total de registros

**SQL**
```sql
SELECT COUNT(*) FROM names;
```

**O que faz:** Conta o número total de linhas da tabela.

**Por que foi feita:** Confirma o tamanho do dataset e valida se os dados foram carregados corretamente.

**Funções SQL usadas:**
- `COUNT(*)` — conta todas as linhas, independentemente de valores nulos

**Python**
```python
df_nomes.shape
```

**Por que esse modo:** O atributo `.shape` retorna uma tupla `(linhas, colunas)` — é instantâneo, não exige chamada de função e é a forma mais idiomática de verificar as dimensões de um DataFrame. Não há equivalente mais simples.

**Resultado:**

| Abordagem | Resultado |
|---|---|
| SQL `COUNT(*)` | 2.212.361 |
| Python `.shape` | `(1048575, 5)` ⚠️ |

> ⚠️ **Atenção:** O Python retornou apenas **1.048.575 linhas** porque o arquivo `names.csv` foi lido parcialmente — essa é a limitação padrão do Excel ao abrir ou exportar CSVs grandes (~1 milhão de linhas). O dado completo (2.212.361 registros) só estava disponível no banco SQL. Para datasets grandes, prefira trabalhar diretamente com bancos de dados ou plataformas como o Databricks, que não têm esse limite.

---

### 3. Quantidade de nomes femininos e masculinos

**SQL**
```sql
-- Femininos
SELECT COUNT(*) FROM names WHERE Gender = 'F';

-- Masculinos
SELECT COUNT(*) FROM names WHERE Gender = 'M';
```

**O que faz:** Conta separadamente os registros de cada gênero.

**Por que foi feita:** Permite entender a distribuição de registros entre os dois gêneros no dataset.

**Funções SQL usadas:**
- `WHERE Gender = 'F'` / `WHERE Gender = 'M'` — filtra por valor exato na coluna de gênero

---

**Python — Jeito Tradicional (sem Pandas)**
```python
quantidade_feminino = 0
quantidade_masculino = 0

for i in df_nomes['Gender']:
    if i == 'F':
        quantidade_feminino += 1
    else:
        quantidade_masculino += 1

print('feminino: ', quantidade_feminino)
print('masculino: ', quantidade_masculino)
```

**Por que esse modo existe:** É a lógica imperativa pura — percorre linha por linha e acumula contadores. Funciona em qualquer linguagem e é fácil de entender para quem está aprendendo lógica de programação. O problema é que, em Python, loops sobre DataFrames são **muito lentos** para grandes volumes de dados, porque não aproveitam a vetorização interna do Pandas/NumPy.

---

**Python — Jeito Pandas**
```python
df_nomes['Gender'].value_counts()
```

**Por que esse modo:** O `.value_counts()` conta a frequência de cada valor único em uma coluna em **uma única linha de código**. Internamente, ele usa operações vetorizadas em C (via NumPy), sendo ordens de magnitude mais rápido que o loop manual. É a forma recomendada sempre que se precisa contar ocorrências por categoria.

**Resultado:**

| Gênero | SQL | Python (amostra*) |
|---|---|---|
| Feminino (F) | 1.245.104 | 601.301 |
| Masculino (M) | 967.257 | 447.274 |

> *Diferença explicada pelo limite de linhas no CSV carregado no Python (ver análise 2).

> 📌 O dataset completo possui **~56% de registros femininos** e **~44% masculinos**, indicando maior diversidade de nomes atribuídos a meninas.

---

### 4. Quantidade de estados diferentes

**SQL**
```sql
SELECT COUNT(DISTINCT "State") AS quantidade_de_estados FROM names;
```

**O que faz:** Conta quantos estados distintos aparecem na tabela.

**Funções SQL usadas:**
- `COUNT(DISTINCT "State")` — conta apenas os valores únicos, ignorando repetições

**Python**
```python
# Lista todos os estados únicos
estados = df_nomes['State'].unique()

# Conta quantos são
qtd_estados = len(df_nomes['State'].unique())

print(estados)
print(qtd_estados)
```

**Por que esse modo:** O `.unique()` retorna um array NumPy com todos os valores distintos de uma coluna — equivalente ao `DISTINCT` do SQL. O `len()` ao redor conta quantos são, equivalendo ao `COUNT(DISTINCT ...)`. Separar as duas operações (listar e contar) é útil porque muitas vezes queremos inspecionar os valores além de só saber a quantidade.

**Resultado:**

| quantidade_de_estados |
|---|
| 51 |

> 📌 O dataset cobre os 50 estados americanos + o **Distrito de Colúmbia (DC)**.

---

### 5. Quantidade de nascimentos por estado

**SQL**
```sql
SELECT
    DISTINCT "State",
    SUM("Births") AS quantidade_de_nomes
FROM names
GROUP BY "State"
ORDER BY quantidade_de_nomes DESC;
```

**O que faz:** Soma todos os nascimentos registrados por estado e ordena do maior para o menor.

**Funções SQL usadas:**
- `SUM("Births")` — soma os valores da coluna dentro de cada grupo
- `GROUP BY "State"` — agrupa os registros por estado antes de aplicar a soma
- `ORDER BY quantidade_de_nomes DESC` — ordena do maior para o menor

**Python**
```python
nascimento_por_estado = (
    df_nomes
    .groupby('State')['Births']
    .sum()
    .sort_values(ascending=False)
)
print(nascimento_por_estado)
```

**Por que esse modo:** O `.groupby('State')` agrupa o DataFrame por estado — equivalente ao `GROUP BY` do SQL. O `['Births'].sum()` seleciona a coluna e aplica a soma dentro de cada grupo — equivalente ao `SUM("Births")`. O `.sort_values(ascending=False)` ordena de forma decrescente — equivalente ao `ORDER BY ... DESC`. A cadeia de métodos (method chaining) é a maneira Pandas de escrever transformações sequenciais de forma legível e sem criar variáveis intermediárias desnecessárias.

**Resultado (top 5):**

| State | Nascimentos |
|---|---|
| CA | 9.293.029 |
| IL | 3.142.760 |
| FL | 2.983.402 |
| TX | 2.716.289 |
| NY | 2.279.057 |
| ... | ... |
| WY | 60.385 |

> 📌 **Califórnia (CA)** lidera com folga, seguida por Illinois e Florida.

---

### 6. Quantidade de nascimentos por ano

**SQL**
```sql
SELECT
    DISTINCT "Year",
    SUM("Births") AS quantidade_de_nascimento_por_ano
FROM names
GROUP BY "Year"
ORDER BY quantidade_de_nascimento_por_ano DESC;
```

**O que faz:** Soma os nascimentos de todos os estados por ano e ordena do mais alto ao mais baixo, revelando tendências demográficas ao longo do tempo.

**Python**
```python
df_nomes.groupby('Year')['Births'].sum().sort_values(ascending=False)
```

**Por que esse modo:** Mesma estrutura da análise anterior, trocando apenas a coluna de agrupamento. O poder do `.groupby()` é ser genérico — a mesma lógica serve para qualquer dimensão de análise sem reescrever código.

**Resultado:**

| Year | Nascimentos |
|---|---|
| 1990 | 3.566.753 |
| 1991 | 3.502.904 |
| 1989 | 3.475.391 |
| ... | ... |
| 1980 | 3.130.607 |

> 📌 O pico de nascimentos ocorreu em **1990**, com mais de 3,5 milhões de registros. O início dos anos 90 e o período 2006–2008 se destacam como os momentos de maior natalidade.

---

### 7. JOIN para adicionar a região de outra tabela

**SQL**
```sql
SELECT
    n.State, n.Name, n."Year", n.Gender, n.Births, r.Region
FROM names n
JOIN regions r ON n.State = r.State;
```

**O que faz:** Combina as duas tabelas com base na coluna `State`, adicionando a coluna `Region` a cada registro.

**Conceitos SQL usados:**
- `JOIN ... ON n.State = r.State` — une as tabelas onde os estados coincidem
- **Aliases** (`n` e `r`) — simplificam a escrita e evitam ambiguidade entre colunas de mesmo nome

**Python**
```python
# Cria uma cópia do DataFrame original para não modificar o original
df_join_nomes = df_nomes.copy()

# Lê a tabela de regiões
df_regions = pd.read_csv('regions.csv', sep=';')

# Faz o merge (equivalente ao JOIN) pela coluna 'State'
df_join_nomes_regiao = df_join_nomes.merge(df_regions, on='State')

print(df_join_nomes_regiao.head())
```

**Por que esse modo:** O `.merge()` é o equivalente direto do `JOIN` no Pandas. O parâmetro `on='State'` define a coluna-chave para a junção, exatamente como o `ON n.State = r.State` do SQL. O `.copy()` é uma boa prática: preserva o DataFrame original intacto, evitando efeitos colaterais em análises futuras. Por padrão, `.merge()` faz um `INNER JOIN` — traz apenas os registros com correspondência nas duas tabelas.

**Resultado (primeiras 5 linhas):**

| State | Name | Year | Gender | Births | Region |
|---|---|---|---|---|---|
| AK | Jessica | 1980 | F | 116 | Pacific |
| AK | Jennifer | 1980 | F | 114 | Pacific |
| AK | Sarah | 1980 | F | 82 | Pacific |
| AK | Amanda | 1980 | F | 71 | Pacific |
| AK | Melissa | 1980 | F | 65 | Pacific |

---

### 8. Total de nascimentos por região

**SQL — com Subquery**
```sql
SELECT Region, COUNT(*) AS total
FROM (
    SELECT n.State, r.Region
    FROM names n
    JOIN regions r ON n.State = r.State
) t
GROUP BY Region;
```

**SQL — com CTE (mais legível)**
```sql
WITH base AS (
    SELECT n.State, r.Region
    FROM names n
    JOIN regions r ON n.State = r.State
)
SELECT Region, COUNT(*) AS total
FROM base
GROUP BY Region;
```

**Subquery vs CTE:** Ambas chegam ao mesmo resultado. A **Subquery** é suficiente para transformações pontuais de uso único — o resultado intermediário não tem nome e não pode ser referenciado novamente. A **CTE** (`WITH ... AS`) é preferível quando a lógica intermediária é reutilizada em múltiplos trechos da query ou quando se quer mais legibilidade, pois nomeia explicitamente cada etapa de transformação.

**Python**
```python
df_join_nomes_regiao.groupby('Region')['Births'].sum().sort_values(ascending=False)
```

**Por que esse modo:** Após o merge já ter sido feito (análise anterior), o DataFrame `df_join_nomes_regiao` já possui a coluna `Region`. O agrupamento fica em uma linha, sem necessidade de subquery ou CTE — a etapa de "join" já está resolvida no DataFrame em memória.

**Resultado:**

| Region | Nascimentos |
|---|---|
| South | 16.774.329 |
| Midwest | 11.163.869 |
| Pacific | 10.605.794 |
| Mid_Atlantic | 5.298.979 |
| Mountain | 3.139.653 |
| New_England | 2.606.957 |

> 📌 A região **South** concentra a maior quantidade de registros, reflexo dos estados populosos como Texas, Florida e Georgia.

---

### 9. Gênero dominante por região

**SQL — com CTE e CASE WHEN**
```sql
WITH base AS (
    SELECT n.State, n.Name, n."Year", n.Gender, n.Births, r.Region
    FROM names n
    JOIN regions r ON n.State = r.State
)
SELECT
    Region,
    SUM(CASE WHEN Gender = 'M' THEN Births ELSE 0 END) AS total_masculino,
    SUM(CASE WHEN Gender = 'F' THEN Births ELSE 0 END) AS total_feminino,
    CASE
        WHEN SUM(CASE WHEN Gender = 'M' THEN Births ELSE 0 END) >
             SUM(CASE WHEN Gender = 'F' THEN Births ELSE 0 END) THEN 'M'
        WHEN SUM(CASE WHEN Gender = 'F' THEN Births ELSE 0 END) >
             SUM(CASE WHEN Gender = 'M' THEN Births ELSE 0 END) THEN 'F'
        ELSE 'Empate'
    END AS quem_tem_mais
FROM base
GROUP BY Region;
```

**O que faz:** Calcula o total de nascimentos masculinos e femininos por região e determina qual gênero predomina. É a consulta mais completa do projeto, combinando JOIN, CTE, agregações e lógica condicional.

**Conceitos SQL usados:**
- **CTE (`WITH base AS`)** — tabela temporária nomeada que resolve o JOIN uma vez e reutiliza o resultado
- `SUM(CASE WHEN Gender = 'M' THEN Births ELSE 0 END)` — **pivot condicional**: soma apenas os births do gênero desejado, usando 0 para ignorar o outro. Evita múltiplas subqueries separadas
- `CASE ... END AS quem_tem_mais` — lógica condicional que classifica o resultado final

**Python equivalente**
```python
# Agrupa por Região e Gênero, somando os nascimentos
pivot = (
    df_join_nomes_regiao.groupby(['Region', 'Gender'])['Births'].sum().unstack(fill_value=0)
)

# Renomeia as colunas para clareza
pivot.columns = ['total_feminino', 'total_masculino']

# Cria a coluna de gênero dominante
pivot['quem_tem_mais'] = pivot.apply(
    lambda row: 'M' if row['total_masculino'] > row['total_feminino']
                else ('F' if row['total_feminino'] > row['total_masculino']
                      else 'Empate'),
    axis=1
)

print(pivot)
```

**Por que esse modo:** O `.groupby(['Region', 'Gender'])` agrupa por dois níveis simultaneamente. O `.unstack()` "pivota" o gênero de linhas para colunas — o equivalente Python do `SUM(CASE WHEN Gender = 'M' THEN ... ELSE 0)` do SQL. O `.apply()` com `lambda` aplica uma função linha a linha para criar a coluna classificatória — equivalente ao `CASE ... END` final. Essa abordagem é mais verbosa que o SQL nesse caso específico, mas muito mais fácil de encadear com visualizações (gráficos Matplotlib/Seaborn) ou exportações posteriores.

**Resultado:**

| Region | total_masculino | total_feminino | quem_tem_mais |
|---|---|---|---|
| South | 18.389.979 | 15.829.941 | M |
| Midwest | 10.288.357 | 8.956.724 | M |
| Pacific | 9.280.220 | 8.260.496 | M |
| Mid_Atlantic | 7.332.347 | 6.410.320 | M |
| Mountain | 3.447.289 | 2.834.928 | M |
| New_England | 2.116.785 | 1.806.225 | M |

> 📌 Em **todas as regiões dos EUA**, o número de nascimentos masculinos supera o feminino. Esse padrão é consistente com dados demográficos globais, onde a razão de nascimentos costuma ser de aproximadamente **105 meninos para cada 100 meninas**.

---

## 🧠 Conceitos Utilizados

### SQL

| Conceito | Onde foi usado |
|---|---|
| `SELECT`, `FROM`, `WHERE` | Consultas básicas de filtragem |
| `COUNT(*)` | Contagem de linhas |
| `COUNT(DISTINCT ...)` | Contagem de valores únicos |
| `SUM()` | Soma de nascimentos por grupo |
| `GROUP BY` | Agrupamento por estado, ano e região |
| `ORDER BY ... DESC` | Ordenação decrescente |
| `JOIN ... ON` | Combinação de duas tabelas |
| **Subquery** | Encapsulamento de transformações pontuais |
| **CTE (`WITH ... AS`)** | Tabela temporária nomeada e reutilizável |
| `CASE WHEN ... THEN ... END` | Lógica condicional e pivot agregado |

### Python / Pandas

| Método Pandas | Equivalente SQL |
|---|---|
| `pd.read_csv()` | — (carregamento de dados) |
| `.head()` | `SELECT * ... LIMIT 5` |
| `.shape` | `COUNT(*)` |
| `.value_counts()` | `COUNT(*) ... GROUP BY` |
| `.unique()` | `SELECT DISTINCT` |
| `len(.unique())` | `COUNT(DISTINCT ...)` |
| `.groupby().sum()` | `GROUP BY + SUM()` |
| `.sort_values()` | `ORDER BY` |
| `.merge()` | `JOIN ... ON` |
| `.unstack()` | `CASE WHEN ... ELSE 0` (pivot) |
| `.apply(lambda ...)` | `CASE WHEN ... END` |

---

## ⚖️ SQL vs Python: Quando usar cada um?

| Situação | Recomendação |
|---|---|
| Dataset grande (>1M linhas) em banco de dados | ✅ **SQL** — processa direto no banco, sem mover dados |
| Análise exploratória rápida em arquivo local | ✅ **Python/Pandas** — flexível e iterativo |
| Combinar múltiplas tabelas com lógica complexa | ✅ **SQL** — JOINs e CTEs são mais declarativos |
| Preparar dados para gráficos ou machine learning | ✅ **Python** — integração nativa com matplotlib, seaborn, sklearn |
| Compartilhar lógica com time de dados/BI | ✅ **SQL** — universal e legível por analistas sem Python |
| Iteração rápida e transformações encadeadas | ✅ **Python** — method chaining é ágil para exploração |

---

*Análise realizada com SQLite e Python/Pandas sobre os datasets `names.csv` (2.212.361 registros, 1980–2009) e `regions.csv` (51 estados + regiões dos EUA).*
