# 👶 Análise de Nomes de Bebês nos EUA
> Documentação da análise SQL realizada sobre o dataset `names` + `regions`

---

## 📋 Sobre o Dataset

O projeto utiliza **dois datasets** combinados via JOIN para enriquecer a análise com informações geográficas.

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

## 🔍 Consultas Realizadas

---

### 1. Visualizar todos os dados

```sql
SELECT * FROM names;
```

**O que faz:** Retorna todas as colunas e linhas da tabela — o ponto de partida de qualquer análise exploratória.

**Por que foi feita:** Antes de qualquer filtro ou agrupamento, é essencial entender como os dados estão estruturados, como os valores estão formatados e se há inconsistências visíveis.

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

```sql
SELECT 
    COUNT(*)
FROM 
    names;
```

**O que faz:** Conta o número total de linhas da tabela.

**Por que foi feita:** Confirma o tamanho do dataset e valida se os dados foram carregados corretamente.

**Funções usadas:**
- `COUNT(*)` — conta todas as linhas, independentemente de valores nulos

**Resultado:**

| COUNT(*) |
|---|
| 2.212.361 |

---

### 3. Quantidade de nomes femininos e masculinos

```sql
-- Femininos
SELECT 
    COUNT(*)
FROM
    names
WHERE 
    Gender = 'F';

-- Masculinos
SELECT 
    COUNT(*)
FROM
    names
WHERE 
    Gender = 'M';
```

**O que faz:** Conta separadamente os registros de cada gênero.

**Por que foi feita:** Permite entender a distribuição de registros entre os dois gêneros no dataset.

**Funções e conceitos usados:**
- `WHERE Gender = 'F'` / `WHERE Gender = 'M'` — filtra por valor exato na coluna de gênero

**Resultado:**

| Gênero | Quantidade de Registros |
|---|---|
| Feminino (F) | 1.245.104 |
| Masculino (M) | 967.257 |

> 📌 O dataset possui **~56% de registros femininos** e **~44% masculinos**, indicando maior diversidade de nomes atribuídos a meninas.

---

### 4. Quantidade de estados diferentes

```sql
SELECT 
    COUNT(DISTINCT "State") AS quantidade_de_estados
FROM
    names;
```

**O que faz:** Conta quantos estados distintos aparecem na tabela.

**Por que foi feita:** Verifica a cobertura geográfica do dataset — quantos dos 50 estados americanos estão representados.

**Funções usadas:**
- `COUNT(DISTINCT "State")` — conta apenas os valores únicos, ignorando repetições

**Resultado:**

| quantidade_de_estados |
|---|
| 51 |

> 📌 O dataset cobre os 50 estados americanos + o **Distrito de Colúmbia (DC)**.

---

### 5. Os 51 estados

```sql
SELECT 
    DISTINCT "State"
FROM
    names;
```

**O que faz:** Lista todos os estados únicos presentes no dataset.

**Resultado (51 estados):**

| State | State | State | State | State |
|---|---|---|---|---|
| AK | AL | AR | AZ | CA |
| CO | CT | DC | DE | FL |
| GA | HI | IA | ID | IL |
| IN | KS | KY | LA | MA |
| MD | ME | MI | MN | MO |
| MS | MT | NC | ND | NE |
| NH | NJ | NM | NV | NY |
| OH | OK | OR | PA | RI |
| SC | SD | TN | TX | UT |
| VA | VT | WA | WI | WV |
| WY | — | — | — | — |

---

### 6. Quantidade de nascimentos por estado

```sql
SELECT 
    DISTINCT "State",
    SUM("Births") AS quantidade_de_nomes
FROM
    names
GROUP BY 
    "State"
ORDER BY
    quantidade_de_nomes DESC;
```

**O que faz:** Soma todos os nascimentos registrados por estado e ordena do maior para o menor.

**Por que foi feita:** Permite identificar quais estados concentram mais nascimentos — o que tende a refletir diretamente o tamanho populacional de cada estado.

**Funções usadas:**
- `SUM("Births")` — soma os valores da coluna dentro de cada grupo
- `GROUP BY "State"` — agrupa os registros por estado antes de aplicar a soma
- `ORDER BY quantidade_de_nomes DESC` — ordena do maior para o menor

