--w4, rollA müük + kliendid (müük A ja inventuur C)

--MÜÜK A
--1. Müük kuude kaupa. Kirjuta päring, mis näitab 2024. aasta iga kuu kohta: tellimuste arv, kogukäive, keskmine tellimusväärtus. Kasuta DATE_TRUNC('month', sale_date) grupeerimiseks Struktuur:
SELECT      
  DATE_TRUNC('month', sale_date) AS kuu,      
  COUNT(sale_id) AS tellimuste_arv,      
  SUM(total_price) AS kogukäive,      
  ROUND(AVG(total_price), 2) AS keskmine_tellimus    
FROM sales    
WHERE sale_date between '2024-01-01' and '2024-12-31'
GROUP BY DATE_TRUNC('month', sale_date)   
ORDER BY kuu; 


--2. Müük kategooriate kaupa — kirjuta ise, kasutades ülaltoodud mustrit:
--Ühenda sales ja products    - GROUP BY category    - Lisa: toodete arv, kogumüük, keskmine hind    - HAVING: ainult kategooriad, kus kogumüük > vali ise piir
SELECT 
    p.category,
    COUNT(s.sale_id) AS toodete_arv,
    SUM(s.total_price) AS kogumuuk,
    ROUND(AVG(s.total_price), 2) AS keskmine_hind
FROM sales s
JOIN products p 
    ON s.product_id = p.product_id
WHERE s.sale_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY p.category
HAVING SUM(s.total_price) > 1000
ORDER BY kogumuuk DESC;


--3. Kuised trendid CTE-ga. Kasuta CTE-d, et leida kuust-kuusse muutus:
    SELECT
        DATE_TRUNC('month', sale_date) AS kuu,
        SUM(total_price) AS kaive
    FROM sales
    WHERE sale_date >= '2024-01-01'
    GROUP BY DATE_TRUNC('month', sale_date)
)

SELECT
    kuu,
    kaive,
    LAG(kaive) OVER (ORDER BY kuu) AS eelmine_kuu,
    kaive - LAG(kaive) OVER (ORDER BY kuu) AS muutus
FROM kuu_myyk
ORDER BY kuu;

--Baas (70%): Sammud 1-2 (GROUP BY + HAVING päringud).
--Edasijõudnute (30%): Samm 3 — CTE + window function, arvuta kuust-kuusse kasvu protsent:
WITH kuu_myyk AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS kuu,
        SUM(total_price) AS kaive
    FROM sales
    WHERE sale_date >= '2024-01-01'
    GROUP BY DATE_TRUNC('month', sale_date)
)

SELECT
    kuu,
    kaive,
    LAG(kaive) OVER (ORDER BY kuu) AS eelmine_kuu,
    kaive - LAG(kaive) OVER (ORDER BY kuu) AS muutus,

    ROUND(
        (
            (kaive - LAG(kaive) OVER (ORDER BY kuu))
            / LAG(kaive) OVER (ORDER BY kuu)::numeric
        ) * 100,
        1
    ) AS kasvu_protsent

FROM kuu_myyk
ORDER BY kuu;

--4 ülesanne
--1. Müük kuude kaupa (GROUP BY)
SELECT
    DATE_TRUNC('month', sale_date) AS kuu,
    COUNT(sale_id) AS tellimuste_arv,
    SUM(total_price) AS kogukaive,
    ROUND(AVG(total_price), 2) AS keskmine_tellimus
FROM sales
WHERE sale_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY kuu;

--2. Müük kategooriate kaupa (GROUP BY + HAVING)
SELECT
    p.category,
    COUNT(s.sale_id) AS toodete_arv,
    SUM(s.total_price) AS kogumuuk,
    ROUND(AVG(s.total_price), 2) AS keskmine_hind
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
WHERE s.sale_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY p.category
HAVING SUM(s.total_price) > 10000
ORDER BY kogumuuk DESC;


--3. Kuust-kuusse trend CTE ja window functioniga
WITH kuu_myyk AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS kuu,
        SUM(total_price) AS kaive
    FROM sales
    WHERE sale_date >= '2024-01-01'
    GROUP BY DATE_TRUNC('month', sale_date)
)

SELECT
    kuu,
    kaive,
    LAG(kaive) OVER (ORDER BY kuu) AS eelmine_kuu,

    kaive - LAG(kaive) OVER (ORDER BY kuu) AS muutus,

    ROUND(
        (
            (kaive - LAG(kaive) OVER (ORDER BY kuu))
            / LAG(kaive) OVER (ORDER BY kuu)::numeric
        ) * 100,
        1
    ) AS kasvu_protsent

FROM kuu_myyk
ORDER BY kuu;


--inventuur C
--1. Tootekategooriate koondandmed. Koosta ülevaade kategooriate kaupa:
SELECT
    p.category,
    COUNT(DISTINCT p.product_id) AS tooteid,
    ROUND(AVG(p.cost_price), 2) AS keskmine_hind,
    MIN(p.cost_price) AS min_hind,
    MAX(p.cost_price) AS max_hind
FROM products p
GROUP BY p.category
ORDER BY tooteid DESC;


--2. Müüdud vs laos — kirjuta ise, ühendades products + sales:
SELECT
    p.category,
    SUM(s.quantity) AS muugid_kokku,
    SUM(i.quantity_available) AS laos_kokku,
    ROUND(AVG(s.quantity), 2) AS keskmine_muuk_toote_kohta
FROM products p
JOIN sales s
    ON p.product_id = s.product_id
JOIN inventory i
    ON p.product_id = i.product_id
GROUP BY p.category
HAVING SUM(s.quantity) > 100
ORDER BY muugid_kokku DESC;


--Toodete järjestus kategooria sees — kasuta window function'i:
SELECT
    p.product_name,
    p.category,
    p.cost_price,

    ROW_NUMBER() OVER (
        PARTITION BY p.category
        ORDER BY p.cost_price DESC
    ) AS koht_kategoorias

FROM products p;