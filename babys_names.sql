--tabela nome de bebe
SELECT * FROM names;

-- quantidade de linhas
SELECT 
	COUNT(*)
FROM 
	names
;

--quantidade de nome feminino
SELECT 
	COUNT(*)
FROM
	names
WHERE 
	Gender = 'F'
	
--quantidade de nome masculino
SELECT 
	COUNT(*)
FROM
	names
WHERE 
	Gender = 'M'
;

--quantidade de estados diferentes
SELECT 
	COUNT(DISTINCT "State") AS quantida_de_estados
FROM
	names
;
--os 51 estados
SELECT 
	DISTINCT "State"
FROM
	names
;

--quantidade de nascido por estado
SELECT 
	DISTINCT "State",
	SUM("Births") AS quantidade_de_nomes
FROM
	names
GROUP BY 
	"State"
ORDER BY
	quantidade_de_nomes DESC
;

--quantidade de nascimento por ano
SELECT
	DISTINCT "Year",
	SUM("Births") AS quantidade_de_nascimento_por_ano
FROM 
	names
GROUP BY
	"Year"
ORDER BY 
	quantidade_de_nascimento_por_ano DESC 
;

-- join para adicionar região de outra tabela
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
		ON n.State = r.State
;

--PODEMOS REALIZAR A ANALISE USANDO SUBQUERY, CTE, TABELA TEMP ETC...

-- realizando a analise com subquery
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
	Region
;

-- criando um CTE para realizar uma analise
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

    SUM(CASE WHEN Gender = 'M' THEN Births ELSE 0 END) AS total_macho,
    SUM(CASE WHEN Gender = 'F' THEN Births ELSE 0 END) AS total_femea,

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
	Region
;