**Resultado:**

| State | quantidade_de_nomes | State | quantidade_de_nomes |
|---|---|---|---|
| CA | 14.076.348 | NC | 2.606.180 |
| TX | 9.078.670 | VA | 2.245.955 |
| NY | 6.689.160 | IN | 2.157.107 |
| FL | 4.768.528 | MA | 2.085.087 |
| IL | 4.597.638 | MO | 1.970.363 |
| OH | 4.101.121 | TN | 1.931.631 |
| PA | 4.032.694 | WA | 1.886.379 |
| MI | 3.431.049 | AZ | 1.840.210 |
| GA | 2.818.204 | WI | 1.751.439 |
| NJ | 2.698.857 | MN | 1.708.393 |
| … | … | WY | 128.678 |

> 📌 **Califórnia (CA)** lidera com folga — mais de 14 milhões de nascimentos registrados —, seguida por Texas e Nova York. Os estados menos populosos como Wyoming e Vermont aparecem no final da lista.

---

### 7. Quantidade de nascimentos por ano

```sql
SELECT
    DISTINCT "Year",
    SUM("Births") AS quantidade_de_nascimento_por_ano
FROM 
    names
GROUP BY
    "Year"
ORDER BY 
    quantidade_de_nascimento_por_ano DESC;
```

**O que faz:** Soma os nascimentos de todos os estados por ano e ordena do mais alto ao mais baixo.

**Por que foi feita:** Permite identificar tendências demográficas ao longo do tempo — anos de baby boom, quedas ou recuperações na taxa de natalidade.

**Funções usadas:**
- `GROUP BY "Year"` — agrupa os dados por ano
- `ORDER BY ... DESC` — exibe os anos com mais nascimentos primeiro

**Resultado:**

| Year | quantidade_de_nascimento_por_ano |
|---|---|
| 1990 | 3.566.753 |
| 1991 | 3.502.904 |
| 1989 | 3.475.391 |
| 1992 | 3.442.429 |
| 2007 | 3.413.961 |
| 2006 | 3.388.984 |
| 1993 | 3.364.179 |
| 2008 | 3.342.040 |
| 1988 | 3.341.106 |
| 1994 | 3.307.545 |
| 1995 | 3.249.605 |
| 1996 | 3.225.359 |
| 2001 | 3.251.626 |
| 2002 | 3.238.625 |
| 2009 | 3.234.208 |
| 1980 | 3.130.607 |

> 📌 O pico de nascimentos ocorreu em **1990**, com mais de 3,5 milhões de registros. O início dos anos 90 e o período 2006–2008 se destacam como os momentos de maior natalidade no dataset.

---

### 8. JOIN para adicionar a região de outra tabela

```sql
SELECT 
    n.State,
    n.Name,
    n."Year",
    n.Gender,
    n.Births,
    r.Region
FROM 
    names n
JOIN 
    regions r
        ON n.State = r.State;
```

**O que faz:** Combina as duas tabelas (`names` e `regions`) com base na coluna `State`, adicionando a coluna `Region` a cada registro.

**Por que foi feita:** A tabela `names` não possui informação regional. O JOIN enriquece os dados, permitindo análises por macrorregião (South, Pacific, Midwest, etc.) em vez de estado individual.

**Conceitos usados:**
- `JOIN ... ON n.State = r.State` — une as tabelas onde os estados coincidem
- **Aliases** (`n` e `r`) — simplificam a escrita e evitam ambiguidade entre colunas de mesmo nome

**Resultado (primeiras 5 linhas com região):**

| State | Name | Year | Gender | Births | Region |
|---|---|---|---|---|---|
| AK | Jessica | 1980 | F | 116 | Pacific |
| AK | Jennifer | 1980 | F | 114 | Pacific |
| AK | Sarah | 1980 | F | 82 | Pacific |
| AK | Amanda | 1980 | F | 71 | Pacific |
| AK | Melissa | 1980 | F | 65 | Pacific |

---

### 9. Análise por região com Subquery

```sql
SELECT
    Region,
    COUNT(*) AS total
FROM (
    SELECT
        n.State,
        r.Region
    FROM 
        names n
    JOIN 
        regions r
            ON n.State = r.State
) t
GROUP BY 
    Region;
```

**O que faz:** Usa uma subquery para fazer o JOIN e, em seguida, conta o total de registros por macrorregião.

**Por que foi feita:** Demonstra como subqueries podem encapsular transformações complexas, tornando a query externa mais simples e legível.

**Funções e conceitos usados:**
- **Subquery** — a query interna é executada primeiro e seu resultado (`t`) serve como fonte para a query externa
- `GROUP BY Region` — agrupa os resultados por região

**Resultado:**

| Region | total |
|---|---|
| South | 798.502 |
| Midwest | 441.464 |
| Pacific | 294.260 |
| Mid_Atlantic | 267.785 |
| Mountain | 221.741 |
| New_England | 107.402 |

> 📌 A região **South** concentra a maior quantidade de registros, reflexo dos estados populosos como Texas, Florida e Georgia que a compõem.

---

### 10. Análise por região com CTE — Gênero dominante

```sql
WITH base AS (
    SELECT 
        n.State,
        n.Name,
        n."Year",
        n.Gender,
        n.Births,
        r.Region
    FROM names n
    JOIN regions r
        ON n.State = r.State
)
SELECT
    Region,
    SUM(CASE WHEN Gender = 'M' THEN Births ELSE 0 END) AS total_masculino,
    SUM(CASE WHEN Gender = 'F' THEN Births ELSE 0 END) AS total_feminino,
    CASE 
        WHEN SUM(CASE WHEN Gender = 'M' THEN Births ELSE 0 END) >
             SUM(CASE WHEN Gender = 'F' THEN Births ELSE 0 END)
        THEN 'M'
        WHEN SUM(CASE WHEN Gender = 'F' THEN Births ELSE 0 END) >
             SUM(CASE WHEN Gender = 'M' THEN Births ELSE 0 END)
        THEN 'F'
        ELSE 'Empate'
    END AS quem_tem_mais
FROM 
    base
GROUP BY 
    Region;
```

**O que faz:** Cria uma CTE (`base`) com o JOIN já resolvido e, a partir dela, calcula o total de nascimentos masculinos e femininos por região — além de determinar qual gênero predomina em cada uma.

**Por que foi feita:** É o ponto culminante da análise: combina JOIN, CTE, CASE WHEN e agregações para responder uma pergunta de negócio clara — *"em qual região nascem mais meninos ou meninas?"*

**Funções e conceitos usados:**
- **CTE (`WITH base AS`)** — define uma tabela temporária nomeada, reutilizável dentro da query principal, melhorando a legibilidade em relação a subqueries aninhadas
- `SUM(CASE WHEN ... THEN ... ELSE 0 END)` — técnica de **pivot condicional**: soma apenas os births de um gênero, usando 0 para o outro. Evita múltiplos JOINs ou subqueries separadas
- `CASE ... END AS quem_tem_mais` — lógica condicional para classificar o resultado
- `GROUP BY Region` — agrupa o resultado final por macrorregião

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

## 🧠 Conceitos SQL Utilizados

| Conceito | Onde foi usado |
|---|---|
| `SELECT`, `FROM`, `WHERE` | Consultas básicas de filtragem |
| `COUNT(*)` | Contagem de linhas |
| `COUNT(DISTINCT ...)` | Contagem de valores únicos |
| `SUM()` | Soma de nascimentos por grupo |
| `GROUP BY` | Agrupamento por estado, ano e região |
| `ORDER BY ... DESC` | Ordenação decrescente |
| `JOIN ... ON` | Combinação de duas tabelas |
| **Subquery** | Encapsulamento de transformações |
| **CTE (`WITH ... AS`)** | Tabela temporária nomeada e reutilizável |
| `CASE WHEN ... THEN ... END` | Lógica condicional e pivot agregado |
| `LIKE '%...%'` | Filtragem por padrão de texto |

---

*Análise realizada com SQLite sobre os datasets `names.csv` (2.212.361 registros, 1980–2009) e `regions.csv` (51 estados + regiões dos EUA).*
